local gameState

local screen = {}
local images = {}
local sound = {}
local player = {}
local enemies = {}
local shots = {}
local font = {}
local wave = {}
local timer = {}
local timerMin = {}
local timerMax = {}
local menu = {}
local options = {}
local gameWin = {}
local gameOver = {}

local function loadImages()
  images.menuBackground = love.graphics.newImage("Assets/Images/MenuBackground.jpg")
  images.menuAsteroids  = love.graphics.newImage("Assets/Images/MenuAsteroids.png")
  images.background     = love.graphics.newImage("Assets/Images/Background.jpg")
  images.player         = love.graphics.newImage("Assets/Images/Player.png")
  images.playerEngine   = love.graphics.newImage("Assets/Images/PlayerEngine.png")
  images.enemy          = {big = love.graphics.newImage("Assets/Images/EnemyBig.png"), medium = love.graphics.newImage("Assets/Images/EnemyMedium.png"), little = love.graphics.newImage("Assets/Images/EnemyLittle.png")}
  images.shot           = love.graphics.newImage("Assets/Images/Shot.png")
end

local function loadSound()
  sound.menuSoundtrack = love.audio.newSource("Sound/MenuSoundtrack.mp3", "stream")
  sound.menuSoundtrack:setVolume(1)

  sound.soundtrack = love.audio.newSource("Sound/Soundtrack.mp3", "stream")
  sound.soundtrack:setVolume(1)

  sound.movePlayer = love.audio.newSource("Sound/MovePlayer.mp3", "static")
  sound.movePlayer:setVolume(0.4)

  sound.colPlayer = love.audio.newSource("Sound/ColPlayer.mp3", "static")
  sound.colPlayer:setVolume(0.5)

  sound.shot = love.audio.newSource("Sound/Shot.mp3", "static")
  sound.shot:setVolume(0.5)

  sound.explosion = love.audio.newSource("Sound/Explosion.mp3", "static")
  sound.explosion:setVolume(0.3)

  sound.gameWin = love.audio.newSource("Sound/GameWin.mp3", "static")
  sound.gameWin:setVolume(1)

  sound.gameOver = love.audio.newSource("Sound/GameOver.mp3", "static")
  sound.gameOver:setVolume(1)
end

local function loadFont()
  font.small  = love.graphics.newFont(25)
  font.medium = love.graphics.newFont(50)
  font.big    = love.graphics.newFont(80)
  font.player = love.graphics.newFont(30)
end

local function loadScreen()
  screen.w = love.graphics.getWidth()
  screen.h = love.graphics.getHeight()
end

local function loadMenuAsteroids()
  menu.asteroidsImg = images.menuAsteroids
  menu.asteroidsW   = menu.asteroidsImg:getWidth()
  menu.asteroidsH   = menu.asteroidsImg:getHeight()
end

local function loadMenuGame()
  menu.nb    = 1
  menu.gameW = 200
  menu.gameH = 50
  menu.gameX = (screen.w - menu.gameW)/2
  menu.gameY = (screen.h - menu.gameH*2)/2
end

local function loadMenuQuit()
  menu.quitW = 200
  menu.quitH = 50
  menu.quitX = (screen.w - menu.quitW)/2
  menu.quitY = screen.h/2 + 100
end

local function loadMenu()
  gameState = "menu"
  loadImages()
  loadSound()
  loadFont()
  loadScreen()
  loadMenuAsteroids()
  loadMenuGame()
  loadMenuQuit()
  sound.menuSoundtrack:play()
end

local function loadPlayer()
  player.img             = images.player
  player.r               = player.img:getHeight()/2
  player.w               = player.img:getWidth()
  player.x               = screen.w/2
  player.y               = screen.h/2
  player.angle           = math.rad(-90)
  player.angularVelocity = math.rad(270)
  player.actualSpeed     = 0
  player.speed           = {x = 0, y = 0, max = 500}
  player.acceleration    = 300
  player.hp              = 3
  player.score           = 0
  player.alive           = true
  player.state           = false
end

local function loadWave()
  wave.state = false
  wave.enemy = 2
end

local function loadTimer()
  timer.playerAlive    = 0
  timerMax.playerAlive = 2.5
  timer.playerState    = 0
  timerMax.playerState = 0.2

  timer.wave    = 0
  timerMax.wave = 3

  timer.shotRate      = 0
  timerMax.shotRate   = 0.3
  timer.shotLength    = 0
  timerMax.shotLength = 1
end

local function loadGame()
  loadPlayer()
  loadWave()
  loadTimer()
  enemies = {}
  shots = {}
  sound.soundtrack:play()
end

local function loadOptionsGame()
  options.nb    = 1
  options.gameW = 200
  options.gameH = 50
  options.gameX = (screen.w - options.gameW)/2
  options.gameY = (screen.h - options.gameH*2)/2
end

local function loadOptionsQuitGame()
  options.quitGameW = 200
  options.quitGameH = 50
  options.quitGameX = (screen.w - options.quitGameW)/2 
  options.quitGameY = screen.h/2 + 100
end

local function loadOptionsQuit()
  options.quitW = 200
  options.quitH = 50
  options.quitX = (screen.w - options.quitW)/2
  options.quitY = screen.h/2 + 225
end

local function loadOptions()
  loadOptionsGame()
  loadOptionsQuit()
  loadOptionsQuitGame()
end

local function loadGameWinQuit()
  gameWin.nb    = 1
  gameWin.quitW = 200
  gameWin.quitH = 50
  gameWin.quitX = (screen.w - gameWin.quitW)/2
  gameWin.quitY = screen.h/2 + 225
end

local function loadGameWinNewGame()
  gameWin.newGameW = 200
  gameWin.newGameH = 50
  gameWin.newGameX = (screen.w - gameWin.quitW)/2 
  gameWin.newGameY = screen.h/2 + 100
end

local function loadGameWin()
  loadGameWinQuit()
  loadGameWinNewGame()
end

local function loadGameOverQuit()
  gameOver.nb    = 1
  gameOver.quitW = 200
  gameOver.quitH = 50
  gameOver.quitX = (screen.w - gameOver.quitW)/2
  gameOver.quitY = screen.h/2 + 225
end

local function loadGameOverNewGame()
  gameOver.newGameW = 200
  gameOver.newGameH = 50
  gameOver.newGameX = (screen.w - gameOver.quitW)/2 
  gameOver.newGameY = screen.h/2 + 100
end

local function loadGameOver()
  loadGameOverQuit()
  loadGameOverNewGame()
end

function love.load()
  loadMenu()
end

local function loadEnemy(type, x, y)
  local enemy = {}
  enemy.type  = type

  if (enemy.type == "big") then
    enemy.img             = images.enemy.big
    enemy.angularVelocity = math.rad(love.math.random(15, 35))
    enemy.speed           = {x = love.math.random(30, 45), y = love.math.random(30, 45)}
    enemy.hp              = 3

  elseif (enemy.type == "medium") then
    enemy.img             = images.enemy.medium
    enemy.angularVelocity = math.rad(love.math.random(50, 120))
    enemy.speed           = {x = love.math.random(60, 80), y = love.math.random(60, 80)}
    enemy.hp              = 2
  elseif (enemy.type == "little") then
    enemy.img             = images.enemy.little
    enemy.angularVelocity = math.rad(love.math.random(140, 220))
    enemy.speed           = {x = love.math.random(100, 120), y = love.math.random(100, 120)}
    enemy.hp              = 1
  end

  enemy.x         = x or love.math.random(screen.w)
  enemy.y         = y or love.math.random(screen.h)
  enemy.rotation  = love.math.random(2)
  enemy.angle     = math.rad(love.math.random(360))
  enemy.r         = enemy.img:getHeight()/2
  enemy.w         = enemy.img:getWidth()
  enemy.direction = {x = love.math.random(2), y = love.math.random(2)}

  table.insert(enemies, enemy)
end

local function startWave(dt)
  if (#enemies == 0) then
    if (not wave.state) then
      timer.wave = timer.wave + dt
      if (timer.wave > timerMax.wave) then
        for i = 1, wave.enemy do
          loadEnemy("big")
        end
        wave.state = true
        timer.wave = 0
        wave.enemy = wave.enemy + 1
      end
    end
    if (#enemies == 0) then
      wave.state = false
    end
  end
end

local function wrapAround(obj)
  if (obj.x < 0) then
    obj.x = obj.x + screen.w
  end
  if (obj.x > screen.w) then
    obj.x = obj.x - screen.w
  end
  if (obj.y < 0) then
    obj.y = obj.y + screen.h
  end
  if (obj.y > screen.h) then
    obj.y = obj.y - screen.h
  end
end

local function movePlayer(dt)
  -- Rotate the player
  if (love.keyboard.isDown('q')) then
    player.angle = player.angle - player.angularVelocity * dt
  end
  if (love.keyboard.isDown('d')) then
    player.angle = player.angle + player.angularVelocity * dt
  end

  -- Set the player speed
  if (love.keyboard.isDown('z')) then
    sound.movePlayer:play()
    player.img = images.playerEngine
    player.actualSpeed = player.actualSpeed + player.acceleration * dt
    player.speed.x = player.speed.x + player.acceleration * math.cos(player.angle) * dt
    player.speed.y = player.speed.y + player.acceleration * math.sin(player.angle) * dt
    if (player.actualSpeed > player.speed.max) then
      player.speed.x = player.speed.x / player.actualSpeed * player.speed.max
      player.speed.y = player.speed.y / player.actualSpeed * player.speed.max
      player.actualSpeed = player.speed.max
    end
  else
    sound.movePlayer:stop()
    player.img = images.player
  end

  -- Move the player
  if (player.actualSpeed > 0) then
    player.x = player.x + player.speed.x * dt
    player.y = player.y + player.speed.y * dt
    wrapAround(player)
  end
end

local function moveEnemies(dt)
  for enemyId, enemy in ipairs(enemies) do
    if (enemy.direction.x == 1) then
      enemy.x = enemy.x - enemy.speed.x * dt
    else
      enemy.x = enemy.x + enemy.speed.x * dt
    end
    if (enemy.direction.y == 1) then
      enemy.y = enemy.y - enemy.speed.y * dt
    else
      enemy.y = enemy.y + enemy.speed.y * dt
    end
    if (enemy.rotation == 1) then
      enemy.angle = enemy.angle - enemy.angularVelocity * dt
    else
      enemy.angle = enemy.angle + enemy.angularVelocity * dt
    end
    wrapAround(enemy)
  end
end

local function loadShot()
  local shot = {}

  shot.img             = images.shot
  shot.r               = shot.img:getHeight()/2
  shot.w               = shot.img:getWidth()
  shot.x               = player.x
  shot.y               = player.y
  shot.angle           = player.angle
  shot.speed           = 600
  shot.timerLength     = timer.shotLength
  shot.timerLengthMax  = timerMax.shotLength

  table.insert(shots, shot)
end

local function startShot(dt)
  timer.shotRate = timer.shotRate + dt
  if (player.alive) then
    if (love.keyboard.isDown ("space")) then
      if (timer.shotRate > timerMax.shotRate) then
        loadShot()
        sound.shot:play()
        timer.shotRate = 0
      end
    end
  end
end

local function moveShots(dt)
  for shotId, shot in ipairs(shots) do
    shot.timerLength = shot.timerLength + dt
    if (shot.timerLength < shot.timerLengthMax) then
      shot.x = shot.x + shot.speed * math.cos(shot.angle) * dt
      shot.y = shot.y + shot.speed * math.sin(shot.angle) * dt
      wrapAround(shot)
    else
      table.remove(shots, shotId)
    end
  end
end

local function isColliding(a, b)
  local d = (a.x - b.x)^2 + (a.y - b.y)^2
  if (d < (a.r + b.r)^2) then
    return true
  else
    return false
  end
end

local function checkColPlayerEnemies()
  for enemyId, enemy in ipairs(enemies) do
    if (isColliding(player, enemy)) then
      if (player.alive) then
        player.hp = player.hp - 1
        player.alive = false
        sound.colPlayer:play()
      end
    end
  end
end

local function checkColShotsEnemies()
  for shotId, shot in ipairs(shots) do
    for enemyId, enemy in ipairs(enemies) do
      if (isColliding(shot, enemy)) then
        table.remove(shots, shotId)
        enemy.hp = enemy.hp - 1
        if (enemy.hp == 0) then
          sound.explosionClone = sound.explosion:clone()
          sound.explosionClone:play()
          if (enemy.type == "big") then
            player.score = player.score + 15
            for i = 1, 2 do
              loadEnemy("medium", enemy.x, enemy.y)
            end
          elseif (enemy.type == "medium") then
            player.score = player.score + 10
            for i = 1, 2 do
              loadEnemy("little", enemy.x, enemy.y)
            end
          else 
            player.score = player.score + 5
          end
          table.remove(enemies, enemyId)
        end
      end
    end
  end
end

local function respawnPlayer(dt)
  if (player.hp > 0) then
    if (not player.alive) then
      timer.playerAlive = timer.playerAlive + dt
      if (not player.state) then
        timer.playerState = timer.playerState + dt
        if (timer.playerState > timerMax.playerState) then
          player.state = true
          timer.playerState = 0
        end
      elseif (player.state) then
        timer.playerState = timer.playerState + dt
        if (timer.playerState > timerMax.playerState) then
          player.state = false
          timer.playerState = 0
        end
      end
      if (timer.playerAlive > timerMax.playerAlive) then
        player.alive = true
        timer.playerAlive = 0
      end
    end
  end
end

local function winLosePlayer()
  if (wave.enemy > 4) then
    if (#enemies == 0) then
      gameState = "game win"
      loadGameWin()
      sound.soundtrack:stop()
      sound.gameWin:play()
    end
  end
  if (player.hp == 0) then
    gameState = "game over"
    loadGameOver()
    sound.soundtrack:stop()
    sound.gameOver:play()
  end
end

function love.update(dt)
  if (gameState == "game") then
    startWave(dt)
    movePlayer(dt)
    moveEnemies(dt)
    startShot(dt)
    moveShots(dt)
    checkColPlayerEnemies()
    checkColShotsEnemies()
    respawnPlayer(dt)
    winLosePlayer()
  end
end

local function drawMenuBackground()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(images.menuBackground)
end

local function drawMenuAsteroids()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(menu.asteroidsImg, (screen.w - menu.asteroidsW)/2, (menu.gameY - menu.asteroidsH)/2)
end

local function drawMenuGame()
  love.graphics.setFont(font.small)
  if (menu.nb == 1) then
    love.graphics.setColor(1, 1, 1)
  else
    love.graphics.setColor(0, 0, 0)
  end
  love.graphics.rectangle("line", menu.gameX, menu.gameY, menu.gameW, menu.gameH)
  love.graphics.printf("Start Game", menu.gameX, menu.gameY + 10, menu.gameW, "center")
end

local function drawMenuQuit()
  love.graphics.setFont(font.small)
  if (menu.nb == 2) then
    love.graphics.setColor(1, 1, 1)
  else
    love.graphics.setColor(0, 0, 0)
  end
  love.graphics.rectangle("line", menu.quitX, menu.quitY, menu.quitW, menu.quitH)
  love.graphics.printf("Quit", menu.quitX, menu.quitY + 10, menu.quitW, "center")
end

local function drawMenu()
  drawMenuBackground()
  drawMenuAsteroids()
  drawMenuGame()
  drawMenuQuit()
end

local function drawBackground()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(images.background)
end

local function drawWithWrapAround(obj)
  love.graphics.draw(obj.img, obj.x - screen.w, obj.y - screen.h, obj.angle + math.rad(90), 1, 1, obj.w/2, obj.r)
  love.graphics.draw(obj.img, obj.x, obj.y - screen.h, obj.angle + math.rad(90), 1, 1, obj.w/2, obj.r)
  love.graphics.draw(obj.img, obj.x + screen.w, obj.y - screen.h, obj.angle + math.rad(90), 1, 1, obj.w/2, obj.r)
  love.graphics.draw(obj.img, obj.x - screen.w, obj.y, obj.angle + math.rad(90), 1, 1, obj.w/2, obj.r)
  love.graphics.draw(obj.img, obj.x, obj.y, obj.angle + math.rad(90), 1, 1, obj.w/2, obj.r)
  love.graphics.draw(obj.img, obj.x + screen.w, obj.y, obj.angle + math.rad(90), 1, 1, obj.w/2, obj.r)
  love.graphics.draw(obj.img, obj.x - screen.w, obj.y + screen.h, obj.angle + math.rad(90), 1, 1, obj.w/2, obj.r)
  love.graphics.draw(obj.img, obj.x, obj.y + screen.h, obj.angle + math.rad(90), 1, 1, obj.w/2, obj.r)
  love.graphics.draw(obj.img, obj.x + screen.w, obj.y + screen.h, obj.angle + math.rad(90), 1, 1, obj.w/2, obj.r)
end

local function drawShots()
  for shotId, shot in ipairs(shots) do
    drawWithWrapAround(shot)
  end
end

local function drawEnemies()
  if (wave.state) then
    for enemyId, enemy in ipairs(enemies) do
      drawWithWrapAround(enemy)
    end
  end
end

local function drawPlayer()
  if (player.alive) or (player.state) then
    drawWithWrapAround(player)
  end
end

local function drawFont()
  love.graphics.setFont(font.player)
  love.graphics.print("HP = "..player.hp, 20, 20)

  love.graphics.setFont(font.player)
  love.graphics.print("SCORE = "..player.score, 20, screen.h - 50)
end

local function drawGame()
  drawBackground()
  drawShots()
  drawEnemies()
  drawPlayer()
  drawFont()
end

local function drawOptionsShade()
  love.graphics.setColor(0, 0, 0, 0.6)
  love.graphics.rectangle("fill", 0, 0, screen.w, screen.h)
end

local function drawOptionsOptions()
  love.graphics.setFont(font.big)
  love.graphics.setColor(1, 1, 1)
  love.graphics.printf("OPTIONS", 0, 120, screen.w, "center")
end

local function drawOptionsGame()
  love.graphics.setFont(font.small)
  if (options.nb == 1) then
    love.graphics.setColor(1, 1, 1)
  else
    love.graphics.setColor(0, 0, 0)
  end
  love.graphics.rectangle("line", options.gameX, options.gameY, options.gameW, options.gameH)
  love.graphics.printf("Continue", options.gameX, options.gameY + 10, options.gameW, "center")
end

local function drawOptionsQuitGame()
  love.graphics.setFont(font.small)
  if (options.nb == 2) then
    love.graphics.setColor(1, 1, 1)
  else
    love.graphics.setColor(0, 0, 0)
  end
  love.graphics.rectangle("line", options.quitGameX, options.quitGameY, options.quitGameW, options.quitGameH)
  love.graphics.printf("Go to Menu", options.quitGameX, options.quitGameY + 10, options.quitGameW, "center")
end

local function drawOptionsQuit()
  love.graphics.setFont(font.small)
  if (options.nb == 3) then
    love.graphics.setColor(1, 1, 1)
  else
    love.graphics.setColor(0, 0, 0)
  end
  love.graphics.rectangle("line", options.quitX, options.quitY, options.quitW, options.quitH)
  love.graphics.printf("Quit", options.quitX, options.quitY + 10, options.quitW, "center")
end

local function drawOptions()
  drawGame()
  drawOptionsShade()
  drawOptionsOptions()
  drawOptionsGame()
  drawOptionsQuitGame()
  drawOptionsQuit()
end

local function drawGameWinYouWin()
  love.graphics.setFont(font.big)
  love.graphics.setColor(0, 1, 0)
  love.graphics.printf("YOU WIN", 0, (gameWin.newGameY - 80)/4, screen.w, "center")
end

local function drawGameWinPlayer()
--  Draw "Score ="
  love.graphics.setFont(font.medium)
  love.graphics.setColor(1, 1, 1)
  love.graphics.printf("Your SCORE = "..player.score, 200, (gameWin.newGameY + 60)/2, screen.w)

--  Draw "HP ="
  love.graphics.setColor(1, 1, 1)
  love.graphics.printf("Your HP = ", 305, (gameWin.newGameY + 180)/2, screen.w)

--  Draw playerHP
  love.graphics.setColor(1, 0, 0)
  love.graphics.printf(player.hp, 565, (gameWin.newGameY + 180)/2, screen.w)
end

local function drawGameWinNewGame()
  love.graphics.setFont(font.small)
  if (gameWin.nb == 1) then
    love.graphics.setColor(1, 1, 1)
  else
    love.graphics.setColor(0, 0, 0)
  end
  love.graphics.rectangle("line", gameWin.newGameX, gameWin.newGameY, gameWin.newGameW, gameWin.newGameH)
  love.graphics.printf("New game", gameWin.newGameX, gameWin.newGameY + 10, gameWin.newGameW, "center")
end

local function drawGameWinQuit()
  love.graphics.setFont(font.small)
  if (gameWin.nb == 2) then
    love.graphics.setColor(1, 1, 1)
  else
    love.graphics.setColor(0, 0, 0)
  end
  love.graphics.rectangle("line", gameWin.quitX, gameWin.quitY, gameWin.quitW, gameWin.quitH)
  love.graphics.printf("Quit", gameWin.quitX, gameWin.quitY + 10, gameWin.quitW, "center")
end

local function drawGameWin()
  drawMenuBackground()
  drawGameWinYouWin()
  drawGameWinPlayer()
  drawGameWinNewGame()
  drawGameWinQuit()
end

local function drawGameOverGameOver()
  love.graphics.setFont(font.big)
  love.graphics.setColor(1, 0, 0)
  love.graphics.printf("GAME OVER", 0, (gameOver.newGameY - 80)/4, screen.w, "center")
end

local function drawGameOverPlayer()
--  Draw "Score ="
  love.graphics.setFont(font.medium)
  love.graphics.setColor(1, 1, 1)
  love.graphics.printf("Your SCORE = "..player.score, 200, (gameOver.newGameY + 60)/2, screen.w)

--  Draw "HP ="
  love.graphics.setColor(1, 1, 1)
  love.graphics.printf("Your HP = ", 305, (gameOver.newGameY + 180)/2, screen.w)

--  Draw playerHP
  love.graphics.setColor(1, 0, 0)
  love.graphics.printf(player.hp, 565, (gameOver.newGameY + 180)/2, screen.w)
end

local function drawGameOverNewGame()
  love.graphics.setFont(font.small)
  if (gameOver.nb == 1) then
    love.graphics.setColor(1, 1, 1)
  else
    love.graphics.setColor(0, 0, 0)
  end
  love.graphics.rectangle("line", gameOver.newGameX, gameOver.newGameY, gameOver.newGameW, gameOver.newGameH)
  love.graphics.printf("Try again", gameOver.newGameX, gameOver.newGameY + 10, gameOver.newGameW, "center")
end

local function drawGameOverQuit()
  love.graphics.setFont(font.small)
  if (gameOver.nb == 2) then
    love.graphics.setColor(1, 1, 1)
  else
    love.graphics.setColor(0, 0, 0)
  end
  love.graphics.rectangle("line", gameOver.quitX, gameOver.quitY, gameOver.quitW, gameOver.quitH)
  love.graphics.printf("Quit", gameOver.quitX, gameOver.quitY + 10, gameOver.quitW, "center")
end

local function drawGameOver()
  drawMenuBackground()
  drawGameOverGameOver()
  drawGameOverPlayer()
  drawGameOverNewGame()
  drawGameOverQuit()
end

function love.draw()
  if (gameState == "menu") then
    drawMenu()
  elseif (gameState == "game") then
    drawGame()
  elseif (gameState == "options") then
    drawOptions()
  elseif (gameState == "game win") then
    drawGameWin()
  elseif (gameState == "game over") then
    drawGameOver()
  end
end

local function keypressedMenu(key)
  if (key == "z") then
    menu.nb = menu.nb - 1
    if (menu.nb < 1) then
      menu.nb = 2
    end
  elseif (key == "s") then
    menu.nb = menu.nb + 1
    if (menu.nb > 2) then
      menu.nb = 1
    end
  end
  if (key == "return") and (menu.nb == 1) then
    gameState = "game"
    loadGame()
    sound.menuSoundtrack:stop()
  elseif (key == "return") and (menu.nb == 2) or (key == "escape") then
    love.event.quit()
  end
end

local function keypressedOptions(key)
  if (key == "z") then
    options.nb = options.nb - 1
    if (options.nb < 1) then
      options.nb = 3
    end
  elseif (key == "s") then
    options.nb = options.nb + 1
    if (options.nb > 3) then
      options.nb = 1
    end
  end
  if (key == "return") and (options.nb == 1) or (key == "escape") then
    gameState = "game"
    sound.soundtrack:play()
  elseif (key == "return") and (options.nb == 2) then
    gameState = "menu"
    sound.soundtrack:stop()
    sound.menuSoundtrack:play()
  elseif (key == "return") and (options.nb == 3) then
    love.event.quit()
  end
end

local function keypressedGameWin(key)
  if (key == "z") then
    gameWin.nb = gameWin.nb - 1
    if (gameWin.nb < 1) then
      gameWin.nb = 2
    end
  elseif (key == "s") then
    gameWin.nb = gameWin.nb + 1
    if (gameWin.nb > 2) then
      gameWin.nb = 1
    end
  end
  if (key == "return") and (gameWin.nb == 1) then
    gameState = "game"
    loadGame()
    sound.gameWin:stop()
  elseif (key == "return") and (gameWin.nb == 2) or (key == "escape") then
    love.event.quit()
  end
end

local function keypressedGameOver(key)
  if (key == "z") then
    gameOver.nb = gameOver.nb - 1
    if (gameOver.nb < 1) then
      gameOver.nb = 2
    end
  elseif (key == "s") then
    gameOver.nb = gameOver.nb + 1
    if (gameOver.nb > 2) then
      gameOver.nb = 1
    end
  end
  if (key == "return") and (gameOver.nb == 1) then
    gameState = "game"
    loadGame()
    sound.gameOver:stop()
  elseif (key == "return") and (gameOver.nb == 2) or (key == "escape") then
    love.event.quit()
  end
end

function love.keypressed(key)
  if (gameState == "menu") then
    keypressedMenu(key)
  elseif (gameState == "options") then
    keypressedOptions(key)
  elseif (gameState == "game") then
    if (key == "escape") then
      gameState = "options"
      loadOptions()
      sound.soundtrack:pause()
    end
  elseif (gameState == "game win") then
    keypressedGameWin(key)
  elseif (gameState == "game over") then
    keypressedGameOver(key)
  end
end