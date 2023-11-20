library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity filter is
  Port(
    clock: in std_logic;
	reset: in std_logic;
	data_in: in std_logic_vector(15 downto 0);
	output: out std_logic_vector(15 downto 0)
	);
end filter;

architecture behavior of filter is

	type sixteen_bit_array_type is array(0 to 12) of std_logic_vector(15 downto 0);

	constant rom_tap: sixteen_bit_array_type :=
	(
		"0000000000000000", -- position 0
		"0000000000000001", -- position 1
		"0000000000000100", -- position 2
		"0000000000001011", -- position 3
		"0000000000010100", -- position 4
		"0000000000011100", -- position 5
		"0000000000011111", -- position 6
		"0000000000011100", -- position 7
		"0000000000010100", -- position 8
		"0000000000001011", -- position 9
		"0000000000000100", -- position 10
		"0000000000000001", -- position 11
		"0000000000000000"  -- position 12
	);

	signal ram_filter_in: sixteen_bit_array_type := (others => (others =>'0'));

begin

	process(clock, reset)
		variable k: integer;
		variable sum: unsigned(31 downto 0);
	begin
		if rising_edge(clock) then
			if reset = '1' then -- Reset Logic
			
				for k in 0 to 12 loop
					ram_filter_in(k) <= (others => '0');
				end loop;
			
			else --Filter Operation
			
				ram_filter_in(0) <= data_in;
				sum:= (others => '0');
				
				for k in 0 to 12 loop 
					sum := sum + unsigned(ram_filter_in(k)) *unsigned(rom_tap(k));
				end loop;
			  
				for k in 1 to 12 loop
					ram_filter_in(k) <= ram_filter_in(k-1);
				end loop;
				
				output <= std_logic_vector(sum(15 downto 0));
			
			end if;
		end if;
	end process; 
end behavior;