local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")
local M = TXUI:GetModule("Misc")

function O:Performance()
  local options = self.options.performance.args

  -- Reset order for new page
  self:ResetOrder()

  do
    -- ToxiUI Website Group
    local performanceProfiler = self:AddInlineDesc(options, {
      name = "AddOn Profiler",
    }, {
      name = "To no one's surprise, recent Blizzard's AddOn Profiler is tanking FPS. Luckyone has found a solution.\n\n",
    }).args

    -- ToxiUI Website URL
    performanceProfiler.tweet = {
      order = self:GetOrder(),
      type = "input",
      width = "full",
      name = "",
      get = function()
        return "https://x.com/Luckyone961/status/1901392733790494908"
      end,
    }

    -- Spacer
    self:AddSpacer(performanceProfiler)

    -- ToxiUI Logo
    performanceProfiler.profilerToggle = {
      order = self:GetOrder(),
      type = "toggle",
      name = function()
        return self:GetEnableName(E.db.TXUI.performance.profiler, performanceProfiler)
      end,
      set = function(_, value)
        E.db.TXUI.performance.profiler = value
        M:Performance()
      end,
      get = function()
        return E.db.TXUI.performance.profiler
      end,
    }
  end
end

O:AddCallback("Performance")
