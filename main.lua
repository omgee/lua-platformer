
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
    {1,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1},
    {1,1,1,1,1,1,1,1,1,1}
  }
  
--  Класс ГГ

  player = {
    x = 44,
    y = 44,
    horizontalSpeed = 0,
    verticalSpeed = 0,
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
  
--  Функция получения координат угловых точек ГГ

  function player.getPoints()
    player.points.lTop = {x = player.x, y = player.y}
    player.points.rTop = {x = player.x + 32, y = player.y}
    player.points.lBottom = {x = player.x, y = player.y + 32}
    player.points.rBottom = {x = player.x + 32, y = player.y + 32}
  end
  
--  Расчет коллизии нижнего блока
  
  function player.bottom()
    
  end
  
end

--Функция расчета

function love.update(dt)
  
--  Еденица движения

  unit = dt * 250
  
  player.getPoints()
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