--Загрузочная функция love2d

function love.load()
  
--  Концигурация окошка и цветов Love2D

  gr = love.graphics
  wn = love.window
  kb = love.keyboard
  gr.setBackgroundColor(255, 255, 255)
  gr.setColor(0, 0, 0)
  wn.setMode(320, 320)
  wn.setTitle("Test platformer")
  
--  Карта (матрица 10х10)

  map = {
    {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1},
    {1,0,0,0,0,0,0,0,0,1,1,0,0,0,1,0,0,1,0,0},
    {1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,1},
    {1,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
  }
  
--  Класс ГГ

  player = {
    x = 32,
    y = 32,
    cx = 0,
    jump = false,
    jumpSize = 0,
    coll = {
      left = false,
      right = false,
      top = false,
      bottom = false
    }
  }
  
--  Подгрузка графики

  block = gr.newImage("block.png")
  iplayer = gr.newImage("testplayer.png")
      
 
function player.vertical(unit)
    local x1 = math.floor((player.x + 1) / 32) + 1
    local x2 = math.floor((player.x + 31) / 32) + 1
    local y1 = math.floor((player.y + 32 + unit) / 32) + 1
    local y2 = math.floor((player.y - unit) / 32) + 1
    if map[y1][x1] == 0 and map[y1][x2] == 0 then
      player.coll.bottom = false
    else
      player.coll.bottom = true
      player.y = (y1 - 2) * 32
    end
    if map[y2][x1] == 0 and map[y2][x2] == 0 then
      player.coll.top = false
    else
      player.coll.top = true
      player.y = y2 * 32
    end
  end

--  Расчет горизонтальной коллизии
  
  function player.horizontal(unit)
    local y1 = math.floor((player.y + 1) / 32) + 1
    local y2 = math.floor((player.y + 31) / 32) + 1
    local x1 = math.floor((player.x - unit) / 32) + 1
    local x2 = math.floor((player.x + 32 + unit) / 32) + 1
    if map[y1][x1] == 0 and map[y2][x1] == 0 then
      player.coll.left = false
    else
      player.coll.left = true
      player.x = x1 * 32
    end
    if map[y1][x2] == 0 and map[y2][x2] == 0 then
      player.coll.right = false
    else
      player.coll.right = true
      player.x = (x2 - 2) * 32
    end
  end
  
end

--  Работа с клавиатурой

function love.keypressed(key)
  if key == " " and player.coll.bottom then
    player.jump = true
  end
end

function love.keyreleased(key)
  if key == " " then
    player.jump = false
  end
end

--  Функция расчета

function love.update(dt)
  
 

--  Еденица движения

  unit = dt * 500
  
--  Коллизия

  player.vertical(unit)
  player.horizontal(unit)
  
  if not player.coll.bottom and not player.jump then
    player.y = player.y + unit
  end
  
--  Прыжок
  
  if player.jump and player.jumpSize < 16 and not player.coll.top then
    player.jumpSize = player.jumpSize + 1
    player.y = player.y - unit
  else
    player.jumpSize = 0
    player.jump = false
  end
  
  if not player.coll.left and kb.isDown("a") then
    
    player.x = player.x - unit
  end
  
  if not player.coll.right and kb.isDown("d") then
    
    player.x = player.x + unit
  end
  -- делаем норм cx
 
  
    
  end
  
   
  
  


--Функция отрисовки

function love.draw()
  
--  Установка маски цвета
  
  gr.setColor(255, 255, 255)

--  Отрисовка карты
  
  for i = 1, #map do
    for k = 1, #map[i] do
      if map[i][k] == 1 then
        gr.draw(block, (k - 1) * 32 , (i - 1) * 32)
      end
    end
  end
  
--  Отрисовка ГГ
  
  gr.draw(iplayer, 144, player.y)
  gr.print(player.x, 0, 0)
  
end