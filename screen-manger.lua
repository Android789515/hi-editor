local Screen = {}

function Screen:createRootScreen()
  local termWidth, termHeight = term.getSize()

  local rootNode = window.create(term.current(), 1, 1, termWidth, termHeight)

  local state = {
    rootNode = rootNode,
    width = termWidth,
    height = termHeight,
    x = 1,
    y = 1,
    children = {},
  }

  setmetatable(state, self)

  self.__index = self

  return state
end

function Screen:createChildren(children)
  table.insert(self.children, children)

  return self.children[#self.children]
end

function Screen:new(parent, width, height, x, y)
  local state = {
    parent = parent,
    width = width,
    height = height,
    x = x,
    y = y,
    children = {},
  }

  setmetatable(state, self)

  self.__index = self

  return state
end

function Screen:split_horizontal(parent, scaleFactor)
  local childWidth = parent.width * scaleFactor

  local state = {
    leftChild = Screen:new(
      parent,
      childWidth,
      parent.height,
      parent.x,
      parent.y
    ),
    rightChild = Screen:new(
      parent,
      childWidth,
      parent.height,
      childWidth,
      parent.y
    )
  }

  setmetatable(state, self)

  self.__index = self

  return state
end

function Screen:getRootNode()
  if self.parent then
    return self.parent:getRootNode()
  else
    return self.rootNode
  end
end

function Screen:write(text, x, y)
  local rootNode

  if self.rootNode then
    rootNode = self.rootNode
  else
    rootNode = self:getRootNode()
  end

  rootNode.setCursorPos(x + self.x, y + self.y)

  rootNode.write(text)
end

function Screen:unmount()
  if self.rootNode then
    self.rootNode.setCursorPos(1, 1)
    self.rootNode.clear()
  end
end

return {
  Screen = Screen,
}
