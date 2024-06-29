local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local PF = TXUI:GetModule("Profiles")

-- Thanks Luckyone
function PF:BigWigs()
  if not F.IsAddOnEnabled("BigWigs") then
    TXUI:LogDebug("BigWigs is not enabled ~ won't setup profile")
    return
  end

  local profileName = "ToxiUI"
  local profileString =
    "BW1:DrvWUTTrquqWyGw4uujNALdThKlckAo4aj5yhyDK2sXwvYsqIQbixkxsnICrxYDXUlLTdYjDkN1NGp0pa9jOB92c9jKpbJ(b0DjfPrRomANz39nV5nZsR)IvjgecuimIkWsmnr8lBGywuHBVwUdhPST(8391ekpgrk3W)Io342zSAV(h(8NVDhkxqjuUyHplLZiq7r2nEZ7SYSo(K08aTmM3ApoKdqsEe7mRtW9OIa2(3dec9222z710NYrjHq7mVtZc1IdZ6LH9ONPDFBU1(XDuzciL4KqXxQWPPscob4dN62)6B6SConrob)j41BnL6ugd4bibeTCoAgiXXWi7MVP1xnBoGMqdI40yiktx6QV6nOyGFC9b1FxJgzyzcOQ5eeHKrRNHfmc6Edm7T2CLH5zFJ7vxFXVTJcRd50BNYUfXNj8wMkaCGw69EiGGeIaJi6vModtBogrWHjJhF97VY9H4Ni1kFepx0)9T6LoOG)udDAsUYC6)1CI5iUWDYjrOz0B7zzzzZ3fQNT(3Yc06zeZgnn2ZoXyp)eBZL7O5esOj0SStCEM034CJ90ZS5laUqpB0Y5dnzheOPHuNMKYrRAlzftpQ9u7z1F)1AmlBu)K67vvwbfPW7Xfyb2NaoiEFCmwwDvMi4QvwN(D66UcUJDfGdJKNUXOFf5rD0JLG8EToNY8CmTdVL6l8b8mz0)uHvP8iJbHeXLEogm84sTyKYHvhx39U69H5sJOmrEpbg3HSy61CbdfO57(BYFqSJbRZ9YG)v18dlYRgnp1lv12XDTR6iN5ycXBBjdmv0HSx8)kxJw)TQFosv9OnftSMyhXEr5nhKsKygbdCZiBZNGCaDHwalBb5Ji1wzWjB9zhWTpi06a)S5In6s8PpaSwltfEF8bNHUUdhy0BU(tbM)TE13SXifD)dxepeKQN9r1a1nwxUpR6LGeHjch9ZPUC9ZIMSQLKOOrpx3N)rv1)EB5ogbyFtP(YS3vN3OX4fuCaW(biz6K21VeMJ0vA9FDaIaV(F)d"

  BigWigsAPI:ImportProfileString(TXUI.Title, profileString, profileName)
end
