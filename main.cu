#include <iostream>

#include "device_functions.h"
#include <cuda_runtime.h>
#include "cuda.h"
#include <string>
#include <fstream>
#include <sstream>

#include <vector>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <cmath>

#include "types.h"
#include "utils.h"
#include "gpu_single.h"

#include "utils.cu"
#include "gpu_single.cu"


int block_size = 1024; //1025 max (# of threads in a block)

int main(int argc, char *argv[]) {

    /**
    * Read the number of particles
    */
    int numOfParticles = atoi(argv[1]);

    /**
    * Read name of the file
    */
    std::string fileName = argv[2];
    std::ifstream stream(fileName.c_str());
    std::cout << "Reading file: " << fileName << std::endl;

    atom* atoms = new atom[numOfParticles];

    int heads = 0;
    int atomCount = 0;

    std::string token;
    std::string line;

    while(!stream.eof()) {
        //read line from file
        std::getline(stream, line);

        std::stringstream lineStream(line);
        
        lineStream >> token;
        if(token.compare("HEAD") == 0) {
            //skip the header

            heads++;
            std::cout << "Frame #" << heads << " processing. " << std::endl;
            std::cout << atomCount << " atoms read." << std::endl;

            atomCount = 0;
            continue;
        }

        //example: `ATOM  00000000    00000001    00000001    17.297  15.357  5.428   -0.548  15.9994`
        double val;
        //skip some stuff
        lineStream >> token;
        lineStream >> token;
        lineStream >> token;

        //double x, y, z, charge, mass;
        lineStream >> atoms[atomCount].x;
        lineStream >> atoms[atomCount].y;
        lineStream >> atoms[atomCount].z;
        lineStream >> atoms[atomCount].charge;
        lineStream >> atoms[atomCount].mass;

        atomCount++;
    }

    printf("Heads: %d\n", heads);
    printf("Atom Count: %d\n", atomCount);


    // int atoms_cnt = 200000;
    // int workload = 10;

    // atoms_cnt = atoi(argv[1]);
    // workload = atoi(argv[2]);

    // run_single_kernel(atoms_cnt, workload);

    // check for error
    cudaError_t error = cudaGetLastError();
    if(error != cudaSuccess)
    {
        // print the CUDA error message and exit
        printf("CUDA error: %s\n", cudaGetErrorString(error));
        exit(-1);
    }

	return 0;
}
