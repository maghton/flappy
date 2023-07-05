--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class{__includes = BaseState}

local playedBronzeMedalSound = false
local playedSilverMedalSound = false
local playedGoldMedalSound = false
local playedDiamondMedalSound = false
local time = 0

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
function ScoreState:enter(params)
    self.score = params.score
    self.BronzeMedal = params.BronzeMedal
    self.SilverMedal = params.SilverMedal
    self.GoldMedal = params.GoldMedal
    self.DiamondMedal = params.DiamondMedal
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end

    time = time + dt
    
    playMedalsSound(self.score,time)    
     
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')
    

    renderMedals(self.BronzeMedal,self.SilverMedal,self.GoldMedal,self.DiamondMedal)

    love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')

end

function playMedalsSound(score,time) 
    if score > 3 and time > 3 then
        if playedDiamondMedalSound == false then
            playedDiamondMedalSound = true
            sounds['diamondMedal']:play()
        end
    end
    if score > 2 and time > 2.25 then
        if playedGoldMedalSound == false then
            playedGoldMedalSound = true
            sounds['goldMedal']:play()
        end
       
    end   
    if score > 1 and time > 1.5  then
        if playedSilverMedalSound == false then
            playedSilverMedalSound = true
            sounds['silverMedal']:play()
        end
        
    end
    if score > 0 and time > 0.75 then
        if playedBronzeMedalSound == false then
            playedBronzeMedalSound = true
            sounds['bronzeMedal']:play()
        end
          
    end
end

function renderMedals(BronzeMedal,SilverMedal,GoldMedal,DiamondMedal)
    if playedDiamondMedalSound == true then
        love.graphics.draw(DiamondMedal, 310,120) 
    end

    if playedGoldMedalSound == true then
        love.graphics.draw(GoldMedal, 260,120)
    end

    if playedSilverMedalSound == true then
        love.graphics.draw(SilverMedal, 210,120)
    end

    if playedBronzeMedalSound == true then
        love.graphics.draw(BronzeMedal, 150,120) 
    end
end