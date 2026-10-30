local function readFileContents(maybeFile)
  if maybeFile and not fs.isDir(maybeFile) then
    local file = fs.open(maybeFile)

    local contents = file.readAll()

    file.close()

    return contents
  else
    return ''
  end
end

return {
  readFileContents = readFileContents,
}
