currentLevel = 1
levelWidth = 2000  -- wider than screen width
levelHeight = 1200 -- taller than screen height
local backgroundMusic
local background

camera = {
    x = 0,
    y = 0,
    width = love.graphics.getWidth(),
    height = love.graphics.getHeight()
}

local levels = {
    {
        lightSource = {x = 600, y = 750, width = 20, height = 20},
        realPlatforms = {
            {x = 150, y = 1050, width = 200, height = 20},
            {x = 250, y = 950, width = 200, height = 20},
            {x = 350, y = 950, width = 200, height = 20},
            {x = 450, y = 850, width = 200, height = 20}
        },
        shadowPlatforms = {
            {x = 180, y = 1000, width = 150, height = 10},
            {x = 430, y = 900, width = 100, height = 10},
            {x = 680, y = 800, width = 120, height = 10}
        },
        enemies = {
            {x = 800, y = 668, width = 32, height = 32, speed = 60, direction = -1, damage = 25, health = 2}
        }
    },
    {
        lightSource = {x = 550, y = 80, width = 20, height = 20},
        realPlatforms = {
            {x = 100, y = 300, width = 80, height = 20},
            {x = 450, y = 200, width = 100, height = 20}
        },
        shadowPlatforms = {
            {x = 200, y = 300, width = 150, height = 10},
            {x = 500, y = 120, width = 150, height = 10}
        },
        enemies = {
            {x = 270, y = 230, width = 32, height = 32, speed = 50, direction = 1, damage = 25, health = 3},
            {x = 610, y = 130, width = 32, height = 32, speed = 60, direction = -1, damage = 25, health = 3}
        }
    },
    {
        lightSource = {x = 1800, y = 600, width = 20, height = 20},
        realPlatforms = {
            {x = 100, y = 1100, width = 200, height = 20},
            {x = 400, y = 1000, width = 200, height = 20},
            {x = 700, y = 900, width = 200, height = 20},
            {x = 1000, y = 800, width = 200, height = 20},
            {x = 1300, y = 700, width = 200, height = 20}
        },
        shadowPlatforms = {
            {x = 300, y = 1050, width = 150, height = 10},
            {x = 650, y = 950, width = 100, height = 10},
            {x = 800, y = 850, width = 100, height = 10},
            {x = 1100, y = 750, width = 120, height = 10},
            {x = 1500, y = 700, width = 120, height = 10}
        },
        enemies = {
            {x = 500, y = 968, width = 32, height = 32, speed = 70, direction = 1, damage = 25, health = 3},
            {x = 850, y = 868, width = 32, height = 32, speed = 60, direction = -1, damage = 25, health = 4}
        }
    },
    {
        lightSource = {x = 1600, y = 500, width = 20, height = 20},
        realPlatforms = {
            {x = 300, y = 1100, width = 300, height = 20},
            {x = 700, y = 950, width = 300, height = 20},
            {x = 1100, y = 800, width = 300, height = 20},
            {x = 1500, y = 700, width = 300, height = 20}
        },
        shadowPlatforms = {
            {x = 400, y = 1050, width = 200, height = 10},
            {x = 800, y = 900, width = 200, height = 10},
            {x = 1350, y = 550, width = 200, height = 10}
        },
        enemies = {
            {x = 600, y = 918, width = 32, height = 32, speed = 80, direction = 1, damage = 30, health = 4},
            {x = 1200, y = 768, width = 32, height = 32, speed = 90, direction = -1, damage = 30, health = 5}
        }
    },
    {
        lightSource = {x = 1950, y = 400, width = 20, height = 20},
        realPlatforms = {
            {x = 100, y = 1150, width = 300, height = 20},
            {x = 600, y = 1050, width = 300, height = 20},
            {x = 1100, y = 950, width = 300, height = 20},
            {x = 1600, y = 850, width = 300, height = 20}
        },
        shadowPlatforms = {
            {x = 400, y = 1100, width = 200, height = 10},
            {x = 900, y = 1000, width = 200, height = 10},
            {x = 1400, y = 800, width = 200, height = 10}
        },
        enemies = {
            {x = 700, y = 1018, width = 32, height = 32, speed = 90, direction = -1, damage = 35, health = 5},
            {x = 1300, y = 918, width = 32, height = 32, speed = 100, direction = 1, damage = 35, health = 5},
            {x = 1700, y = 818, width = 32, height = 32, speed = 110, direction = -1, damage = 40, health = 6}
        }
    }
}

function loadLevel(levelNumber)
    local levelData = levels[levelNumber]
    
    -- Load level components from the levelData table
    gameState = "playing"

    player = {
        x = 100,
        y = 300,
        width = 32,
        height = 32,
        speed = 200,
        jumpPower = -400,
        velocityY = 0,
        gravity = 800,
        health = 100,
        currentFrame = 1,
        animationTimer = 0,
        frameDuration = 0.1,  -- seconds per frame
        frameStart = 1,
        frameEnd = 2, -- e.g., running frames
        state = "idle",
        invincible = false,
        invincibleTimer = 0,
        isOnGround = false 
    }

    projectiles = {}
    enemies = levelData.enemies
    groundY = levelHeight - 100  -- Keep ground lower for larger level
    realPlatforms = levelData.realPlatforms
    shadowPlatforms = levelData.shadowPlatforms
    lightSource = levelData.lightSource

    worldState = "real"
end


function love.load()
    gameState = "start"

    backgroundMusic = love.audio.newSource("assets/freepik-italoclassic.mp3", "stream")
    backgroundMusic:setLooping(true)
    backgroundMusic:setVolume(0.5) -- Adjust volume (0.0 to 1.0)
    backgroundMusic:play()
    background = love.graphics.newImage("assets/Background.jpg")

    local particleImage = love.graphics.newImage("20.png")
    particles = love.graphics.newParticleSystem(particleImage, 100)
    particles:setParticleLifetime(0.5, 1)
    particles:setEmissionRate(0)
    particles:setSizes(0.5, 1)
    particles:setSpeed(100, 200)
    particles:setLinearAcceleration(-20, -20, 20, 20)
    particles:setColors(1, 1, 0, 1, 1, 0.5, 0, 0)
    particles:setSpread(math.pi * 2)
    playerSpriteSheet = love.graphics.newImage("player-spritemap-v9.png")
    playerQuads = {}
    
    local frameWidth = 32
local frameHeight = 32
local sheetWidth = playerSpriteSheet:getWidth()
local sheetHeight = playerSpriteSheet:getHeight()
local columns = sheetWidth / frameWidth
local rows = sheetHeight / frameHeight

for y = 0, rows - 1 do
    for x = 0, columns - 1 do
        table.insert(playerQuads, love.graphics.newQuad(
            x * frameWidth, y * frameHeight,
            frameWidth, frameHeight,
            sheetWidth, sheetHeight
        ))
    end
end
    currentLevel = 1
    --loadLevel(currentLevel)
end

function love.update(dt)
    if gameState ~= "playing" then return end
    -- Left and Right Movement
    if love.keyboard.isDown("left") then
        player.x = player.x - player.speed * dt
    elseif love.keyboard.isDown("right") then
        player.x = player.x + player.speed * dt
    end

    -- Apply Gravity
    player.velocityY = player.velocityY + player.gravity * dt
    player.y = player.y + player.velocityY * dt
    player.isOnGround = false
    player.animationTimer = player.animationTimer + dt
    if player.animationTimer >= player.frameDuration then
        player.animationTimer = 0
        player.currentFrame = player.currentFrame + 1
        if player.currentFrame > player.frameEnd then
            player.currentFrame = player.frameStart
        end
    end
    -- Check for platform collisions (when falling or jumping)
    if worldState == "real" then
        -- Check for real world platform collision using AABB
        for _, platform in ipairs(realPlatforms) do
            if checkAABBCollision(player, platform) then
                -- If falling down, stop falling
                if player.velocityY > 0 then
                    player.y = platform.y - player.height
                    player.isOnGround = true

                    player.velocityY = 0  -- Stop falling
                -- If jumping upwards, stop upwards movement and adjust position
                elseif player.velocityY < 0 then
                    player.y = platform.y + platform.height
                    player.velocityY = 0  -- Stop jumping upwards
                end
            end
        end

        -- Check ground collision (only in the real world)
        if player.y + player.height >= groundY then
            player.y = groundY - player.height
            player.velocityY = 0
        end
        if checkAABBCollision(player, lightSource) then
            gameState = "complete"
        end
    elseif worldState == "shadow" then
        -- Check for shadow world platform collision using AABB
        for _, platform in ipairs(shadowPlatforms) do
            if checkAABBCollision(player, platform) then
                -- If falling down, stop falling
                if player.velocityY > 0 then
                    player.y = platform.y - player.height
                    player.velocityY = 0  -- Stop falling
                    player.isOnGround=true
                -- If jumping upwards, stop upwards movement and adjust position
                elseif player.velocityY < 0 then
                    player.y = platform.y + platform.height
                    player.velocityY = 0  -- Stop jumping upwards
                end
            end
        end

        -- Shadow World Ground Collision (similar to real world ground)
        if player.y + player.height >= groundY then
            player.y = groundY - player.height
            player.velocityY = 0
            player.isOnGround=true
        end
    end
    
    if checkAABBCollision(player, lightSource) then
        gameState = "complete"
        particles:setPosition(player.x + player.width / 2, player.y + player.height / 2)
        particles:emit(50)
    end
    -- Update invincibility timer
if player.invincible then
    player.invincibleTimer = player.invincibleTimer - dt
    if player.invincibleTimer <= 0 then
        player.invincible = false
    end
end

-- Check enemy collision
for _, enemy in ipairs(enemies) do
    if checkAABBCollision(player, enemy) and not player.invincible then
        player.health = player.health - enemy.damage
        player.invincible = true
        player.invincibleTimer = 1  -- 1 second of invincibility
        -- Optional: knock player back
        player.velocityY = -200
    end
end

-- Check if player is dead
if player.health <= 0 then
    gameState = "gameover"
    backgroundMusic:stop()
end
for _, enemy in ipairs(enemies) do
    enemy.x = enemy.x + enemy.speed * enemy.direction * dt

    -- Reverse direction if they reach edge of patrol
    if enemy.x < 0 or enemy.x + enemy.width > love.graphics.getWidth() then
        enemy.direction = -enemy.direction
    end
end
for i = #projectiles, 1, -1 do
    local proj = projectiles[i]
    proj.x = proj.x + proj.speed * dt

    -- Remove projectile if offscreen
    if proj.x > love.graphics.getWidth() then
        table.remove(projectiles, i)
    else
        -- Check collision with enemies
        for j = #enemies, 1, -1 do
            local enemy = enemies[j]
            if checkAABBCollision(proj, enemy) then
                enemy.health = enemy.health - 1
                table.remove(projectiles, i)
            if enemy.health <= 0 then
                table.remove(enemies, j)
                end
                break
                end
            end
        end
    end
    -- Always update the particles
    particles:update(dt)
    -- Camera follows player
    camera.x = math.floor(player.x + player.width / 2 - camera.width / 2)
    camera.y = math.floor(player.y + player.height / 2 - camera.height / 2)

    -- Clamp camera to level bounds
    camera.x = math.max(0, math.min(camera.x, levelWidth - camera.width))
    camera.y = math.max(0, math.min(camera.y, levelHeight - camera.height))

end

function checkAABBCollision(a, b)
    return a.x + a.width > b.x and
           a.x < b.x + b.width and
           a.y + a.height > b.y and
           a.y < b.y + b.height
end


function love.keypressed(key)
    if gameState == "start" and key == "return" then
        loadLevel(currentLevel)
    end
    if gameState == "over" and key == "r" then
        loadLevel(currentLevel)
    end
    -- Jumping (in both real and shadow worlds)

    if key == "space" then
        if player.isOnGround or player.y +player.height >= groundY then
        if worldState == "real" then
            -- Allow jumping only when on the ground or a platform in the real world
            
            player.velocityY = player.jumpPower
            
        elseif worldState == "shadow" then
            -- Jumping behavior for shadow world
            player.velocityY = player.jumpPower
        end
    end
    end
    if key == "f" then
        table.insert(projectiles, {
            x = player.x + player.width,
            y = player.y + player.height / 2 - 5,
            width = 10,
            height = 5,
            speed = 400
        })
    end
    
    -- Swap worlds when 'S' is pressed
    if key == "s" then
        if worldState == "real" then
            worldState = "shadow"
            
        else
            worldState = "real"
            -- Ensure player falls to the ground when switching back
            player.velocityY = 0
        end
    end
    if key == "r" and gameState == "complete" then
        resetGame()
    end
    if key == "n" and gameState == "complete" then
        currentLevel = currentLevel + 1
        if currentLevel > 4 then currentLevel = 1 end -- loop back or stop here if needed
        loadLevel(currentLevel)
    end

end

function love.draw()
    if gameState == "start" then
        love.graphics.setFont(love.graphics.newFont(32))
        love.graphics.printf("Shadow Swap", 0, 200, love.graphics.getWidth(), "center")
        love.graphics.setFont(love.graphics.newFont(16))
        love.graphics.printf("Press Enter to Start", 0, 300, love.graphics.getWidth(), "center")
        return
    end
    love.graphics.draw(background, 0, 0)

    love.graphics.push()
love.graphics.translate(-camera.x, -camera.y)



    -- Draw Ground (Real World)
    if worldState == "real" then
        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.rectangle("fill", 0, groundY, love.graphics.getWidth(), 20)

        -- Draw Real World Platforms
        love.graphics.setColor(0.3, 0.7, 0.3)  -- Green for real platforms
        for _, platform in ipairs(realPlatforms) do
            love.graphics.rectangle("fill", platform.x, platform.y, platform.width, platform.height)
        end
    end

    -- Draw Light Source
    love.graphics.setColor(1, 1, 0)
    love.graphics.rectangle("fill", lightSource.x, lightSource.y, lightSource.width, lightSource.height)

    -- Draw Shadow Platforms (Only in Shadow World)
    if worldState == "shadow" then
        love.graphics.setColor(0.2, 0.2, 0.2)  -- Darker color for shadow platforms
        for _, platform in ipairs(shadowPlatforms) do
            love.graphics.rectangle("fill", platform.x, platform.y, platform.width, platform.height)
        end
    end

    -- Draw Player
    --love.graphics.setColor(1, 1, 1)
    --love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)
    love.graphics.draw(
    playerSpriteSheet,
    playerQuads[player.currentFrame],
    player.x,
    player.y
)
    -- Draw Projectiles
    love.graphics.setColor(1, 1, 0)
    for _, proj in ipairs(projectiles) do
        love.graphics.rectangle("fill", proj.x, proj.y, proj.width, proj.height)
    end
        -- Draw Particles (always shown)
    love.graphics.draw(particles)
        
        -- Level Complete Screen
    if gameState == "complete" then
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(love.graphics.newFont(32))
        love.graphics.printf("Level Complete!", 0, love.graphics.getHeight()/2 - 40, love.graphics.getWidth(), "center")
    
        love.graphics.setFont(love.graphics.newFont(16))
        love.graphics.printf("Press R to Restart or N for next level", 0, love.graphics.getHeight()/2 + 20, love.graphics.getWidth(), "center")
    end
    love.graphics.setColor(1, 0, 0) -- red
    for _, enemy in ipairs(enemies) do
        love.graphics.rectangle("fill", enemy.x, enemy.y, enemy.width, enemy.height)
    end

    -- Draw health
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Health: " .. player.health, 10, 10)

    -- Game Over screen
    if gameState == "gameover" then
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 0, 0)
        love.graphics.setFont(love.graphics.newFont(32))
        love.graphics.printf("Game Over", 0, love.graphics.getHeight()/2 - 40, love.graphics.getWidth(), "center")
        love.graphics.setFont(love.graphics.newFont(16))
        love.graphics.printf("Press R to Restart", 0, love.graphics.getHeight()/2 + 20, love.graphics.getWidth(), "center")
    end

    
    
    love.graphics.pop()
end


function resetGame()
    loadLevel(currentLevel)
end


