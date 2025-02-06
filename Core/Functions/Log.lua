local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

F.Log = {}

local _G = _G
local type = type
local tostring = tostring
local strrep = strrep
local pairs = pairs
local strlen = strlen
local format = string.format
local tconcat = table.concat
local tinsert = table.insert
local ipairs = ipairs

local IsAddOnLoaded = (C_AddOns and C_AddOns.IsAddOnLoaded) or IsAddOnLoaded

local DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME

function F.Log.Dump(...)
  local out

  local function addLine(str, delim)
    if not out then
      out = (str or "")
      return
    end

    out = out .. (delim or " ") .. (str or "")
  end

  local function addNewLine(str)
    addLine(str, "\n")
  end

  local args = F.Table.SafePack(...)
  for i = 1, args.n do
    local obj = args[i]

    if type(obj) == "table" then
      local cache = {}

      local function lineLoop(subject, indent)
        if cache[tostring(subject)] then
          addNewLine(indent .. "*" .. tostring(subject))
        else
          cache[tostring(subject)] = true
          if type(subject) == "table" then
            for pos, val in pairs(subject) do
              if type(val) == "table" then
                addNewLine(indent .. "[" .. tostring(pos) .. "] => " .. tostring(subject) .. " {")
                lineLoop(val, indent .. strrep(" ", strlen(pos) + 8))
                addNewLine(indent .. strrep(" ", strlen(pos) + 6) .. "}")
              elseif type(val) == "string" then
                addNewLine(indent .. "[" .. tostring(pos) .. "] => \"" .. val .. "\"")
              else
                addNewLine(indent .. "[" .. tostring(pos) .. "] => " .. tostring(val))
              end
            end
          else
            addNewLine(indent .. tostring(subject))
          end
        end
      end

      if type(obj) == "table" then
        addNewLine(tostring(obj) .. " {")
        lineLoop(obj, "  ")
        addNewLine("}")
      else
        lineLoop(obj, "  ")
      end

      addNewLine()
    elseif type(obj) == "string" then
      addLine(obj)
    else
      addLine("(" .. type(obj) .. ") " .. tostring(obj))
    end
  end

  return out
end

function F.Log.ThrowError(_, ...)
  _G.geterrorhandler()(format("%s %s\n%s", TXUI.Title, F.String.Error("[ERROR]"), F.Log.Dump(...)))
end

function F.Log.Print(str)
  local chatRedirect = E.db and E.db.general and _G[E.db.general.messageRedirect] or DEFAULT_CHAT_FRAME
  chatRedirect:AddMessage(str)
  if _G["DLAPI"] then _G["DLAPI"].DebugLog(TXUI.Title, str) end
end

do
  local messages = {}
  function F.Log.PrintDelayedMessages()
    for _, msg in ipairs(messages) do
      F.Log.Print(msg)
    end

    messages = {}
  end

  function F.Log.AddDelayedMessage(str)
    tinsert(messages, str)
  end
end

function F.Log.Dev(var, varName)
  if TXUI.DevRelease and IsAddOnLoaded("DevTool") then
    local DevTool = _G["DevTool"]
    DevTool:AddData(var, varName)
  end
end

do
  local stringHolder
  function F.Log.PrintWithArguments(parent, color, ...)
    -- Add title if string holder is empty
    if not stringHolder then stringHolder = { TXUI.Title } end

    -- detects the parent
    if parent == TXUI then
      stringHolder[2] = F.String.Good("(TXUI)")
    elseif parent.GetName then
      stringHolder[2] = F.String.Good("(" .. parent:GetName() .. ")")
    else
      stringHolder[2] = F.String.Good("(" .. tostring(parent) .. ")")
    end

    stringHolder[3] = F.String.Color(F.Log.Dump(...), color)

    if not TXUI.DelayedWorldEntered then
      F.Log.AddDelayedMessage(tconcat(stringHolder, " "))
    else
      F.Log.Print(tconcat(stringHolder, " "))
    end
  end
end

function F.Log.Warning(parent, ...)
  if TXUI.LogLevel < 2 then return end
  F.Log.PrintWithArguments(parent, I.Enum.Colors.WARNING, F.String.Error("[WARNING]"), ...)
end

function F.Log.Info(parent, ...)
  if TXUI.LogLevel < 3 then return end
  F.Log.PrintWithArguments(parent, I.Enum.Colors.WHITE, ...)
end

function F.Log.Debug(parent, ...)
  if TXUI.LogLevel < 4 then return end
  F.Log.PrintWithArguments(parent, I.Enum.Colors.WARNING, F.String.Good("[DEBUG]"), ...)
end

function F.Log.Trace(parent, ...)
  if TXUI.LogLevel < 5 then return end
  F.Log.PrintWithArguments(parent, I.Enum.Colors.WARNING, F.String.Luxthos("[TRACE]"), ...)
end

function F.Log.InjectLogger(module)
  if not module or type(module) ~= "table" then
    F.Log.ThrowError("Module logger injection: Invalid module.")
    return
  end

  module.LogWarning = F.Log.Warning
  module.LogInfo = F.Log.Info
  module.LogDebug = F.Log.Debug
  module.LogTrace = F.Log.Trace
  module.ThrowError = F.Log.ThrowError
end
