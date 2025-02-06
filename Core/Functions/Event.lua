local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local next = next
local pairs = pairs
local rawset = rawset
local securecallfunction = securecallfunction
local secureexecuterange = secureexecuterange
local select = select
local type = type
local unpack = unpack
local C_Timer_After = C_Timer.After

F.Event = {}

do
  local closureGeneration = {
    function(f)
      return function(...)
        return f(...)
      end
    end,
    function(f, a)
      return function(...)
        return f(a, ...)
      end
    end,
    function(f, a, b)
      return function(...)
        return f(a, b, ...)
      end
    end,
    function(f, a, b, c)
      return function(...)
        return f(a, b, c, ...)
      end
    end,
    function(f, a, b, c, d)
      return function(...)
        return f(a, b, c, d, ...)
      end
    end,
    function(f, a, b, c, d, e)
      return function(...)
        return f(a, b, c, d, e, ...)
      end
    end,
    function(f, a, b, c, d, e, g)
      return function(...)
        return f(a, b, c, d, e, g, ...)
      end
    end,
  }

  function F.Event.GenerateClosure(f, ...)
    local count = select("#", ...)
    local generator = closureGeneration[count + 1]
    if generator then return generator(f, ...) end
    TXUI:ThrowError("Closure generation does not support more than " .. (#closureGeneration - 1) .. " parameters")
  end
end

function F.Event.RunNextFrame(callback, delay)
  C_Timer_After(delay or 0, callback)
end

function F.Event.CreateCounter(initialCount)
  local count = initialCount or 0
  local counter = function()
    count = count + 1
    return count
  end
  return function()
    return securecallfunction(counter)
  end
end

do
  local generateOwnerIdCounter = F.Event.CreateCounter()
  function F.Event.GenerateOwnerId()
    return generateOwnerIdCounter()
  end
end

do
  local InsertEventAttribute = "insert-secure-event"
  local callbackType = F.Enum { "CLOSURE", "FUNCTION" }
  local callbackTables = {}
  for _, value in pairs(callbackType) do
    callbackTables[value] = {}
  end

  local eventFrame = CreateFrame("Frame")
  local attributeDelegate = CreateFrame("FRAME")
  attributeDelegate:SetScript("OnAttributeChanged", function(_, attribute, value)
    if attribute == InsertEventAttribute then
      local event = securecallfunction(unpack, value)
      if type(event) ~= "string" then return TXUI:ThrowError("'event' requires string type", event) end
      for _, callbackTable in pairs(callbackTables) do
        if not callbackTable[event] then rawset(callbackTable, event, {}) end
      end
    end
  end)

  function F.Event.GetCallbacksByEvent(callType, event)
    return callbackTables[callType][event]
  end

  function F.Event.HasRegistrantsForEvent(event)
    for _, callbackTable in pairs(callbackTables) do
      local callbacks = callbackTable[event]
      if callbacks and securecallfunction(next, callbacks) then return true end
    end
    return false
  end

  function F.Event.SecureInsertEvent(event)
    if not F.Event.HasRegistrantsForEvent(event) then attributeDelegate:SetAttribute(InsertEventAttribute, { event }) end
  end

  function F.Event.RegisterCallback(event, func, owner, ...)
    if type(event) ~= "string" then
      return TXUI:ThrowError("RegisterCallback 'event' requires string type.", event)
    elseif type(func) ~= "function" then
      return TXUI:ThrowError("RegisterCallback 'func' requires function type.", event)
    else
      if owner == nil then
        owner = F.Event.GenerateOwnerId()
      elseif type(owner) == "number" then
        return TXUI:ThrowError("RegisterCallback 'owner' as number is reserved internally.")
      end
    end

    F.Event.SecureInsertEvent(event)

    for _, callbackTable in pairs(callbackTables) do
      local callbacks = callbackTable[event]
      callbacks[owner] = nil
    end

    local count = select("#", ...)
    if count > 0 then
      local callbacks = F.Event.GetCallbacksByEvent(callbackType.CLOSURE, event)
      callbacks[owner] = F.Event.GenerateClosure(func, owner, ...)
    else
      local callbacks = F.Event.GetCallbacksByEvent(callbackType.FUNCTION, event)
      callbacks[owner] = func
    end

    return owner
  end

  function F.Event.TriggerEvent(event, ...)
    if type(event) ~= "string" then return TXUI:ThrowError("TriggerEvent 'event' requires string type.", event) end

    local closures = F.Event.GetCallbacksByEvent(callbackType.CLOSURE, event)
    if closures then
      local function CallbackRegistryExecuteClosurePair(_, closure, ...)
        securecallfunction(closure, ...)
      end

      secureexecuterange(F.Table.Join({}, closures), CallbackRegistryExecuteClosurePair, ...)
    end

    local funcs = F.Event.GetCallbacksByEvent(callbackType.FUNCTION, event)
    if funcs then
      local function CallbackRegistryExecuteOwnerPair(owner, func, ...)
        securecallfunction(func, owner, ...)
      end

      secureexecuterange(F.Table.Join({}, funcs), CallbackRegistryExecuteOwnerPair, ...)
    end
  end

  function F.Event.OnAttributeChanged(_, frameEvent, value)
    if value == 0 then
      eventFrame:UnregisterEvent(frameEvent)
    elseif value == 1 then
      eventFrame:RegisterEvent(frameEvent)
    end
  end

  function F.Event.RegisterFrameEvent(frameEvent)
    eventFrame:SetAttribute(frameEvent, (eventFrame:GetAttribute(frameEvent) or 0) + 1)
  end

  function F.Event.UnregisterFrameEvent(frameEvent)
    local eventCount = eventFrame:GetAttribute(frameEvent) or 0
    if eventCount > 0 then eventFrame:SetAttribute(frameEvent, eventCount - 1) end
  end

  function F.Event.RegisterFrameEventAndCallback(frameEvent, ...)
    F.Event.RegisterFrameEvent(frameEvent)
    return F.Event.RegisterCallback(frameEvent, ...)
  end

  local function createCallbackHandle(event, owner)
    local handle = {
      Unregister = function()
        F.Event.UnregisterCallback(event, owner)
      end,
    }
    return handle
  end

  local function createCallbackHandleFrameEvent(cbrHandle, frameEvent)
    local handle = {
      Unregister = function()
        F.Event.UnregisterFrameEvent(frameEvent)
        cbrHandle:Unregister()
      end,
    }
    return handle
  end

  function F.Event.RegisterCallbackWithHandle(event, func, owner, ...)
    owner = F.Event.RegisterCallback(event, func, owner, ...)
    return createCallbackHandle(event, owner)
  end

  function F.Event.RegisterFrameEventAndCallbackWithHandle(frameEvent, ...)
    F.Event.RegisterFrameEvent(frameEvent)
    local cbrHandle = F.Event.RegisterCallbackWithHandle(frameEvent, ...)
    return createCallbackHandleFrameEvent(cbrHandle, frameEvent)
  end

  function F.Event.UnregisterCallback(event, owner)
    if type(event) ~= "string" then
      TXUI:ThrowError("UnregisterCallback 'event' requires string type", event)
    elseif owner == nil then
      TXUI:ThrowError("UnregisterCallback 'owner' is required", owner)
    end

    for _, callbackTable in pairs(callbackTables) do
      local callbacks = callbackTable[event]
      if callbacks then callbacks[owner] = nil end
    end
  end

  function F.Event.UnregisterFrameEventAndCallback(frameEvent, ...)
    F.Event.UnregisterFrameEvent(frameEvent)
    F.Event.UnregisterCallback(frameEvent, ...)
  end

  function F.Event.RegisterOnceCallback(frameEvent, callback)
    local handle = nil

    local CallbackWrapper = function(_, ...)
      handle:Unregister()
      callback(...)
    end

    handle = F.Event.RegisterCallbackWithHandle(frameEvent, CallbackWrapper)
  end

  function F.Event.RegisterOnceFrameEventAndCallback(frameEvent, callback, ...)
    local handle = nil
    local requiredEventArgs = F.Table.SafePack(...)
    local CallbackWrapper = function(_, ...)
      for i = 1, select("#", ...) do
        if select(i, ...) ~= requiredEventArgs[i] then return end
      end

      handle:Unregister()
      callback(...)
    end

    handle = F.Event.RegisterFrameEventAndCallbackWithHandle(frameEvent, CallbackWrapper)
  end

  function F.Event.ContinueOnAddOnLoaded(addOnName, callback)
    EventUtil.ContinueOnAddOnLoaded(addOnName, callback)
  end

  function F.Event.ContinueOutOfCombat(callback)
    if not InCombatLockdown() then
      callback()
      return
    end

    F.Event.RegisterOnceFrameEventAndCallback("PLAYER_REGEN_ENABLED", callback)
  end

  function F.Event.ContinueToxiUIInitialized(callback)
    if TXUI.initialized then
      callback()
      return
    end

    F.Event.RegisterOnceCallback("TXUI.Initialized", callback)
  end

  function F.Event.ContinueToxiUIInitializedSafe(callback)
    if TXUI.initializedSafe then
      callback()
      return
    end

    F.Event.RegisterOnceCallback("TXUI.InitializedSafe", callback)
  end

  function F.Event.ContinueAfter(cmp, callback)
    if cmp() == true then
      callback()
      return
    end

    local checkWrapper
    checkWrapper = function()
      if cmp() == true then
        callback()
        return
      end

      C_Timer_After(0.2, checkWrapper)
    end

    C_Timer_After(0.2, checkWrapper)
  end

  do
    local elvUpdating = false
    local elvUFUpdating = false

    TXUI:RawHook(E, "UpdateStart", function(...)
      elvUpdating = true
      TXUI.hooks[E]["UpdateStart"](...)
    end)

    TXUI:RawHook(E, "UpdateEnd", function(...)
      TXUI.hooks[E]["UpdateEnd"](...)
      elvUpdating = false
    end)

    local eUF = E:GetModule("UnitFrames")
    TXUI:RawHook(eUF, "Update_AllFrames", function(...)
      elvUFUpdating = true
      TXUI.hooks[eUF]["Update_AllFrames"](...)
      elvUFUpdating = false
    end)

    function F.Event.ContinueAfterElvUIUpdate(callback)
      F.Event.ContinueAfter(function()
        return not (elvUpdating or elvUFUpdating or E.staggerUpdateRunning)
      end, callback)
    end
  end

  function F.Event.ContinueAfterAllEvents(callback, ...)
    local events = {}
    local owner = { id = F.Event.GenerateOwnerId() }

    local function haveReceivedAllEvents()
      for _, received in pairs(events) do
        if not received then return false end
      end

      return true
    end

    local count = select("#", ...)
    for index = 1, count do
      local event = select(index, ...)
      events[event] = false

      local function onEventReceived()
        events[event] = true

        F.Event.UnregisterFrameEventAndCallback(event, owner)

        if haveReceivedAllEvents() then callback() end
      end

      F.Event.RegisterFrameEventAndCallback(event, onEventReceived, owner)
    end
  end

  eventFrame:SetScript("OnAttributeChanged", F.Event.OnAttributeChanged)
  eventFrame:SetScript("OnEvent", function(_, event, ...)
    F.Event.TriggerEvent(event, ...)
  end)
end
