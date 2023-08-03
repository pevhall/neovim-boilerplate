vim.cmd('abb o others')
vim.cmd('abb dt downto')
vim.cmd('abb sig signal')
vim.cmd('abb var variable')
vim.cmd('abb const constant')
vim.cmd('abb sl std_logic')
vim.cmd('abb slv std_logic_vector')
vim.cmd('abb pro process')
vim.cmd('abb func function')
vim.cmd('abb ret return')
vim.cmd('abb gen generate')
vim.cmd('abb re rising_edge')

local function getSpaceString(len)
  local result = ''
  for _ = 1, len, 1 do
    result = result .. ' '
  end
  return result
end

local function getCircleBracketDepth(str)
  local result = 0
  local comment = 0
  for i = 1, #str do
    local s = string.sub(str, i, i)
    if s == '(' then
      result = result + 1;
    elseif s == ')' then
      result = result - 1;
    elseif s == '-' then
      if comment == 1 then
        break --found comment
      end
      comment = comment + 1
    else
      comment = 0
    end
  end
  return result
end

local function vhdlModuleInstanceFromFile(opts)

  local named = nil
  if #opts.fargs > 2 then
    print("ERROR more then two arguemnts passed")
    return
  end;
  local file=io.open(opts.fargs[1],"r")

  if #opts.fargs == 2 then
    named = string.lower(opts.fargs[2])
  end

  if file == nil then
    print("ERROR: could not open file")
    return
  end

  local inEnt = false
  local inGens = false
  local inPorts = false
  local doneEnt = false

  local entityName
  local gens = {}
  local ports = {}
  local bracketCount = 0

  for line in file:lines() do
    local lineLower = string.lower(line)
    if not inEnt then
      if named == nil then
        entityName = string.match(lineLower, '^[^-]*entity%s+([%w_]+)%s+is.*')
        if entityName ~= nil then
          inEnt = true
        end
      else
        local m = string.match(lineLower, '^[^-]*component%s+'.. named ..'%s+is.*')
        if m == nil then
          m = string.match(lineLower, '^[^-]*entity%s+'.. named ..'%s+is.*')
        end
        if m ~= nil then
          entityName = named
          inEnt = true
        end
      end
    elseif inGens then
      local name = string.match(line, '^%s*([%w_]+)%s*:.*')
      if name ~= nil then
        table.insert(gens, name)
      end
      bracketCount = bracketCount + getCircleBracketDepth(line)
--      local mEnd = string.match(line, '^[^-]*%).*')
--      if mEnd ~= nil then
      if bracketCount == -1 then
        inGens = false
      end
    elseif inPorts then
      local name = string.match(line, '^%s*([%w_]+)%s*:.*')
      if name ~= nil then
        table.insert(ports, name)
      end
      bracketCount = bracketCount + getCircleBracketDepth(line)
      if bracketCount == -1 then
        inPorts = false
      end
    else
      local mGen = string.match(lineLower, '^[^-]*generic%s+%(')
      bracketCount = 0
      if mGen ~= nil then
        inGens = true
      else
        local mPort = string.match(lineLower, '^[^-]*port%s*%(')
        bracketCount = 0
        if mPort ~= nil then
          inPorts = true
        else
          local mEntEnd = string.match(lineLower, '^[^-]*end%s+'..entityName)
          if mEntEnd == nil then
            mEntEnd = string.match(lineLower, '^[^-]*end%s+entity')
          end
          if mEntEnd == nil then
            mEntEnd = string.match(lineLower, '^[^-]*end%s+component')
          end
          if mEntEnd ~= nil then
            inEnt = false
            doneEnt = true
            break
          end
        end
      end
    end
  end
  io.close(file)

  if not doneEnt then
    print("Warning: could not find entity")
    return
  end

  local maxLength = 0
  for _, v in pairs(gens) do
    local l = string.len(v)
    if l > maxLength then
      maxLength = l
    end
  end
  for _, v in pairs(ports) do
    local l = string.len(v)
    if l > maxLength then
      maxLength = l
    end
  end

  local wLines = {}
  table.insert(wLines, '  i_'..entityName..' : entity work.'..entityName)

  if next(gens) ~= nil then
    table.insert(wLines, '  generic map (')
    for i, v in ipairs(gens) do
      local space = getSpaceString(maxLength - string.len(v))
      local s = '    '..v..space..' => '..v
      if i ~= #gens then
        s = s .. ' ,'
      end
      table.insert(wLines, s)

    end
    table.insert(wLines, '  )')
  end
  if next(ports) ~= nil then
    table.insert(wLines, '  port map (')
    for i, v in ipairs(ports) do
      local space = getSpaceString(maxLength - string.len(v))
      local s = '    '..v..space..' => '..v
      if i ~= #ports then
        s = s .. ' ,'
      end
      table.insert(wLines, s)
    end
    table.insert(wLines, '  );')
  end
  local row, _ = table.unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_set_lines(0, row, row, false, wLines)
end

vim.api.nvim_create_user_command('VhdlInstance', vhdlModuleInstanceFromFile, { nargs='+' })

--function! WritePreserveDate()
--	let mtime = system("stat -c %.Y ".shellescape(expand('%:p')))
--	write
--	call system("touch --date='@".mtime."' ".shellescape(expand('%:p')))
--	edit
--endfunction
--
--vm('<leader>vpm', [[:s/^\(\s*\)\(\w\+\)\(\s*\).\{-}\(--.*\)\=$/\1\2\3=> \2:he,^I^I\4/e^M:s/\s\+$//e^M:.retab^Mzz"]])
