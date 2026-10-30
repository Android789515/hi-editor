local App = require('app')

local function getPreferences()
end

local function main(args)
  local preferences = getPreferences()

  local maybeFile = args[1]

  local app = App:new(maybeFile)

  app:render()

  app:resetScreen()
end

main({ ... })
