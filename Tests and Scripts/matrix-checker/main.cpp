#include "matrix.h"
#include <vector>
#include <algorithm>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

using namespace std;
using namespace std::this_thread;     // sleep_for, sleep_until
using namespace std::chrono_literals; // ns, us, ms, s, h, etc.
using std::chrono::system_clock;

int main(void) {
    int n = 0;
    cout << "Input square matrix dimension (expects an integer): ";
    cin >> n;
    cout << endl;

    string fileLoc = to_string(n) + 'x' + to_string(n) + '/';

    // Load in matrix 1
    Matrix matrix1(fileLoc + "input_matrix_1.txt", n);
    //cout << "Matrix 1:\n" << matrix1.to_string() << endl << endl;

    // load in matrix 2
    Matrix matrix2(fileLoc + "input_matrix_2.txt", n);
    //cout << "Matrix 2:\n" << matrix2.to_string() << endl << endl;

    // Load in VHDL output
    Matrix output(fileLoc + "output_matrix.txt", n);

    Matrix tmp = matrix1 * matrix2;

    // get error
    output = output - tmp;

    // export error to file
    output.ExportToFile(fileLoc + "error.txt");


}
