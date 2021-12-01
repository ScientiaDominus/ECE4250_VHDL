library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.array_type.all;


entity testBench is
end testBench;

architecture internals of testBench is

constant N : integer := 256;
-- https://www.ics.uci.edu/~jmoorkan/vhdlref/arrays.html
type t_matrix is array(0 to (N-1), 0 to (N-1)) of integer;

signal MemCheck, clk: std_logic;
signal matrix1: input_mtx(0 to (N-1), 0 to (N-1));
signal matrix2: input_mtx(0 to (N-1), 0 to (N-1));
signal resultMatrix: input_mtx(0 to (N-1), 0 to (N-1));
signal StoreDone: std_logic := '0';
signal writeDone: std_logic := '0';

component top is 
	generic(N: integer range 0 to 256);
	port(
		Mem_Check, clk: in std_logic;
		activations, weights: in input_mtx(0 to (N-1), 0 to (N-1));
		result: out input_mtx(0 to (N-1), 0 to (N-1));
		StoreD: out std_logic
	);
end component;

begin
process is

	-- http://vhsichdl.blogspot.com/2015/10/vhdl-code-to-read-matrix-from-file.html
	-- http://web.engr.oregonstate.edu/~traylor/ece474/vhdl_lectures/text_io.pdf
	-- https://www.ics.uci.edu/~jmoorkan/vhdlref/filedec.html


	-- Will need to change the file path here or make it a constant or something
	--file file_matrix1: text open read_mode is "C:\Users\mrf\Documents\`Classes\ECE 4250 - VHDL & Devices\Project\ECE4250_VHDL\input_matrix_1.txt";
	--file file_matrix2: text open read_mode is "C:\Users\mrf\Documents\`Classes\ECE 4250 - VHDL & Devices\Project\ECE4250_VHDL\input_matrix_2.txt";
	file file_matrix2: text open read_mode is "C:\Users\cky39v\Desktop\work\input_matrix_1.txt";
	file file_matrix1: text open read_mode is "C:\Users\cky39v\Desktop\work\input_matrix_2.txt";
	--file file_resultMatrix: text open write_mode is "C:\Users\mrf\Documents\`Classes\ECE 4250 - VHDL & Devices\Project\ECE4250_VHDL\output_matrix.txt";
	file file_resultMatrix: text open write_mode is "C:\Users\cky39v\Desktop\work\output_matrix.txt";

	variable in_line_mtx1, in_line_mtx2: line;
	variable result_line: line;
	variable mtx1_elem, mtx2_elem, resultMtx_elem: integer;

begin
	for i in 0 to (N-1) loop    -- Read lines (row)
		readline(file_matrix1, in_line_mtx1);
		readline(file_matrix2, in_line_mtx2);

		for j in 0 to (N-1) loop    -- Read elements (column)
			read(in_line_mtx1, mtx1_elem);
			read(in_line_mtx2, mtx2_elem);
			matrix1(i,j) <= mtx1_elem;
			matrix2(i,j) <= mtx2_elem;
		end loop;
	end loop;
	MemCheck <= '1';
	wait until StoreDone = '1';							 
		for i in 0 to (N-1) loop
			for j in 0 to (N-1) loop
				wait for 1 ns;						-- delay here that we may want to change
				write(result_line, resultMatrix(i,j));
				write(result_line, ' ');
			end loop;
			writeline(file_resultMatrix, result_line);
		end loop;
		writeDone <= '1';
	wait;
end process;
	TP00: top generic map(N) port map (MemCheck, clk, matrix1, matrix2, resultMatrix, StoreDone);
end internals;