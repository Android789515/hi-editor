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

for fileNumber, file in ipairs(appFiles) do
  local success = shell.run('wget', baseURL .. file)

  if success then
    print(fileNumber .. ' of ' .. #appFiles .. ' downloaded...')
  else
    print('Could not download file: ' .. file)
  end
end

print('Done')

return {
  appFiles = appFiles,
  installPath = installPath,
  baseURL = baseURL,
}
