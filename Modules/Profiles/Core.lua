local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local PF = TXUI:NewModule("Profiles", "AceHook-3.0")

function PF:MergeElvUIProfile()
  local pf = self:BuildProfile()

  -- Use Debug output in development mode
  local crushFnc = TXUI.DevRelease and F.Table.CrushDebug or F.Table.Crush

  -- Merge Tables
  crushFnc(E.db, pf)

  -- Set Globals
  crushFnc(E.global, {
    uiScaleInformed = true,

    general = {
      commandBarSetting = "DISABLED",
      UIScale = F.PixelPerfect(),
    },
  })
end

function PF:ElvUIProfileMovers(callback)
  local pf = self:BuildProfile()

  -- Process all movers
  F.ProcessMovers(pf)

  -- Use Debug output in development mode
  local crushFnc = TXUI.DevRelease and F.Table.CrushDebug or F.Table.Crush

  -- Merge Tables
  crushFnc(E.db.movers, pf.movers)

  F.Event.RunNextFrame(function()
    F.Event.ContinueAfterElvUIUpdate(function()
      E:StaggeredUpdateAll()
      if callback then F.Event.ContinueAfterElvUIUpdate(callback) end
    end)
  end, 0.2)
end

function PF:ExecuteElvUIUpdate(callback, noMovers)
  -- Update ElvUI
  F.Event.RunNextFrame(function()
    F.Event.ContinueAfterElvUIUpdate(function()
      E:StaggeredUpdateAll()

      if not noMovers then
        F.Event.ContinueAfterElvUIUpdate(F.Event.GenerateClosure(self.ElvUIProfileMovers, self, callback))
      else
        F.Event.ContinueAfterElvUIUpdate(callback)
      end
    end)
  end, 0.2)
end

-- Initialization
function PF:Initialize()
  -- Don't init second time
  if self.Initialized then return end

  -- We actually don't need todo anything, everything is handled by the installer

  -- We are done, hooray!
  self.Initialized = true
end

TXUI:RegisterModule(PF:GetName())
