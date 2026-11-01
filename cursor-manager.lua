local CursorManager = {}

function CursorManager:new()
  local x, y = term.getCursorPos()

  local state = {
    x = x,
    y = y,
  }

  setmetatable(state, self)

  self.__index = self

  return state
end

function CursorManager:renderCursor()
  local prevTextColor = term.getTextColor()
  local prevBackgroundColor = term.getBackgroundColor()

  term.setTextColor(1)
  term.setBackgroundColor(1)

  write(' ')
  self:syncCursorPos()

  term.setTextColor(prevTextColor)
  term.setBackgroundColor(prevBackgroundColor)
end

function CursorManager:syncCursorPos()
  term.setCursorPos(self.x, self.y)
end

local function setCursorPos(self, x, y)
  self.x = x
  self.y = y

  self:syncCursorPos(self)
end

function CursorManager:reset()
  setCursorPos(self, 1, 1)
end

function CursorManager:moveUp()
  setCursorPos(self, self.x, self.y - 1)
end

function CursorManager:moveDown()
  setCursorPos(self, self.x, self.y + 1)
end

function CursorManager:moveLeft()
  setCursorPos(self, self.x - 1, self.y)
end

function CursorManager:moveRight()
  setCursorPos(self, self.x + 1, self.y)
end

function CursorManager:moveToLineEnd(lineAnchor, lineLen)
  local amountToMove = (lineAnchor + lineLen) - self.x

  for _ = 0, amountToMove do
    self:moveRight()
  end

  self:renderCursor()
end

function CursorManager:moveToLineBeg(lineAnchor)
  local amountToMove = self.x - lineAnchor

  for _ = 2, amountToMove do
    self:moveLeft()
  end

  self:renderCursor()
end

function CursorManager:moveToPrevLine(wrap, prevLineAnchor, prevLineLen)
  self:moveToLineBeg(prevLineAnchor)

  self:moveUp()

  if wrap then
    self:moveToLineEnd(prevLineAnchor, prevLineLen)
  end

  self:renderCursor()
end

function CursorManager:moveToNextLine(wrap, nextLineAnchor)
  self:moveDown()

  if wrap then
    self:moveToLineBeg(nextLineAnchor)
  end

  self:renderCursor()
end

return CursorManager
