local install = require('/install')

if fs.exists(install.installPath) then
  print('Updating...')

  for _, file in ipairs(install.appFiles) do
    if file ~= 'update.lua' then
      shell.run('rm', file)
    end
  end
else
  print('Reinstalling...')
end

shell.run('wget', install.baseURL .. 'install.lua')

shell.run('install')
