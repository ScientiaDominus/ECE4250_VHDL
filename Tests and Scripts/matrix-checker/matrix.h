#ifndef MATRIX_H
#define MATRIX_H

#include <chrono>
#include <string>
#include <iostream>
#include <fstream>
#include <sstream>
#include <pthread.h>
#include <thread>

using namespace std;  // typing std:: is honestly way too much work

typedef struct threadStorage {
    uint64_t threadNum;         // Which thread is being executed
    uint64_t defaultChunkSize;  // numRows / numThreads
    uint64_t leftColumns;       // number of columns in the left matrix
    uint64_t rightColumns;      // number of columns in the right matrix
    uint64_t startLocation;     // ptr start location offset (in number of rows)
    uint64_t endLocation;       // ptr end location offset (in number of rows)
    double *leftMtxPtr;         // ptr to the left side matrix
    double *rightMtxPtr;        // ptr to the right side matrix
    double *resultMtxPtr;       // ptr to the result matrix
} threadStorage_t;

class Matrix {
public:
    uint64_t rows;          // I feel like this is self explanitory
    uint64_t columns;       // this one maybe not, but you're smart enough to figure out what its used for I'm sure

    Matrix();
    Matrix(const Matrix &matrixToCopy);         // copy
    Matrix(uint64_t rows, uint64_t columns);    // fill matrix later. Not super useful
    Matrix(uint64_t rows, uint64_t columns, double *array);  // fill matrix now
    Matrix(string filePath, int n);                    // Create from a file

    string to_string();                 // print matrix
    void MultiplySlow(Matrix&);         // oh so slow
    Matrix Transpose();                 // get the transpose of the matrix
    void ExportToFile(string filePath); // export to a file in the correct format
    double *getMtxPtr();                // get the location of the start of the matrix
    static void *matrixThreadMultTask(void *offset);  // task each thread runs

    Matrix operator*(Matrix&); // matrix multiplication
    Matrix operator*(const double& scalar); // multiplication by scalar post
    // normally I wouldn't have implemented this here but this is the best way I could find to do it...
    friend Matrix operator*(const double &scalar, Matrix &matrixToMult) { return matrixToMult * scalar;} // Mutiply by scalar pre
    Matrix operator+(const Matrix&);        // Matrix addition
    Matrix operator-(const Matrix&);        // Matrix subtraction
    Matrix operator^(const uint64_t&);      // I dont really want to deal with negative or float exponents
    Matrix operator-();                     // multiplies by -1
    Matrix& operator=(const Matrix &rightMatrix);   // =

    ~Matrix();

private:
    // I dont really want anyone to be able to modify the matrix ptr
    double *matrix = nullptr; // I'm assuming a max size of 10k x 10k ish since each matrix should consume ~750MB of RAM

    double* allocateMatrix(uint64_t rows, uint64_t columns);            // memory allocation
    void fillMatrix(double * matrixToFill, double *matrixToFillFrom);   // copy from one matrix to the other
};

#endif
