
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
    {1,0,0,0,0,0,0,0,0,1},
    {1,0,1,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1},
    {1,0,1,1,1,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1},
    {1,1,1,1,1,1,1,1,1,1}
  }
  
--  Класс ГГ

  player = {
    x = 64,
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
  
--  Еденица движения

  unit = dt * 500
  
  player.getPoints()
  player.bottom(unit)
  player.top(unit)
  
  if not player.coll.bottom and not player.jump then
    player.y = player.y + unit
  end
  
  if player.jump and player.jumpSize < 16 and not player.coll.top then
    player.jumpSize = player.jumpSize + 1
    player.y = player.y - unit
  else
    player.jumpSize = 0
    player.jump = false
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