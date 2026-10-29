local Modes = {
  Normal = 'NOR',
  Insert = 'INS',
  Visual = 'VIS',
}

local mode = Modes.Normal

local inputState = ''

local function renderModeLine()
  local width, height = term.getSize()

  term.setCursorPos(1, height)

  local function renderModeLinePart(char)
    if char == ' ' then
      term.blit(char, '9', '9')
    else
      term.blit(char, '0', '9')
    end
  end

  local function getModeLineText()
    if mode == Modes.Normal then
      return inputState
    else
      return ''
    end
  end

  local modeLineBase = mode .. ' ' .. getModeLineText()
  local modeLine = modeLineBase .. string.rep(' ', width - string.len(modeLineBase))

  for char in modeLine:gmatch('.') do
    renderModeLinePart(char)
  end
end

local function setCursorPos()
  term.setCursorPos(1, 1)
end

local backspaced = false

local function handleKey()
  local event, payload = os.pullEvent()

  if event == 'key' and payload == keys.enter then
    if inputState == ':q' then
      return true
    end
  elseif event == 'key' and payload == keys.backspace then
    backspaced = true
  elseif event == 'char' and payload == '\\' then
    mode = Modes.Normal

    inputState = ''
  elseif event == 'char' and payload == 'i' then
    mode = Modes.Insert

    setCursorPos()
  elseif event == 'char' then
    inputState = inputState .. payload

    local _, height = term.getSize()

    if mode == Modes.Normal then
      term.setCursorPos(1, height)

      if backspaced == true then
        term.clearLine()
        inputState = string.sub(inputState, 1, -2)
        backspaced = false
      end
    elseif mode == Modes.Insert then
      if backspaced == true then
        term.clear()
        inputState = string.sub(inputState, 1, -2)
        backspaced = false
      end

      term.write(inputState)
    else
      term.write('Should not happen')
    end
  end

  return false
end

local function loop(exit)
  if exit then
    return
  end

  renderModeLine()

  setCursorPos()

  loop(handleKey())
end

term.clear()

loop(false)

term.clear()

setCursorPos()
