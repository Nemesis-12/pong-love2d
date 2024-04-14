PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.player1 = Paddle()
    self.paused = false
end

function PlayState:update(dt)
    
end