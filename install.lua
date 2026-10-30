local appFiles = {
  'update.lua',
  'util.lua',
  'io.lua',
  'app.lua',
  'main.lua',
}

local installPath = '/programs/hi-editor'

fs.makeDir(installPath)

local baseURL = 'https://raw.githubusercontent.com/Android789515/hi-editor/refs/heads/dev/'

print('Installing...')

for _, file in ipairs(appFiles) do
  local contents = os.run('wget', baseURL .. file)

  local appFile = fs.open(installPath .. file, 'w')

  appFile.write(contents)

  appFile.close()
end

print('Done')

return {
  appFiles = appFiles,
  installPath = installPath,
  baseURL = baseURL,
}
