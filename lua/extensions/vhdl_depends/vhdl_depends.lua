local lfs = require"lfs"

local deps_map = {['work'] = {}}
local deps_top = nil
local dep_compile_order = nil

local function extractFilenameWithoutExtension(path)
    local filename = path:match(".+/(.-)%.%w+$") or path:match(".+/(.-)$") or path:match("(.-)%.%w+$") or path
    return filename
end

local function update_file_list(f_path)
  print('trying to open '..f_path)
  local file = assert(io.open(f_path, 'r'))
  if file == nil then
    print("ERROR: could not open file "..f_path)
    return
  end
   deps_top = nil
   dep_compile_order = nil

  deps_map = {['work'] = {}}
  local deps_map_lib = deps_map['work']
  for line in file:lines() do
    local comment = string.match(line, '^%s*#') or string.match(line, '^%s*$')
    if comment == nil then
      local dep_name = extractFilenameWithoutExtension(line)
      if dep_name ~= nil then
        deps_map_lib[dep_name] = {['name'] = dep_name, ['file'] = line, ['update'] = nil, ['deps'] = {['pkgs'] = nil, ['ents'] = nil}}
      end
    end
  end
  vim.print(deps_map) --remove
end

local function package_ignore_filter(package_name)
  return string.match(package_name,'^[%w]+_ipkg')
end


local function vhdl_file_get_immediate_depends_str(f_path)

  print(f_path)
  local file=io.open(f_path,"r")
  if file == nil then
    print("ERROR: could not open file"..f_path)
    return
  end

  local packages = {}
  local entities = {}
  for line in file:lines() do
    local line_lower = string.lower(line)
    local package_name = string.match(line_lower, '^[^-]*use%s+work%.([%w_]+).*')
    if package_name ~= nil then
      if package_ignore_filter(package_name) then
        packages[#packages+1] = package_name
      end
    end
    local entityName = string.match(line_lower, '^[^-]*entity%s*work%.([%w_]+).*')
    if entityName ~= nil then
      entities[#entities+1] = entityName
    end
  end
  io.close(file)

  return packages, entities
end

local function vhdl_file_get_immediate_depends(f_path)
  local packages, entities = vhdl_file_get_immediate_depends_str(f_path)

  local dep_pkgs = {}
  if packages ~= nil then
    for _, v in ipairs(packages) do
      dep_pkgs[#dep_pkgs+1] = deps_map['work'][v]
    end
  end

  local dep_ents = {}
  if entities ~= nil then
    for _, v in ipairs(entities) do
      dep_ents[#dep_ents+1] = deps_map['work'][v]
    end
  end

  return dep_pkgs, dep_ents
end

local function vhdl_file_update_depends(dep_top_name)
  deps_top = nil
  dep_compile_order = nil

  local to_scan_map = {deps_map['work'][dep_top_name]}
  local scanned_map_check = {}

  while #to_scan_map > 0 do
    local d_map = table.remove(to_scan_map)
    vim.print(to_scan_map)
    vim.print('d_map')
    vim.print(d_map)
    local f_path = d_map['file']
    local f_modified = lfs.attributes(f_path, 'modification')

    if d_map['update'] == nil or d_map['update'] < f_modified then
      local dep_pkgs, dep_ents = vhdl_file_get_immediate_depends(f_path)

      d_map['deps'] = { ['pkgs'] = dep_pkgs, ['ents'] = dep_ents }
    end

    scanned_map_check[d_map['name']] = 1

    for _, v in ipairs(d_map['deps']['pkgs']) do
      if scanned_map_check[v['name']] == nil then
        to_scan_map[#to_scan_map+1] = v
      end
    end
    for _, v in ipairs(d_map['deps']['ents']) do
      if scanned_map_check[v['name']] == nil then
        to_scan_map[#to_scan_map+1] = v
      end
    end
  end
  deps_top = deps_map['work'][dep_top_name]
  print('deps_map =')
  vim.print(deps_map)
  print('deps_top')
  vim.print(deps_top)
end

local function update_fw_files(opts)
  if #opts.fargs ~= 1 then
    print("ERROR one arguemnts required")
    return
  end
  local fw_list_path = opts.fargs[1]

  update_file_list(fw_list_path)
end

local function update_deps_top(opts)
  if #opts.fargs ~= 1 then
    print("ERROR one arguemnts required")
    return
  end
  local dep_top_path = opts.fargs[1]
  local dep_top_name = extractFilenameWithoutExtension(dep_top_path)

  vhdl_file_update_depends(dep_top_name)
end

local dep_name_added = nil

local function priv_add_ent(dep)
  dep_name_added[dep['name']] = true
  print('dep name')
  vim.print(dep['name'])

  local pkgs = dep['deps']['pkgs']
  if pkgs ~= nil then
    for _, d in ipairs(pkgs )do
      if dep_name_added[d['name']] == nil then
        priv_add_ent(d)
      end
    end
  end

  local ents = dep['deps']['ents']
  if ents ~= nil then

    print('ents')
    vim.print(ents)
    for _, d in ipairs(ents) do
      vim.print('d name')
      vim.print(d['name'])
      print ('dep_name_added')
      if dep_name_added[d['name']] == nil then
        print('  Adding')
        priv_add_ent(d)
      end
    end
  end

  dep_compile_order[#dep_compile_order+1] = dep

end

local function update_compile_order()
  if dep_compile_order ~= nil then
    return
  end
  dep_name_added = {}
  dep_compile_order = {}

  print('deps_top')
  vim.print(deps_top)
  priv_add_ent(deps_top)
end

local function dep_list_to_dep_name_list(dep_list)
  vim.print(dep_list)
  local dep_name_list = {}
  for _, d in ipairs(dep_list) do
    dep_name_list[#dep_name_list+1] = d['name']
  end
  return dep_name_list
end

local function write_compile_order_list()
  vim.print(dep_compile_order)
  update_compile_order()
  print('a')
  vim.print(dep_compile_order)
  print('b')
  local compile_name_list = dep_list_to_dep_name_list(dep_compile_order)

  local row, _ = vim.api.nvim__buf_stats(0).current_lnum
  vim.api.nvim_buf_set_lines(0, row, row, false, compile_name_list)
end

vim.api.nvim_create_user_command('VhdlDepsFileList', update_fw_files,  { nargs='+' , complete='file'})
vim.api.nvim_create_user_command('VhdlDepsUpdate', update_deps_top,  { nargs='+' , complete='file'})
vim.api.nvim_create_user_command('VhdlDepsWriteCompileOrder', write_compile_order_list,  { nargs=0})

