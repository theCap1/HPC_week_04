        .section    .rodata             // read only data section
my_msg: .asciz      "Hello World!\n"    // null-terminated string

        .text                           // text section
        .global hello_world_main

        /*
         * prints "Hello World!\n" and returns 0.
         */
hello_world_main:   stp     x29, x30, [sp, #-16]!

        // print "Hello World!\n" by calling printf
        adr     x0, my_msg
        bl      printf

        // return 0
        orr     w0, w0, wzr
        ldp     x29, x30, [sp], #16

        ret

        // size of main section
        .size   hello_world_main, (. - hello_world_main)