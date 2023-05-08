#include <stdint.h>
#include <stdlib.h>

void copy_c(uint32_t const * i_a,
            uint64_t       * o_b){
    
    *(o_b) = *(i_a);
    *(o_b+1) = *(i_a+1);
    *(o_b+1) = *(i_a+2);
    *(o_b+1) = *(i_a+3);
    *(o_b+1) = *(i_a+4);
    *(o_b+1) = *(i_a+5);
    *(o_b+1) = *(i_a+6);
    
}