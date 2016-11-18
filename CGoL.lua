local pairs = pairs
local setmetatable = setmetatable

local class = {}
function class:create(name)
  self[name] = {}
  local mt = {__index = self[name]}
  local mf = function(self, ...)
    local b = {}
    setmetatable(b, mt)
    b:__init(...)
    return b
  end
  setmetatable(self[name], {__call = mf})
  return self[name]
end

local function copy(a)
  local b = {}
  for i, v in pairs(a) do
    b[i] = v
  end
  return b
end

local CGoL = class:create("CGoL")

function CGoL:__init(matrix)
  self.n = #matrix
  self.m = #matrix[1]
  self.l = self.n*self.m

  self.this = self:flatten(matrix)
  self.next = copy(self.this)

  self.depth = 0
  self.visited = {}

  local f = function(t, i)
    if self.depth == 0 and self.visited[i] == nil then
      self.depth = 1
      self.visited[i] = true
      self:evaluate(i)
      self.depth = 0
    end
    return 0
  end
  self.mt = {__index = f}
  setmetatable(self.this, self.mt)
end

function CGoL:flatten(a)
  local b = {}
  for i, r in pairs(a) do
    for j, c in pairs(r) do
      if c == 1 then
        b[(i-1)*#r+j] = 1
      end
    end
  end
  return b
end

function CGoL:move()
  self.this = {}
  for i, v in pairs(self.next) do
  	self.this[i] = v
  end
  setmetatable(self.this, self.mt)
end

function CGoL:count(x1,x2,x3,y1,y2,y3)
  return self.this[x1+y1]+self.this[x2+y1]+self.this[x3+y1]
        +self.this[x1+y2]        +         self.this[x3+y2]
        +self.this[x1+y3]+self.this[x2+y3]+self.this[x3+y3]
end

function CGoL:evaluate(i)
  local x2 = (i - 1)%self.m
  local x1 = (x2 + self.m - 1)%self.m
  local x3 = (x2 + 1)%self.m
  local y2 = i - x2
  local y1 = (y2 + self.l - self.m)%self.l
  local y3 = (y2 + self.m)%self.l
  local n = self:count(x1,x2,x3,y1,y2,y3)
  self.next[i] = (n == 3 or (n == 2 and self.this[i] == 1)) and 1 or nil
end

function CGoL:nextgen()
  self.visited = {}
  for i, v in pairs(self.this) do
    self:evaluate(i)
  end
  self:move()
end

function CGoL:print()
  self.depth = 1
  local s = ""
  for i = 1, self.n do
    for j = 1, self.m do
      s = s..self.this[(i-1)*self.m+j]
    end
    s = s.."\n"
  end
  self.depth = 0
  s = s.."----------"
  print(s)
end

return CGoL
