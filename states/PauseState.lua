PauseState = Class{__includes = BaseState}

PAUSE = false

function PauseState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0
    self.score = 0
    self.spawnTimer = 0

    -- initialize our last recorded Y value for a gap placement to base other gaps off of
    self.lastY = lastY
    
end


function PauseState:update(dt)
    --PlayState:update(dt)
    --resume game
    if  love.keyboard.keysPressed['p'] then
        
        gStateMachine:change('play', {
            bird = self.bird,
            pipePairs = self.pipePairs,
            timer = self.timer,
            score = self.score,
            spawnTimer = self.spawnTimer,
            lastY = self.lastY
        })
    end

end

--[[
    Called when this state is transitioned to from another state.
]]
function PauseState:enter(params)

    sounds['pause']:play()

    PAUSE = true

    self.bird = params.bird
    self.pipePairs = params.pipePairs
    self.timer = params.timer
    self.score = params.score
    self.spawnTimer = params.spawnTimer
    self.lastY = params.lastY


    -- if we're coming from play, stop scrooling
    scrolling = false
    

end

function PauseState:render()

    

    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    love.graphics.setFont(hugeFont)
    love.graphics.printf(tostring('Pause'), 0, VIRTUAL_HEIGHT/2-50, VIRTUAL_WIDTH, 'center')

    self.bird:render()


    recieveMedal(self.score)
end

--[[
    Called when this state changes to another state.
]]
function PauseState:exit()
    PAUSE = false

    sounds['pause']:play()

    -- resume game so scrooling will be enabled again
    scrolling = true
end
