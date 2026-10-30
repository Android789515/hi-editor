local function detectLineEnding(path)
  -- Open the file in raw binary read mode
  local file = fs.open(path, 'rb')
  if not file then return nil, 'File not found' end

  local byte = file.read()
  while byte ~= nil do
    if byte == 13 then -- ASCII 13 is '\r' (Carriage Return)
      local nextByte = file.read()
      file.close()
      if nextByte == 10 then -- ASCII 10 is '\n' (Line Feed)
        return 'CRLF'        -- Windows standard (\r\n)
      else
        return 'CR'          -- Legacy Mac standard (\r)
      end
    elseif byte == 10 then   -- Found '\n' without a preceding '\r'
      file.close()
      return 'LF'            -- Unix/Linux/ComputerCraft standard (\n)
    end
    byte = file.read()
  end

  file.close()
  return 'LF' -- Default fallback if no newlines are found
end

return {
  detectLineEnding = detectLineEnding,
}
