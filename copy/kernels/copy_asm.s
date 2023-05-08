        .text
        .align 4
        .type   copy_asm, %function
        .global copy_asm
copy_asm:
        ldr w1,     [x0]
        ldp w2, w3, [x0, #4]
        ldp w4, w5, [x0, #12]
        ldp w6, w7, [x0, #20]

        str w1,     [x1]        
        stp w2, w3,  [x1, #8]
        stp w4, w5,  [x1, #24]
        stp w6, w7,  [x1, #40]

        ret
        .size copy_asm, (. - copy_asm)