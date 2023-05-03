#include <cstdint>
#include <cmath>
#include <chrono>
#include <omp.h>
#include <iostream>

extern "C" {
  int hello_world_main();
}

int main(){
    printf("Calling hello_world main from C++ main...\n");
    int ret = hello_world_main();
    std::cout << "ret value is " << ret << std::endl;
    printf("hello_world main returned\n");
    return 0;
}