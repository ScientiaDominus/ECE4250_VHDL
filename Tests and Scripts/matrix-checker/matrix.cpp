#include "matrix.h"

/*
 * ======== Constructors/Destructor ========
 */
Matrix::Matrix() {
    rows = 0;
    columns = 0;
    matrix = nullptr;
}

Matrix::Matrix(const Matrix &matrixToCopy) : Matrix{matrixToCopy.rows, matrixToCopy.columns, matrixToCopy.matrix} {}

Matrix::Matrix(uint64_t newRows, uint64_t newColumns) {
    rows = newRows;
    columns = newColumns;
    matrix = allocateMatrix(rows, columns);
}

Matrix::Matrix(uint64_t rows, uint64_t columns, double *array) : Matrix{rows, columns} {
    fillMatrix(matrix, array);
}

Matrix::Matrix(string filePath, int n) {
    ifstream matrixFile;

    try {
        matrixFile.open(filePath);
        if(matrixFile.fail()) {
            throw "Failed to open file";
        }


        cout << "Starting file read " << filePath << "... ";

        rows = n;
        if(rows < 0) {
            throw "Number of rows cannot be negative!";
        }

        columns = rows;

        matrix = allocateMatrix(rows, columns);
        double *tmpMatrixPtr = matrix;

        /* This method produces this in memory (like a normal 2D array):
         *
         *  Matrix:               RAM:
         * 1 2 3 4 5
         * 6 7 8 9 10       ->  1 2 3 4 5 6 7....
         * 11 12 13 14 15
         *
         */
        for(uint64_t i = 0; i < rows * columns; i++) {
            matrixFile >> *tmpMatrixPtr;
            tmpMatrixPtr++;
        }

        cout << "Finished file read" << endl;

        matrixFile.close();
    }
    catch(const char* message) {
        cerr << message << endl;
        rows = 0;
        columns = 0;
        matrix = nullptr;
        return;
    }
}

Matrix::~Matrix() {
    if(matrix != nullptr) {
        delete[] matrix;
    }
}


/*
 * ======== Helper Functions ========
 */
string Matrix::to_string() {
    double * matrixPtr = matrix;
    stringstream ss;

    ss << "Rows: " << rows << " / Columns: " << columns << endl;

    if(matrix == nullptr) {
        return "No Matrix";
    }

    for(uint64_t i = 0; i < rows; i++) {
        for(uint64_t j = 0; j < columns; j++) {
            ss << *matrixPtr << " ";
            matrixPtr++;
        }
        ss << endl;
    }

    return ss.str();
}

void Matrix::fillMatrix(double * matrixToFill, double *matrixToFillFrom) {
    if (matrixToFill == nullptr || matrixToFillFrom == nullptr) {
        cout << "At least one matrix is nullptr\n";
        return;
    }

    //cout << "Copying matrix ... ";
    for(uint64_t i = 0; i < rows; i++) {
        for(uint64_t j = 0; j < columns; j++) {
            *matrixToFill = *matrixToFillFrom;
            matrixToFill++;
            matrixToFillFrom++;
        }
    }
    //cout << "Finished matrix copy.\n";
}

double *Matrix::allocateMatrix(uint64_t rows, uint64_t columns) {
    try {
        // 'new' doesnt initialize memory by default. the () initializes it to zero.
        // This only really matters for the matrix multiplication. I could set each value to zero
        // during the multiplication loop, but that adds time :)
        return new double[rows * columns]();
    }
    catch(const std::bad_alloc&) {
        cerr << "Bad allocation. You sure there's enough memory for this matrix?"  << endl;
        return nullptr;
    }
}

// how slow do he go? Short answer: Very.
void Matrix::MultiplySlow(Matrix& rightMatrix) {
    if(matrix == nullptr || rightMatrix.matrix == nullptr) {
        cerr << "Tried to multiply a matrix that doesnt exist.\n";
        return;
    }
    if(columns != rightMatrix.rows) {
        cerr << "The number of rows of the first matrix must equal the number of columns of the second to multiply\n";
        return;
    }
    Matrix result(rows, rightMatrix.columns);
    double *tmpLeftMtx = matrix, *tmpRightMtx = rightMatrix.matrix, *resultMtx = result.matrix;

    cout << "Beginning slow matrix multiplication ... ";
    auto start = chrono::high_resolution_clock::now();

    for(uint64_t i = 0; i < rows; i++) {
        // It would probably be good to split the j loop up into threads.
        for(uint64_t j = 0; j < rightMatrix.columns; j++) { // columns == rightMatrix.rows
            tmpRightMtx = rightMatrix.matrix + j;
            tmpLeftMtx = matrix + (i* columns);

            for(uint64_t k = 0; k < columns; k++) {
                // This is all an overcomplicated way to write:
                // resultMtx[i][j] += tmpLeftMtx[i][k] * tmpRightMtx[k][j]
                *resultMtx += *tmpLeftMtx * *tmpRightMtx;
                tmpLeftMtx++;
                tmpRightMtx += rightMatrix.columns;
            }
            resultMtx++;
        }
    }

    auto stop = std::chrono::high_resolution_clock::now();
    chrono::duration<double> elapsed = stop - start;
    cout << "finished in " << elapsed.count() << " seconds\n";
    *this = result;
}

Matrix Matrix::Transpose() {
    // transpose swaps columns and rows (flip along diagonal)
    Matrix transpose(columns, rows);
    double * tmpTransposeMtx = transpose.matrix, *tmpThisMtx;

    // Why did I decide to do pointer math instead of using array[][] notation? No clue...
    for(uint64_t i = 0; i < transpose.rows; i++) {
        tmpThisMtx = matrix + i;

        for(uint64_t j = 0; j < transpose.columns; j++) {
            *tmpTransposeMtx = *tmpThisMtx;
            tmpTransposeMtx++;
            tmpThisMtx += columns;
        }
    }
    return transpose;
}

void Matrix::ExportToFile(string filePath) {
    ofstream matrixFile;

    matrixFile.open(filePath);
    if(!matrixFile) {
        cerr << "Failed to open file: " << filePath << endl;
    }


    cout << "Starting file write ... ";

    //matrixFile << rows << endl;

    //matrixFile << columns << endl;

    double *tmpMatrixPtr = matrix;

    for(uint64_t i = 0; i < rows; i++) {
        for(uint64_t j = 0; j < columns; j++) {
            matrixFile << *tmpMatrixPtr << " ";
            tmpMatrixPtr++;
        }
        matrixFile << endl;
    }

    cout << "Finished file write" << endl;

    matrixFile.close();

}

double *Matrix::getMtxPtr() {
    return matrix;
}

/*
 * ======== Operator overloads ========
 */
Matrix Matrix::operator*(Matrix& rightMatrix) {
    if(matrix == nullptr || rightMatrix.matrix == nullptr) {
        cerr << "Tried to add a matrix that doesnt exist.\n";
        return *this;
    }
    if(columns != rightMatrix.rows) {  // left number of columns must == right number of rows
        cerr << "The number of rows of the first matrix must equal the number of columns of the second to multiply\n";
        return *this;
    }

    Matrix result(rows, rightMatrix.columns);

    // You're more than welcome to define your own number of threads, though c++ has this built into <thread>
    uint64_t numThreads = thread::hardware_concurrency();  // please dont try to use 2^64 threads thats mentally painful for me to think about
    //uint64_t numThreads = 16;  // I mean I guessss you can use this if you want...
    if(numThreads == 0) {
        numThreads = 2; // just in case the above function cant figure it out, there's this. I sincerely hope no one is running a single thread CPU nowadays
    }
    if(numThreads > rows) {
        numThreads = rows;   // The way I wrote the multiplication means this shouldnt really be necessary (and it seems to work without it in testing)
    }

    pthread_t threadIDs[numThreads];
    int returnCode = 0;
    uint64_t chunkSize = rows / numThreads;

    threadStorage_t matrixStoredValues[numThreads];  // realistcally, half of this is read only

    // printfs for the multithreaded stuff because of cout behavior
    printf("Beginning (hopefully) faster matrix multiplication using %ld threads ... ", numThreads);
    auto start = chrono::high_resolution_clock::now();

    // This is probably really inefficient for multiplying matrices where the left number of rows is large but the left column number is small
    for(uint64_t i = 0; i < numThreads; i++) {
        matrixStoredValues[i].threadNum = i;
        matrixStoredValues[i].leftColumns = columns;
        matrixStoredValues[i].rightColumns = rightMatrix.columns;
        matrixStoredValues[i].defaultChunkSize = chunkSize;

        matrixStoredValues[i].leftMtxPtr = matrix;
        matrixStoredValues[i].rightMtxPtr = rightMatrix.matrix;
        matrixStoredValues[i].resultMtxPtr = result.matrix;

        matrixStoredValues[i].startLocation = i * chunkSize;
        matrixStoredValues[i].endLocation = matrixStoredValues[i].startLocation + chunkSize;
        if (i == numThreads - 1) {
            matrixStoredValues[i].endLocation += rows % numThreads; // Last thread potentially gets some extra work
        }
        // Split the j loop up into threads. No return params (modifies the matrix directly)

        returnCode = pthread_create(&threadIDs[i], NULL, matrixThreadMultTask, &matrixStoredValues[i]);
        if(returnCode) {
            printf("Failed to create thread %ld\n", i);
        }
    }
    // If pthread_join is in the above loop, it waits for each thread to exit before moving to the next one
    // If pthread_join is in another loop (like below), it creates all the threads then waits for them to complete down here
    for(uint64_t i = 0; i < numThreads; i++) {
        pthread_join(threadIDs[i], NULL);
    }

    auto stop = std::chrono::high_resolution_clock::now();
    chrono::duration<double> elapsed = stop - start;
    printf("finished in %f seconds\n", elapsed.count());

    return result;
}

void *Matrix::matrixThreadMultTask(void *arg) {
    threadStorage_t *storedValues = (threadStorage_t*)arg;

    // figured I'd pull these into their own variables since they constantly get read
    uint64_t threadNum = storedValues->threadNum;
    uint64_t leftColumns = storedValues->leftColumns;
    uint64_t rightColumns = storedValues->rightColumns;
    uint64_t startLocation = storedValues->startLocation;
    uint64_t endLocation = storedValues->endLocation;
    uint64_t chunkSize = storedValues->defaultChunkSize;
    //printf("thread: %ld, thread chunk size: %ld, start loc: %ld, end Loc: %ld\n", threadNum, endLocation - startLocation, startLocation, endLocation);

    // result mtx pointer + offset for i
    double *tmpResultMtx = storedValues->resultMtxPtr + (threadNum * rightColumns * chunkSize);
    double *tmpRightMtx, *tmpLeftMtx;

    for(uint64_t i = startLocation; i < endLocation; i++) {
        for(uint64_t j = 0; j < rightColumns; j++) { // columns == rightMatrix.rows
            tmpRightMtx = storedValues->rightMtxPtr + j;
            tmpLeftMtx = storedValues->leftMtxPtr + i * leftColumns;

            for(uint64_t k = 0; k < leftColumns; k++) {
                // This is all an overcomplicated way to eventually do:
                // resultMtx[i][j] += tmpLeftMtx[i][k] * tmpRightMtx[k][j]
                *tmpResultMtx += *tmpLeftMtx * *tmpRightMtx;
                tmpLeftMtx++;
                tmpRightMtx += rightColumns;
            }
            tmpResultMtx++;
        }
    }
    pthread_exit(0);
}

Matrix Matrix::operator*(const double &scalar) {
    if(matrix == nullptr) {
        cerr << "Tried to multiply a matrix that doesnt exist.\n";
        return *this;
    }
    Matrix mult(*this);
    double* tempPtr = mult.matrix;

    // Matrix is all in one chunk so you can just iterate through it like this
    for(uint64_t i = 0; i < rows * columns; i++) {
        *tempPtr *= scalar;
        tempPtr++;
    }

    return mult;
}


Matrix Matrix::operator+(const Matrix& rightMatrix) {
    if(matrix == nullptr || rightMatrix.matrix == nullptr) {
        cerr << "Tried to add a matrix that doesnt exist.\n";
        return *this;
    }

    if(rows != rightMatrix.rows || columns != rightMatrix.columns) {
        cerr << "Matricies are not the same dimensions!\n";
        return *this;
    }


    Matrix addition(*this);
    double *tempPtrL = addition.matrix, *tempPtrR = rightMatrix.matrix;

    for(uint64_t i = 0; i < rows * columns; i++) {
        *tempPtrL += *tempPtrR;
        tempPtrL++;
        tempPtrR++;
    }
    return addition;
}

Matrix Matrix::operator-(const Matrix &rightMatrix) {
    if(matrix == nullptr || rightMatrix.matrix == nullptr) {
        cerr << "Tried to subtract a matrix that doesnt exist.\n";
        return *this;
    }

    if(rows != rightMatrix.rows || columns != rightMatrix.columns) {
        cerr << "Matricies are not the same dimensions!\n";
        return *this;
    }


    Matrix subtract(*this);
    double *tempPtrL = subtract.matrix, *tempPtrR = rightMatrix.matrix;

    for(uint64_t i = 0; i < rows * columns; i++) {
        *tempPtrL -= *tempPtrR;
        tempPtrL++;
        tempPtrR++;
    }
    return subtract;
}

Matrix Matrix::operator^(const uint64_t& power) {
    // Sets some limits. Exponents must be ints >= 2
    // In order to take a matrix to a power, it must be a square matrix.
    if(rows != columns || power < 2) {
        return *this;
    }

    if(matrix == nullptr) {
        cerr << "Tried to exponentiate a matrix that doesnt exist.\n";
        return *this;
    }

    Matrix exponent(*this);

    for(uint64_t i = 1; i < power; i++) {
        exponent = *this * exponent;
    }

    return exponent;
}

Matrix Matrix::operator-() {
    // nullptr matrix covered by matrix*scalar overload
    return *this * (-1);
}

Matrix& Matrix::operator=(const Matrix &rightMatrix) {
    rows = rightMatrix.rows;
    columns = rightMatrix.columns;

    if(matrix != nullptr) {
        delete[] matrix;
    }
    matrix = allocateMatrix(rows, columns);
    fillMatrix(matrix, rightMatrix.matrix);
    return *this;
}
