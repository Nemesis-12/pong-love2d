-- Declare Base Class
-- This makes sure that we do not need to declare
-- a bunch of empty functions in the other state files
BaseState = Class{}

function BaseState:init() end
function BaseState:enter() end
function BaseState:exit() end
function BaseState:update(dt) end
function BaseState:render() end
