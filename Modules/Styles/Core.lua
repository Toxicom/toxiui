local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local ST = TXUI:NewModule("Styles")
local PF = TXUI:GetModule("Profiles")

function ST:StyleMovers()
  local pf = self:BuildActionBarsProfile()

  -- Process all movers
  PF:ProcessMovers(pf)

  -- Use Debug output in development mode
  local crushFnc = TXUI.DevRelease and F.Table.CrushDebug or F.Table.Crush

  -- Merge Tables
  crushFnc(E.db.movers, pf.movers)

  F.Event.RunNextFrame(function()
    F.Event.ContinueAfterElvUIUpdate(function()
      E:StaggeredUpdateAll()
      TXUI:GetModule("SplashScreen"):Hide()
    end)
  end, 0.2)
end

function ST:ApplyStyle(styleType, style, dontReload)
  local pf = {}

  if styleType == "actionBars" then
    E.db.TXUI.styles[styleType] = style
    pf = self:BuildActionBarsProfile()
  elseif styleType == "unitFrames" then
    print("unitframes style apply")
  else
    TXUI:LogDebug("Styles > Invalid styleType provided")
    return
  end

  local crushFnc = TXUI.DevRelease and F.Table.CrushDebug or F.Table.Crush

  -- Merge Tables
  crushFnc(E.db, pf)

  -- Update ElvUI
  F.Event.RunNextFrame(function()
    F.Event.ContinueAfterElvUIUpdate(function()
      E:StaggeredUpdateAll()

      F.Event.ContinueAfterElvUIUpdate(F.Event.GenerateClosure(self.StyleMovers, self))
    end)
  end, 0.2)

  if not dontReload then E:StaticPopup_Show("CONFIG_RL") end
end

TXUI:RegisterModule(ST:GetName())
