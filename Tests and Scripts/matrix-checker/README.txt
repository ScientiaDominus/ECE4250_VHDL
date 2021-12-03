Matrix-Checker
by Mason Fleck

This multiplies the two input matricies and compares it to the matrix in output_matrix.txt.

Requirements:
- Linux operating system or Windows Subsystem for Linux (this program uses pthread)
- gcc and make

Steps:
1. Run the simulation in ModelSim and obtain the result matrix
2. Copy both input matricies and the reuslt matrix files into a folder with the name 'NxN' where N is the size of the matrix
3. compile using the command 'make' if not done already
4. run 'matrix-checker.out'
5. Input the size of the matrix when asked (for an NxN matrix, just type in N where N is an integer)
6. Wait for the program to run
7. Check 'error.txt' to ensure the matrix in 'output_matrix.txt' matches the expected value. All values in 'error.txt' should be 0