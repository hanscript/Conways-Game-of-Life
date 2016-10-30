--[[Conways Game of Life implementation in Lua 5.2

Only living cells are saved in memory.
Dead cells next to living cells are considered, but not saved in memory.
Isolated dead cells are ignored and not saved in memory.

World is periodic.]]


--EXAMPLE

--10x10 world
local width = 10
local height = 10
--2DArray flattened to 1D. index starting at 0
local config = {[13]=1,[24]=1,[32]=1,[33]=1,[34]=1} --glider
local world = CGoL(width, height, config)
for i = 1, 10 do
  local s = "{"
  for j, v in pairs(world.this) do
    s = s.."["..j.."]="..v..","
  end
  s = s.."}\n"
  print(s)
  world:nextgen()
end
