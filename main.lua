function love.load()
   -- Player 1
   p1_x = 20
   p1_y = 100
   p1_score = 0
   p1_width = 20
   p1_height = 200
   p1_speed = 400

   -- Player 2
   p2_x = 760
   p2_y = 100
   p2_score = 0
   p2_width = 20
   p2_height = 200
   p2_speed = 400

   -- Ball
   ball_x = 380
   ball_y = 280
   ball_xvel = 0
   ball_yvel = 0
   ball_width = 40
   ball_height = ball_width
   ball_difficulty = 0.25
   ball_max = 6

   -- Sound
   beep_length = 0.125
   beep_rate = 44100
   beep_bits = 16
   beep_channel = 1
   beep_amplitude = 0.2

   wall_sound = love.sound.newSoundData(beep_length * beep_rate, beep_rate, beep_bits, beep_channel)
   paddle_sound = love.sound.newSoundData(beep_length * beep_rate, beep_rate, beep_bits, beep_channel)

   pitch_a = Oscillator(440)
   pitch_c = Oscillator(522)
   
   for i=1,beep_length*beep_rate do
      wall_sample = pitch_a() * beep_amplitude
      wall_sound:setSample(i, wall_sample)
      paddle_sample = pitch_c() * beep_amplitude
      paddle_sound:setSample(i, paddle_sample)
   end

   wall_beep = love.audio.newSource(wall_sound)
   paddle_beep = love.audio.newSource(paddle_sound)
end

function love.draw()
   love.graphics.print( p1_score, 150, 0 )
   love.graphics.print( p2_score, 650, 0 )
   love.graphics.print( ball_xvel, 300, 0 )
   love.graphics.rectangle("line", p1_x, p1_y, p1_width, p1_height)
   love.graphics.rectangle("line", p2_x, p2_y, p2_width, p2_height)
   love.graphics.rectangle("fill", ball_x, ball_y, ball_width, ball_height)
   
end

function love.update(dt)
   -- Player Movement
   if love.keyboard.isDown("w") then
      if p1_y > -10 then
	 p1_y = p1_y - (p1_speed * dt) 
      end
   end 

   if love.keyboard.isDown("s") then
      if p1_y < 410 then
	 p1_y = p1_y + (p1_speed * dt) 
      end
   end 

   if love.keyboard.isDown("up") then
      if p2_y > -10 then
	 p2_y = p2_y - (p2_speed * dt) 
      end
   end 

   if love.keyboard.isDown("down") then
      if p2_y < 410 then
	 p2_y = p2_y + (p2_speed * dt) 
      end
   end 

   ball_move(dt)

end


function love.keypressed(key)
   if ball_xvel == 0 and ball_yvel == 0 then
      if key == "c" then
	 ball_xvel = 1
	 ball_yvel = 1
      end
   end
      
   if key == "escape" then
      love.event.quit()
   end
end


function ball_move(dt)
   -- Wall Collisions
   -- Scoring
   if ball_x < 0 then
      p2_score = p2_score + 1
      ball_xvel = 0
      ball_yvel = 0
      ball_x = 380
      ball_y = 280
      ball_difficulty = 0.5
   end
   
   if ball_x > 760 then
      p1_score = p1_score + 1
      ball_xvel = 0
      ball_yvel = 0
      ball_x = 380
      ball_y = 280
      ball_difficulty = 0.5
   end
   -- Bouncing
   if ball_y < 0 or ball_y > 560 then
      ball_yvel = ball_yvel * -1
      love.audio.play(wall_beep)
   end
   
   -- Player Collisions
   -- Difficulty Check
   if math.abs(ball_xvel) >= ball_max then
      ball_difficulty = 0
   end
   -- Player 1
   if (ball_y + 40) >= p1_y and ball_y <= (p1_y + 200) then
      if ball_x <= 41 and ball_x >= 35 then
	 ball_xvel = (ball_xvel - ball_difficulty) * -1
	 love.audio.play(paddle_beep)
      end
   end
   
   -- Player 2
   if (ball_y + 40) >= p2_y and ball_y <= (p2_y +200) then
      if ball_x >= 719 and ball_x <= 725 then
	 ball_xvel = (ball_xvel + ball_difficulty) * -1
	 love.audio.play(paddle_beep)
      end
   end

   -- Chug Chug
   ball_x = ball_x + (ball_xvel * 200 * dt)
   ball_y = ball_y + (ball_yvel * 200 * dt)
end

function Oscillator(freq)
    local phase = 0
    return function()
        phase = phase + 2*math.pi/beep_rate            
        if phase >= 2*math.pi then
            phase = phase - 2*math.pi
        end 
        return math.sin(freq*phase)
    end
end
