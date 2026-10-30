local util = require('util')
local detectLineEnding = util.detectLineEnding

local io = require('io')
local readFileContents = io.readFileContents

local Modes = {
  Normal = 'NOR',
  Insert = 'INS',
  Visual = 'VIS',
}

local App = {}

function App:new(maybeFile)
  local buffer = readFileContents(maybeFile)
  local lineEnding = detectLineEnding(maybeFile) or 'LF'

  local state = {
    run = true,
    buffer = buffer,
    lineEnding = lineEnding,
    mode = Modes.Normal,
    nonBufferInput = '',
  }

  setmetatable(state, self)
  self.__index = self

  return state
end

function App:render()
  if self.run then
    term.clear()

    local termWidth, termHeight = term.getSize()

    self:renderBuffer()

    self:renderStatusLine(termWidth, termHeight)

    self:handleKey()

    self:render()
  end
end

function App:renderBuffer()
end

local function renderStatusLineChar(char)
  local textColor, backgroundColor = '0', '9'

  if char == ' ' then
    textColor = '9'
    backgroundColor = '9'
  end

  term.blit(char, textColor, backgroundColor)
end

function App:renderStatusLine(termWidth, termHeight)
  term.setCursorPos(1, termHeight)

  local statusLineBeg = self.mode .. ' ' .. self.nonBufferInput
  local statusLineEnd = self.lineEnding
  local statusLineMid = string.rep(' ', termWidth - string.len(statusLineBeg) - string.len(statusLineEnd))

  local statusLine = statusLineBeg .. statusLineMid .. statusLineEnd

  for char in statusLine:gmatch('.') do
    renderStatusLineChar(char)
  end
end

function App:handleKey()
  local event, payload = os.pullEvent('char')

  if payload == 'q' then
    self.run = false
  end
end

function App:resetScreen()
  term.clear()
  term.setCursorPos(1, 1)
end

return App
