--https://fhug.org.uk/kb/code-snippet/split-a-filename-into-path-file-and-extension/
function SplitFilename(strFilename)
  return strFilename:match("^(.-)([^\\/]-%.([^\\/%.]-))%.?$")
end

local ret_vhdlName = function ()
  local path = vim.fn.expand('%')
  dir, name, ext = SplitFilename(path)
  vhdlName = name:match("(.+)%..+$")
  return vhdlName
end

return {
  s('conr', fmt('constant {n} : real := {v};', { n = i(1), v = i(2),  } ) ),
  s('coni', fmt('constant {n} : integer := {v};', { n = i(1), v = i(2),  } ) ),
  s('conn', fmt('constant {n} : natural := {v};', { n = i(1), v = i(2),  } ) ),
  s('conp', fmt('constant {n} : positive := {v};', { n = i(1), v = i(2),  } ) ),
  s('conl', fmt('constant {n} : std_logic := {v};', { n = i(1), v = i(2),  } ) ),
  s('conv', fmt('constant {n} : std_logic_vector({w}-1 downto 0) := {v};', { n = i(1), w = i(2), v = i(3),  } ) ),
  s('cons', fmt('constant {n} : signed({w}-1 downto 0) := {v};', { n = i(1), w = i(2), v = i(3),  } ) ),
  s('conu', fmt('constant {n} : unsigned({w}-1 downto 0) := {v};', { n = i(1), w = i(2), v = i(3),  } ) ),
  s('poril', fmt('{n}_i : in  std_logic{e}{v};', { n = i(1), v = i(2), e = extras.nonempty(2, ' := ', ''), } ) ),
  s('poriv', fmt('{n}_i : in  std_logic_vector({w}-1 downto 0){e}{v};', { n = i(1), w = i(2), v = i(3), e = extras.nonempty(3, ' := ', ''), } ) ),
  s('poris', fmt('{n}_i : in  signed({w}-1 downto 0){e}{v};', { n = i(1), w = i(2), v = i(3), e = extras.nonempty(3, ' := ', ''), } ) ),
  s('poriu', fmt('{n}_i : in  unsigned({w}-1 downto 0){e}{v};', { n = i(1), w = i(2), v = i(3), e = extras.nonempty(3, ' := ', ''), } ) ),
  s('porol', fmt('{n}_o : out std_logic{v};', { n = i(1), v = i(2),  } ) ),
  s('porov', fmt('{n}_o : out std_logic_vector({w}-1 downto 0){v};', { n = i(1), w = i(2), v = i(3),  } ) ),
  s('poros', fmt('{n}_o : out signed({w}-1 downto 0){v};', { n = i(1), w = i(2), v = i(3),  } ) ),
  s('porou', fmt('{n}_o : out unsigned({w}-1 downto 0){v};', { n = i(1), w = i(2), v = i(3),  } ) ),
  s('sigl', fmt('signal {n} : std_logic{e}{v};', { n = i(1), v = i(2), e = extras.nonempty(2, ' := ', ''), } ) ),
  s('sigv', fmt('signal {n} : std_logic_vector({w}-1 downto 0){e}{v};', { n = i(1), w = i(2), v = i(3), e = extras.nonempty(3, ' := ', ''), } ) ),
  s('sigs', fmt('signal {n} : signed({w}-1 downto 0){e}{v};', { n = i(1), w = i(2), v = i(3), e = extras.nonempty(3, ' := ', ''), } ) ),
  s('sigu', fmt('signal {n} : unsigned({w}-1 downto 0){e}{v};', { n = i(1), w = i(2), v = i(3), e = extras.nonempty(3, ' := ', ''), } ) ),
  s('varl', fmt('varaible {n} : std_logic{e}{v};', { n = i(1), v = i(2), e = extras.nonempty(2, ' := ', ''), } ) ),
  s('varv', fmt('varaible {n} : std_logic_vector({w}-1 downto 0){e}{v};', { n = i(1), w = i(2), v = i(3), e = extras.nonempty(3, ' := ', ''), } ) ),
  s('vars', fmt('varaible {n} : signed({w}-1 downto 0){e}{v};', { n = i(1), w = i(2), v = i(3), e = extras.nonempty(3, ' := ', ''), } ) ),
  s('varu', fmt('varaible {n} : unsigned({w}-1 downto 0){e}{v};', { n = i(1), w = i(2), v = i(3), e = extras.nonempty(3, ' := ', ''), } ) ),
  s('vari', fmt('varaible {n} : integer{e}{v};', { n = i(1), v = i(2), e = extras.nonempty(2, ' := ', ''), } ) ),
  s('o', fmt('(others => {v})', {v = i(1,[['0']]) } ) ),
  s('damdb', t([[attribute MARK_DEBUG : string;]]) ),
  s('amdb', fmt([[attribute MARK_DEBUG of {s} : signal is "TRUE";]], {s = i(1)  }) ),
  s('imgi', fmt('integer\'image({v})', { v = i(1) } ) ),
  s('imgr', fmt('real\'image({v})', { v = i(1) } ) ),
  s('eqimgi', fmt('"{v} = "&integer\'image({v2})', { v = i(1), v2 = extras.rep(1) } ) ),
  s('eqhstr', fmt('"{v} = "&to_hstring({v2})', { v = i(1), v2 = extras.rep(1) } ) ),
  s('rpimgi', fmt('report "{v} = "&integer\'image({v2});', { v = i(1), v2 = extras.rep(1) } ) ),
  s('rphstr', fmt('report "{v} = "&to_hstring({v2});', { v = i(1), v2 = extras.rep(1) } ) ),
  s('ass' , fmt('assert {v} report {r} severity {s};', {v = i(1), r = i(2), s = i(3, 'FAILURE')} ) ),
  s('libs', fmt([[
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
]], { } ) ),
  s('ent', fmt([[
entity {f} is
  generic (
    {g}
  );
  port (
    {p}
  );
end entity;
]], { f = f(ret_vhdlName, {}), g = i(1), p = i(2) } ) ),
  s('arch', fmt([[
architecture {n} of {f} is

  {v}

begin

end architecture;
]], { f = f(ret_vhdlName, {}), n = i(1, 'rtl'), v = i(2) } ) ),
  s('proce', fmt([[
process({c})
begin
  if rising_edge({c2}) then
    if {e} = '1' then
      {d}
    end if;
  end if;
end process;
]], {c = i(1,'clk_i'), c2 = extras.rep(1), e = i(2, 'ce_i'), d = i(3)} ) ),
  s('proc', fmt([[
process({c})
begin
  if rising_edge({c2}) then
    {d}
  end if;
end process;
]], {c = i(1,'clk_i'), c2 = extras.rep(1), d = i(2)} ) ),
  s('proa', fmt([[
process({a})
begin
  {d}
end process;
]], {a = i(1,'all'), d = i(2)} ) ),
  s('acntr', fmt([[
signal {n}_w_ovr : unsigned({w} downto 0) := {v};
alias {n2}_ovr is {n2}_w_ovr({w2});
alias {n2} is {n2}_w_ovr({w2}-1 downto 0);
]], {n = i(1,'cntr'), n2 = extras.rep(1), w=i(2), w2 = extras.rep(2), v = i(3, [[(others => '0')]]) } ) ),
--  s('iff', f(function(args, snip)
--    local env = snip.env
--    local res = {}
--    table.insert(res, 'if  then')
--    --table.insert(res, 'if ' .. snip.captures[1] .. then')
--    for _, ele in ipairs(env.LS_SELECT_RAW) do table.insert(res, '  ' .. ele) end
--    table.insert(res, 'end if;')
--    return res
--  end, { } )),
--  s('if', { t('if '), i(1), t(' then\n'),
----    f(function(args, snip)
----      local env = snip.env
----      local res = {}
----      for _, ele in ipairs(env.LS_SELECT_RAW) do table.insert(res, '  ' .. ele) end
----      return res
----    end, { } ),
--    t('end if;')
--  } ),
--  s("selected_text", f(function(args, snip)
--    local res, env = {}, snip.env
--    table.insert(res, "Selected Text (current line is " .. env.TM_LINE_NUMBER .. "):")
--    for _, ele in ipairs(env.LS_SELECT_RAW) do table.insert(res, ele) end
--    return res
--  end, {}))
}

