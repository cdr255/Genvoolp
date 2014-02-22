function love.load()
   -- Player 1
   p1_x = 0
   p1_y = 100
   p1_score = 0
   p1_width = 40
   p1_height = 200

   -- Player 2
   p2_x = 760
   p2_y = 100
   p2_score = 0
   p2_width = 40
   p2_height = 200

   -- Ball
   ball_x = 380
   ball_y = 280
   ball_xvel = 0
   ball_yvel = 0
   ball_width = 40
   ball_height = ball_width

end

function love.draw()
   love.graphics.print( p1_score, 150, 0 )
   love.graphics.print( p2_score, 650, 0 )
   love.graphics.rectangle("line", p1_x, p1_y, p1_width, p1_height)
   love.graphics.rectangle("line", p2_x, p2_y, p2_width, p2_height)
   love.graphics.rectangle("fill", ball_x, ball_y, ball_width, ball_height)
   
end

function love.update(dt)
   -- Player Movement
   if love.keyboard.isDown("w") then
      if p1_y > -10 then
	 p1_y = p1_y - (200 * dt) 
      end
   end 

   if love.keyboard.isDown("s") then
      if p1_y < 410 then
	 p1_y = p1_y + (200 * dt) 
      end
   end 

   if love.keyboard.isDown("up") then
      if p2_y > -10 then
	 p2_y = p2_y - (200 * dt) 
      end
   end 

   if love.keyboard.isDown("down") then
      if p2_y < 410 then
	 p2_y = p2_y + (200 * dt) 
      end
   end 

   ball_move(dt)

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
   end
   
   if ball_x > 760 then
      p1_score = p1_score + 1
      ball_xvel = 0
      ball_yvel = 0
      ball_x = 380
      ball_y = 280
   end
   -- Bouncing
   if ball_y < 0 or ball_y > 560 then
      ball_yvel = ball_yvel * -1
   end

   -- Player Collisions
   -- Player 1
   if ball_y >= p1_y and ball_y <= (p1_y +200) then
      if ball_x <= 40 then
	 ball_xvel = ball_xvel * -1
      end
   end

   -- Player 2
   if ball_y >= p2_y and ball_y <= (p2_y +200) then
      if ball_x >= 720 then
	 ball_xvel = ball_xvel * -1
      end
   end

   -- Chug Chug
   ball_x = ball_x + (ball_xvel * 200 * dt)
   ball_y = ball_y + (ball_yvel * 200 * dt)
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
