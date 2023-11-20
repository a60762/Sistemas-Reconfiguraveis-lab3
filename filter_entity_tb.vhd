
-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 13.11.2023 12:41:44 UTC

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity tb_filter is
end tb_filter;

architecture tb of tb_filter is

    component filter
        port (clock   : in std_logic;
              reset   : in std_logic;
              data_in : in std_logic_vector (15 downto 0);
              output  : out std_logic_vector (15 downto 0));
    end component;

    signal clock   : std_logic;
    signal reset   : std_logic;
    signal data_in : std_logic_vector (15 downto 0);
    signal output  : std_logic_vector (15 downto 0);

    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';
	
	-- File I/O ('input.txt' and 'output.exe')
	file input_file :text open read_mode is "input.txt";
	file output_file :text open write_mode is "output.txt";

begin

    dut : filter
    port map (clock   => clock,
              reset   => reset,
              data_in => data_in,
              output  => output);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clock is really your main clock signal
    clock <= TbClock;
		
	

    stimuli : process
		variable line_buffer : line; -- Buffer to hold each line from the file
		variable value_read : std_logic_vector(15 downto 0); -- Variable to store the converted data
		variable line_out : line; -- variable to hold output as a line to then write into "output.txt"
    begin
        -- EDIT Adapt initialization as needed
        data_in <= (others => '0');

        -- Reset generation
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        wait for 100 ns;
		
		-- Read each line from "input.txt" and apply it as input stimulli
		while not endfile(input_file) loop
			-- Read from "input.txt"
			readline(input_file, line_buffer); --Read one line into buffer
			read(line_buffer, value_read); --convert the line to std_logic_vector
			data_in <= value_read; -- Send 16 bit read value to FIR
			wait for TbPeriod; 
			
			-- Write to "output.txt"
			write(line_out, output);  -- convert output of FIR to a line
			writeline(output_file, line_out);  -- write the line to output file
		end loop;
		
		file_close(output_file);

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;