-- Declare State Machine class
-- This state machine was created based on the book 'How to Make an RPG'
-- by Daniel Schuller. Good read especially if you want to start
-- creating RPGs from scratch.
StateMachine = Class{}

-- Initialize State machine
function StateMachine:init(states)
	self.empty = {
		render = function() end,
		update = function() end,
		enter = function() end,
		exit = function() end
	}
	self.states = states or {} -- [name] -> [function that returns states]
	self.current = self.empty
end

-- Change current state
function StateMachine:change(stateName, enterParams)
	assert(self.states[stateName]) -- state must exist!
	self.current:exit()
	self.current = self.states[stateName]()
	self.current:enter(enterParams)
end

-- Update game for current state
function StateMachine:update(dt)
	self.current:update(dt)
end

-- Render objects for current state
function StateMachine:render()
	self.current:render()
end
