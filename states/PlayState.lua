--[[
    PlayState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The PlayState class is the bulk of the game, where the player actually controls the bird and
    avoids pipes. When the player collides with a pipe, we should go to the GameOver state, where
    we then go back to the main menu.
]]

PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

local BRONZEMEDAL_IMAGE = love.graphics.newImage('images/BronzeMedal.png')
local SILVERMEDAL_IMAGE = love.graphics.newImage('images/SilverMedal.png')
local GOLDMEDAL_IMAGE = love.graphics.newImage('images/GoldMedal.png')
local DIAMONDMEDAL_IMAGE =  love.graphics.newImage('images/DiamondMedal.png')

local offsetMAX = 80


function PlayState:init() 

    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0
    self.score = 0
    self.spawnTimer = 0
    self.lastY = 0
    
end

function PlayState:update(dt)
    -- update timer for pipe spawning
    self.timer = self.timer + dt


    -- spawn a new pipe pair every second and a half
    if self.timer > self.spawnTimer then

        makeHarder(self.score)        

        offset = math.random(offsetMAX/2, offsetMAX)
        event = math.random(1,3)

        topLimit = -PIPE_HEIGHT+ 15
        bottomLimit = VIRTUAL_HEIGHT - 30
       
    

        -- modify the last Y coordinate we placed so pipe gaps aren't too far apart
        -- no higher than 10 pixels below the top edge of the screen,
        -- and no lower than a gap length (90 pixels) from the bottom
        -- local y =  math.max(bottomLimit, math.min(self.lastY + math.random(-100, 100),topLimit))
       local y = math.max(-PIPE_HEIGHT + 10, 
       math.min(self.lastY + math.random(-80, 80), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        
        self.lastY = y

        -- add a new pipe pair at the end of the screen at our new Y
        table.insert(self.pipePairs, PipePair(y, offset, event))

        -- reset timer
        self.timer = 0
        self.spawnTimer = (math.random(2,2) + ((math.random(25,100) / 100 )))

    end

  
    -- for every pair of pipes..
    for k, pair in pairs(self.pipePairs) do
        -- score a point if the pipe has gone past the bird to the left all the way
        -- be sure to ignore it if it's already been scored
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
                sounds['score']:play()
            end
        end

        -- update position of pair
        pair:update(dt)
    end

    -- we need this second loop, rather than deleting in the previous loop, because
    -- modifying the table in-place without explicit keys will result in skipping the
    -- next pipe, since all implicit keys (numerical indices) are automatically shifted
    -- down after a table removal
    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    -- simple collision between bird and all pipes in pairs
    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                sounds['explosion']:play()
                sounds['hurt']:play()

                gStateMachine:change('score', {
                    score = self.score,
                    BronzeMedal = BRONZEMEDAL_IMAGE,
                    SilverMedal = SILVERMEDAL_IMAGE,
                    GoldMedal = GOLDMEDAL_IMAGE,
                    DiamondMedal = DIAMONDMEDAL_IMAGE
                })
            end
        end
    end

    

    -- update bird based on gravity and input
    self.bird:update(dt)



    -- enter pause state
    if  love.keyboard.keysPressed['p'] then
        gStateMachine:change('pause', {
            bird =  self.bird,
            pipePairs = self.pipePairs,
            timer = self.timer,
            score = self.score,
            spawnTimer = self.spawnTimer,
            lastY = self.lastY,

        
        })
    end

    -- reset if we get to the ground
    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        sounds['explosion']:play()
        sounds['hurt']:play()

        gStateMachine:change('score', {
            score = self.score,
            BronzeMedal = BRONZEMEDAL_IMAGE,
            SilverMedal = SILVERMEDAL_IMAGE,
            GoldMedal = GOLDMEDAL_IMAGE,
            DiamondMedal = DIAMONDMEDAL_IMAGE
        })
    end

    
end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    recieveMedal(self.score)
   
    self.bird:render()
end

--[[
    Called when this state is transitioned to from another state.
]]
function PlayState:enter(params)

    self.bird = params.bird
    self.pipePairs = params.pipePairs
    self.timer = params.timer
    self.score = params.score
    self.spawnTimer = params.spawnTimer
    self.lastY = params.lastY


    -- if we're coming from death, restart scrolling
    scrolling = true
end

--[[
    Called when this state changes to another state.
]]
function PlayState:exit()
    -- stop scrolling for the death/score screen
    scrolling = false
end


function recieveMedal(score) 
    if score > 24 then
        love.graphics.draw(DIAMONDMEDAL_IMAGE, 10,33) 
    elseif score > 14 then
        love.graphics.draw(GOLDMEDAL_IMAGE, 10,33)    
    elseif score > 9 then
        love.graphics.draw(SILVERMEDAL_IMAGE, 10,33)
    elseif score > 4 then
        love.graphics.draw(BRONZEMEDAL_IMAGE, 10,33)    
    end
end

function makeHarder(score) 
    if score % 3 == 0 and score ~= 0 then
        if offsetMAX == 20 then
            return
        end
        offsetMAX = offsetMAX - 10
    end
end