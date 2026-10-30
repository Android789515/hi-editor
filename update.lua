local install = require('install')

if fs.exists(install.installPath) then
  print('Updating...')

  for file in install.appFiles do
    if file ~= 'update.lua' then
      os.run('rm', file)
    end
  end
else
  print('Reinstalling...')
end

os.run('wget', install.baseURL .. 'install.lua')
