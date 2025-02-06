local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local ST = TXUI:NewModule("Styles")
local SS = TXUI:GetModule("SplashScreen")

function ST:StyleMovers()
  local pf = self:BuildActionBarsProfile()

  -- Process all movers
  F.ProcessMovers(pf)

  -- Use Debug output in development mode
  local crushFnc = TXUI.DevRelease and F.Table.CrushDebug or F.Table.Crush

  -- Merge Tables
  crushFnc(E.db.movers, pf.movers)

  F.Event.RunNextFrame(function()
    F.Event.ContinueAfterElvUIUpdate(function()
      E:StaggeredUpdateAll()
      SS:Hide()
      TXUI:LogInfo("ActionBars Style applied. Please reload your UI!")
    end)
  end, 0.2)
end

function ST:ApplyStyle(styleType, style, dontReload)
  local pf

  E.db.TXUI.styles[styleType] = style
  if styleType == "actionBars" then
    pf = self:BuildActionBarsProfile()
  elseif styleType == "unitFrames" then
    pf = self:BuildUnitFramesProfile()
  else
    TXUI:LogDebug("Styles > Invalid styleType provided")
    return
  end

  SS:Wrap("Applying " .. style .. " style", function()
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
  end, true)
end

TXUI:RegisterModule(ST:GetName())
