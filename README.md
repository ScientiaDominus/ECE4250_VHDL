

# ECE4250_VHDL Systolic Array
This is a repository to contain and share files for the ECE 4250 VHDL project where we are tasked with designing and implementing a systolic array that completes complex matrix multiplication in VHDL.

## Description
### Authors
- Cameron Young
- Mason Fleck

### Input Signals
- **MemCheck** - Indicates when the matricies have been stored in the systolic array memory and that the calculation should start.
- **clk** - The clock signal for the systolic array
- **activations_mtx** - The matrix that is fed into the systolic array. This is the matrix located in *input_matrix_2.txt*
- **weights_mtx** - The matrix used as the stationary weights in the systolic array. This corresponds with the matrix located in *input_matrix_1.txt*
### Output Signals
- **resultMatrix** - This is the result of multiplying weights_mtx * activations_mtx. This matrix is stored in *output_matrix.txt*
- **StoreDone** - Indicates when the values stored in the accumulators have been stored in resultMatrix and that the calculation is complete

## File Hierarchy
- **Results/** - Screenshots of the simulation results from various sizes of matricies
- **'Tests and Scripts'/** - Contains a C program to test if the matrix computed in the VHDL simulation is correct, and also includes some scripts to initialize the systolic array for smaller matricies.
- **'test matricies/'** - These are the matricies that were included to test the functionality of the systolic array. They were the matricies used to obtain the values in the Results folder
- **Accumulator.vhd** -  Sums values over time as the result matrix is calculated
- **FileIO.vhd** - Contains the test bench for the systolic array. Reads and writes the matricies to and from files.
- **ProcessingElement.vhd** - Multiplication and ACcumulation (MAC) unit
- **README.md** - This readme file in Markdown format
- **SysControl.vhd** - Indicates the current state
- **SystolicArray.vhd** - Takes two matricies and multiplies them together using a weight stationary method
- **Top_Module.vhd** - Ties all of the different components together
- **input_matrix_1.txt** - Text file used to store matrix1
- **input_matrix_2.txt** - Text file used to store matrix2
- **output_matrix.txt** - Text file used to store the result of matrix1*matrix2 after calculation is complete

## Simulation Instructions
For any multiplication of two matricies mtx1*mtx2 where mtx1 and mtx2 are both NxN matricies and the values in both matricies are 32-bit signed integers,
1. Choose a value of N for the matrix. Set this value in the marked constant N in FileIO.vhd (approximately line 19).
2. Copy/paste the values for mtx1 into *input_matrix_1.txt*
3. Copy/paste the values for mtx2 into *input_matrix_2.txt*
4. Verify that the file locations specified in FileIO.vhd (approximately line 50) match the locations of *input_matrix_1.txt*, *input_matrix_2.txt*, and *output_matrix.txt*
5.  Compile all files
6. Start the simulation on the testbench component
7. Add signals to wave as desired. Recommended signals are as follows: clk, resultMatrix, and writeDone
8. Set clk to a clock of 100 with duty cycle 50.
9. Run the simulation until writeDone goes to '1'. For a 256x256 array, this takes about 200us (200ns on Intel ModelSim)
10. Check the resulting matrix in *output_matrix.txt*
11. If desired, the C program in *'Tests and Scripts/matrix-checker/'* can be used to verify the result of the multiplication is correct. Please see that folder for information on how to use it.



## Required Environment
ModelSim (tested with version 2021.3)
ModelSim Intel-FPGA Edition (tested with version 2020.1)
