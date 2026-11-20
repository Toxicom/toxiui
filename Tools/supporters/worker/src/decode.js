// Decodes the string produced by `/tx export names` (Core/Export.lua):
//   base64( raw deflate( CBOR({ ["Name-Realm"] = true, ..., __META_FLAVOR__ = <I.Enum.Flavor index> }) ) )

// Mirrors I.Enum.Flavor in Core/InternalEnum.lua (1-based)
export const FLAVORS = [null, "CLASSIC_ERA", "CLASSIC", "RETAIL", "ANNIVERSARY", "FOREVER"];

export const FLAVOR_LABELS = {
  RETAIL: "Retail",
  CLASSIC: "Classic",
  ANNIVERSARY: "Anniversary",
  CLASSIC_ERA: "Classic Era",
  FOREVER: "Forever",
};

const MAX_INPUT_LENGTH = 6000;
const MAX_DECOMPRESSED_BYTES = 64 * 1024;
const MAX_NAMES = 200;

// WoW character names are letters only (2-12). Realms are passed through E:ShortenRealm (spaces and dashes removed),
// e.g. "TarrenMill", "Mal'Ganis", "Area52", "Aggra(Português)"
const NAME_REALM = /^[\p{L}\p{M}]{2,12}-[\p{L}\p{M}\p{N}'().]{2,40}$/u;
// Forever profile keys are "First Last" (or just "First") without a realm
const FOREVER_NAME = /^[\p{L}\p{M}]{2,20}( [\p{L}\p{M}']{2,20})?$/u;

export class DecodeError extends Error {}

function base64ToBytes(input) {
  const clean = input.replace(/\s+/g, "");
  if (!clean || !/^[A-Za-z0-9+/]+={0,2}$/.test(clean)) throw new DecodeError("That doesn't look like a `/tx export names` string.");
  const bin = atob(clean);
  const bytes = new Uint8Array(bin.length);
  for (let i = 0; i < bin.length; i++) bytes[i] = bin.charCodeAt(i);
  return bytes;
}

async function inflateRaw(bytes) {
  const reader = new Blob([bytes]).stream().pipeThrough(new DecompressionStream("deflate-raw")).getReader();
  const chunks = [];
  let total = 0;
  while (true) {
    const { done, value } = await reader.read();
    if (done) break;
    total += value.length;
    if (total > MAX_DECOMPRESSED_BYTES) throw new DecodeError("Export is too large.");
    chunks.push(value);
  }
  const out = new Uint8Array(total);
  let offset = 0;
  for (const c of chunks) {
    out.set(c, offset);
    offset += c.length;
  }
  return out;
}

// Minimal CBOR decoder covering what C_EncodingUtil.SerializeCBOR emits for a flat table
function decodeCBOR(bytes) {
  const view = new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength);
  const text = new TextDecoder("utf-8", { fatal: true });
  let p = 0;

  const need = (n) => {
    if (p + n > bytes.length) throw new DecodeError("Export is truncated.");
  };
  const readLength = (ai) => {
    if (ai < 24) return ai;
    if (ai === 24) return need(1), bytes[p++];
    if (ai === 25) return need(2), (p += 2), view.getUint16(p - 2);
    if (ai === 26) return need(4), (p += 4), view.getUint32(p - 4);
    throw new DecodeError("Unsupported CBOR length.");
  };

  const item = (depth) => {
    if (depth > 4) throw new DecodeError("Export is nested too deeply.");
    need(1);
    const b = bytes[p++];
    const major = b >> 5;
    const ai = b & 31;
    switch (major) {
      case 0:
        return readLength(ai);
      case 1:
        return -1 - readLength(ai);
      case 2:
      case 3: {
        const len = readLength(ai);
        need(len);
        // Lua strings are emitted as byte strings (major 2), not text strings, so decode both as UTF-8
        return text.decode(bytes.subarray(p, (p += len)));
      }
      case 4: {
        const len = readLength(ai);
        const arr = [];
        for (let i = 0; i < len; i++) arr.push(item(depth + 1));
        return arr;
      }
      case 5: {
        const len = readLength(ai);
        const obj = new Map();
        for (let i = 0; i < len; i++) {
          const k = item(depth + 1);
          obj.set(k, item(depth + 1));
        }
        return obj;
      }
      case 7:
        if (ai === 20) return false;
        if (ai === 21) return true;
        if (ai === 22) return null;
        if (ai === 27) return need(8), (p += 8), view.getFloat64(p - 8);
        throw new DecodeError("Unsupported CBOR value.");
      default:
        throw new DecodeError("Unsupported CBOR type.");
    }
  };

  const root = item(0);
  if (p !== bytes.length) throw new DecodeError("Export has trailing data.");
  return root;
}

export function isValidName(name, flavor) {
  return (flavor === "FOREVER" ? FOREVER_NAME : NAME_REALM).test(name);
}

/**
 * @returns {Promise<{ flavor: string, names: string[], invalid: string[] }>}
 */
export async function decodeExport(input) {
  if (typeof input !== "string" || input.length > MAX_INPUT_LENGTH) throw new DecodeError("Export is missing or too long.");

  let root;
  try {
    root = decodeCBOR(await inflateRaw(base64ToBytes(input)));
  } catch (err) {
    if (err instanceof DecodeError) throw err;
    throw new DecodeError("Couldn't read that export. Copy the whole string from `/tx export names` and try again.");
  }
  if (!(root instanceof Map)) throw new DecodeError("Unexpected export format.");

  // Old exports without the meta key were Retail-only (same fallback as `/tx dev export names`)
  const meta = root.get("__META_FLAVOR__");
  const flavor = typeof meta === "number" ? FLAVORS[meta] : "RETAIL";
  if (!flavor) throw new DecodeError("Unknown game version in export.");

  const names = [];
  const invalid = [];
  for (const [key, value] of root) {
    if (key === "__META_FLAVOR__" || value !== true) continue;
    if (typeof key === "string" && isValidName(key, flavor)) names.push(key);
    else invalid.push(String(key).slice(0, 40));
  }

  if (names.length === 0) throw new DecodeError("No characters found in that export.");
  if (names.length > MAX_NAMES) throw new DecodeError(`Too many characters (${names.length}, max ${MAX_NAMES}).`);

  names.sort();
  return { flavor, names, invalid };
}
