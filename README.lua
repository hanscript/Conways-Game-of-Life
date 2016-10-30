--[[Conways Game of Life implementation in Lua 5.2

Only living cells are saved in memory.
Dead cells next to living cells are considered, but not saved in memory.
Isolated dead cells are ignored and not saved in memory.

World is periodic.]]

local matrix = {
  {0,0,1,0,0,0,0},
  {0,0,0,1,0,0,0},
  {0,1,1,1,0,0,0},
  {0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0},
}

local world = CGoL(matrix)
matrix = nil

world:print()
for i = 1, 25 do
  world:nextgen()
  world:print()
end
