io.stdout:setvbuf("no")
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
    {1,1,1,1,1,1,1,1,1,1},
    {1,0,1,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1},
    {1,1,1,1,1,1,1,1,1,1},
    {1,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1},
    {1,1,1,1,1,1,1,1,1,1}
  }
  
--  Класс ГГ

  player = {
    x = 32,
    y = 118,
    jump = false,
    jumpSize = 0,
    coll = {
      left = false,
      right = false,
      top = false,
      bottom = false
    },
    points = {
      lTop = {x = 0, y = 0},
      rTop = {x = 0, y = 0},
      lBottom = {x = 0, y = 0},
      rBottom = {x = 0, y = 0}
    }
  }
  
--  Функция дебага (не думал что пригодиться)
  
  function player.debug()
    
    if player.coll.left then
      left = 1
    else
      left = 0
    end
    
    if player.coll.right then
      right = 1
    else
      right = 0
    end
    
    if player.coll.top then
      top = 1
    else
      top = 0
    end
    
    if player.coll.bottom then
      bottom = 1
    else
      bottom = 0
    end
    
    print(
      "Left: " .. left .. 
      ", Right: " .. right ..
      ", Top: " .. top ..
      ", Bottom: " .. bottom
    )
  end

--  Для удобства
  
  pp = player.points
  
--  Функция получения координат угловых точек ГГ

  function player.getPoints()
    pp.lTop = {x = player.x, y = player.y}
    pp.rTop = {x = player.x + 32, y = player.y}
    pp.lBottom = {x = player.x, y = player.y + 32}
    pp.rBottom = {x = player.x + 32, y = player.y + 32}
  end
  
--  Расчет коллизии нижнего блока
  
  function player.bottom(unit)
    local x1 = math.floor((pp.lBottom.x + 1) / 32) + 1
    local x2 = math.floor((pp.rBottom.x - 1) / 32) + 1
    local y1 = math.floor((pp.lBottom.y + unit) / 32) + 1
    local y2 = math.floor((pp.rBottom.y + unit) / 32) + 1
    if map[y1][x1] == 1 or map[y2][x2] == 1 then
      player.y = (y1 - 2) * 32
      player.coll.bottom = true
    else
      player.coll.bottom = false
    end
  end
  
--  Расчет коллизии верхнего блока

  function player.top(unit)
    local x1 = math.floor((pp.lTop.x + 1) / 32) + 1
    local x2 = math.floor((pp.rTop.x - 1) / 32) + 1
    local y1 = math.floor((pp.lTop.y - unit) / 32) + 1
    local y2 = math.floor((pp.rTop.y - unit) / 32) + 1
    if map[y1][x1] == 1 or map[y2][x2] == 1 then
      player.y = y1 * 32
      player.coll.top = true
    else
      player.coll.top = false
    end
  end
  
--  Расчет коллизии правого бокового блока
  
  function player.right(unit)
    local x1 = math.floor((pp.rTop.x + unit) / 32) + 1
    local x2 = math.floor((pp.rBottom.x + unit) / 32) + 1
    local y1 = math.floor((pp.rTop.y + 1) / 32) + 1
    local y2 = math.floor((pp.rBottom.y - 1) / 32) + 1
    if map[x1][y1] == 1 or map[x2][y2] == 1 then
      player.x = (x1 - 2) * 32
      player.coll.right = true
    else
      player.coll.right = false
    end
  end
  
  function player.left(unit)
    local x1 = math.floor((pp.lTop.x - unit) / 32) + 1
    local x2 = math.floor((pp.lBottom.x - unit) / 32) + 1
    local y1 = math.floor((pp.lTop.y + 1) / 32) + 1
    local y2 = math.floor((pp.lBottom.y - 1) / 32) + 1
    if map[x1][y1] == 1 or map[x2][y2] == 1 then
      player.x = x1 * 32
      player.coll.left = true
    else
      player.coll.left = false
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

--Функция расчета

function love.update(dt)
  
--  Дебаг
  
  player.debug()
  
--  Еденица движения

  unit = dt * 500
  
  player.getPoints()
  player.bottom(unit)
  player.top(unit)
  player.right(unit)
  player.left(unit)
  
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
  
  if not player.coll.right and kb.isDown("d") then
    player.x = player.x + unit
  end
  
end

--Функция отрисовки

function love.draw()
  
--  Отрисовка карты
  
  for i = 1, #map do
    for k = 1, #map[i] do
      if map[i][k] == 1 then
        gr.rectangle("fill", (k - 1) * 32, (i - 1) * 32, 32, 32)
      end
    end
  end
  
--  Отрисовка ГГ
  
  gr.rectangle("fill", player.x, player.y, 32, 32)
  
end