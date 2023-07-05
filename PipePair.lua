--[[
    PipePair Class

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Used to represent a pair of pipes that stick together as they scroll, providing an opening
    for the player to jump through in order to score a point.
]]

PipePair = Class{}

-- size of the gap between pipes
local GAP_HEIGHT = 90

--local TOP_MAX = -PIPE_HEIGHT+20
--local BOTTOM_MAX_without_VIRTUAL_HEIGHT = - 120  - PIPE_HEIGHT



function PipePair:init(y,offset,event)
    -- flag to hold whether this pair has been scored (jumped through)
    self.scored = false

    -- initialize pipes past the end of the screen
    self.x = VIRTUAL_WIDTH + 32

    -- y value is for the topmost pipe; gap is a vertical shift of the second lower pipe
    self.y = y

    -- instantiate two pipes that belong to this pair
    
    topPipeY = self.y 
    bottomPipeY = self.y + PIPE_HEIGHT + GAP_HEIGHT 


    if event then
        topPipeY =  topPipeY - offset/2 -- startet weiter oben
        bottomPipeY  = bottomPipeY  + offset/2 -- startet weiter unten
    end    

    --[[
    if event % 3 == 0 then
        topPipeY = topPipeY - offset    
    elseif event % 3 == 1 then
        bottomPipeY  = bottomPipeY  + offset
    elseif event % 3 == 2 then
        topPipeY = topPipeY - offset/2
        bottomPipeY  = bottomPipeY  + offset/2
    end
    ]]


    

    --checkForMaxValues(topPipeY,bottomPipeY,topLimit,bottomLimit)
    -- topPipeY = -PIPE_HEIGHT+ 10 
    --bottomPipeY = VIRTUAL_HEIGHT - 30
   

    if topPipeY < -PIPE_HEIGHT+ 15  then
        topPipeY = -PIPE_HEIGHT+ 15 
    end
    if bottomPipeY > VIRTUAL_HEIGHT - 30 then
        bottomPipeY  = VIRTUAL_HEIGHT - 30
    end
    

    self.pipes = {
        ['upper'] = Pipe('top', topPipeY),
        ['lower'] = Pipe('bottom', bottomPipeY)
    }

    -- whether this pipe pair is ready to be removed from the scene
    self.remove = false
end

function PipePair:update(dt)
    -- remove the pipe from the scene if it's beyond the left edge of the screen,
    -- else move it from right to left
    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x
    else
        self.remove = true
    end
end

function PipePair:render()
    for l, pipe in pairs(self.pipes) do
        pipe:render()
    end
end

function PipePair:checkForMaxValues(top,bottom,topLimit,bottomLimit)
    if top > -PIPE_HEIGHT+ 10  then
        self.topPipeY = -PIPE_HEIGHT+ 10 
    end
    if bottom > VIRTUAL_HEIGHT - 30 then
        self.bottomPipeY  = VIRTUAL_HEIGHT - 30
    end
end