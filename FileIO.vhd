library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.array_type.all;

-- This test bench takes the matrix located in input_matrix_1.txt and multiplies it by the matrix located in
-- input_matrix_2.txt. The result is stored in output_matrix.txt.

-- Please note, some values may need to be changed such as the value of N and the locations of the files.
-- These lines have been marked with asterisks.
entity testBench is
end testBench;

architecture internals of testBench is

-- ******** Change this value to match the size of the NxN matricies ********
constant N : integer := 256;

-- [ References ]
-- https://www.ics.uci.edu/~jmoorkan/vhdlref/arrays.html
type t_matrix is array(0 to (N-1), 0 to (N-1)) of integer;

signal MemCheck, clk: std_logic;                            -- Clock signal and signal for waiting on
signal matrix1: mtx(0 to (N-1), 0 to (N-1));          -- The matrix that stores the activations
signal matrix2: mtx(0 to (N-1), 0 to (N-1));          -- The matrix that stores the weights
signal resultMatrix: mtx(0 to (N-1), 0 to (N-1));     -- The matrix used to store the result of the matrix multiplication
signal StoreDone: std_logic := '0';                         -- Signals when the result matrix is ready to be written to a file
signal writeDone: std_logic := '0';                         -- Signals when the result matrix has finished writing to the file

component top is
	generic(N: integer range 0 to 256);
	port(
		Mem_Check, clk: in std_logic;
		activations, weights: in mtx(0 to (N-1), 0 to (N-1));
		result: out mtx(0 to (N-1), 0 to (N-1));
		StoreD: out std_logic
	);
end component;

begin
process is
    -- [ References ]
	-- http://vhsichdl.blogspot.com/2015/10/vhdl-code-to-read-matrix-from-file.html
	-- http://web.engr.oregonstate.edu/~traylor/ece474/vhdl_lectures/text_io.pdf
	-- https://www.ics.uci.edu/~jmoorkan/vhdlref/filedec.html


	-- ******** This file path will need to be changed to match the file locations on your computer ********
    -- Locations of files
	file file_matrix2: text open read_mode is "C:\Users\cky39v\Desktop\work\input_matrix_1.txt";
	file file_matrix1: text open read_mode is "C:\Users\cky39v\Desktop\work\input_matrix_2.txt";
	file file_resultMatrix: text open write_mode is "C:\Users\cky39v\Desktop\work\output_matrix.txt";

    -- Variables for file i/o
	variable in_line_mtx1, in_line_mtx2: line;                 -- Lines used to read in values from the files
	variable result_line: line;                                -- Line used to write to the output file
	variable mtx1_elem, mtx2_elem, resultMtx_elem: integer;    -- Variables to temporarily store the elements being read in or written

begin
	for i in 0 to (N-1) loop    -- Read lines (row) from files
		readline(file_matrix1, in_line_mtx1);
		readline(file_matrix2, in_line_mtx2);

		for j in 0 to (N-1) loop    -- Read elements (column) from files
			read(in_line_mtx1, mtx1_elem);
			read(in_line_mtx2, mtx2_elem);
			matrix1(i,j) <= mtx1_elem;
			matrix2(i,j) <= mtx2_elem;
		end loop;
	end loop;

	MemCheck <= '1';               -- Signify that the calculation is ready to start

	wait until StoreDone = '1';    -- wait for result to be written to resultMatrix

	for i in 0 to (N-1) loop       -- Store results in file
		for j in 0 to (N-1) loop
			wait for 1 ns;						-- delay here that we may want to change
			write(result_line, resultMatrix(i,j));
			write(result_line, ' ');
		end loop;
		writeline(file_resultMatrix, result_line);
	end loop;

	writeDone <= '1';      -- Finished writing to file

	wait;      -- Do nothing

end process;
    -- Top level component
	TP00: top generic map(N) port map (MemCheck, clk, matrix1, matrix2, resultMatrix, StoreDone);
end internals;
