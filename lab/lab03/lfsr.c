#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "lfsr.h"

void lfsr_calculate(uint16_t *reg) {
    /* YOUR CODE HERE */
    uint16_t reg_ = *reg;
    uint16_t temp = 0;
    temp ^= reg_&0X0001;
    temp ^= (reg_>>2)&0X0001;
    temp ^= (reg_>>3)&0X0001;
    temp ^= (reg_>>5)&0X0001;
    temp = temp << 15;
    *reg = temp | (*reg >> 1);
}

