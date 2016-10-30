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

function CGoL:__init(n, m, matrix)
  self.n = n
  self.m = m
  self.l = self.n*self.m

  self.this = matrix
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

function CGoL:move()
  self.this = {}
  for i, v in pairs(self.next) do
  	self.this[i] = v
  end
  setmetatable(self.this, self.mt)
end

function CGoL:count(x0,x1,x2,y0,y1,y2)
  return self.this[x0+y0]+self.this[x1+y0]+self.this[x2+y0]
        +self.this[x0+y1]+self.this[x2+y1]
        +self.this[x0+y2]+self.this[x1+y2]+self.this[x2+y2]
end

function CGoL:evaluate(i)
  local x1 = i%self.m
  local x0 = (x1 + self.m - 1)%self.m
  local x2 = (x1 + 1)%self.m
  local y1 = i - x1
  local y0 = (y1 + self.l - self.m)%self.l
  local y2 = (y1 + self.m)%self.l
  local n = self:count(x0,x1,x2,y0,y1,y2)
  self.next[i] = (n == 3 or (n == 2 and self.this[i] == 1)) and 1 or nil
end

function CGoL:nextgen()
  self.visited = {}
  for i, v in pairs(self.this) do
    self:evaluate(i)
  end
  self:move()
end
