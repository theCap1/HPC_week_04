# HPC_week_4
## Homework for the 4th week

### 5. Writing Assembly Code: AArch64
#### 5.1. A New World

The chosen example was the *hello_world* example. The Driver can be found directly in the *hello_world* folder. Kernels are in the sub folder *kernels* and binary, hex and disassembly files are found in the *build* subfolder. 
In the last sub exercise it was supposed to be shown, that there are aliases that would be assembled to different machinecode but disassembled to the same assembly code. For the *MOV-ORR* alias this was not the case. The reason for this remains unknown.
Writing machine code directly in a kernel was possible without any problems, though.

#### 5.2. GDB and Valgrind
##### 5.2.1 Code explanation
When executing the function call *load_asm( l_a+2 )* in the driver code, the argument passed to the function is a pointer to the third element of the array *l_a*. Since *l_a* is an array of uint64_t (64-bit integers), incrementing the pointer by 2 (i.e., *l_a+2*) skips the first two elements of the array and points to the third element.
When the load_asm function is called with the argument l_a+2, the value of l_a+2 is passed in register x0 as the first argument. Therefore, when the load_asm function is executed, the contents of registers x0, x1, x2, x3, x4, and x5 are as follows:

- x0: Points to the third element of the array l_a.
- x1: Contains the value of the fourth element of the array l_a (i.e., l_a[3]).
- x2: Contains the value of the fifth element of the array l_a (i.e., l_a[4]).
- x3: Contains the value of the sixth element of the array l_a (i.e., l_a[5]).
- x4: Contains the value of the seventh element of the array l_a (i.e., l_a[6]).
- x5: Contains the value of the eighth element of the array l_a (i.e., l_a[7]).

##### 5.2.3 Troublesome code
Lines 18, 21, and 24 in the driver are troublesome because they pass invalid pointers to the load_asm function, which can cause the function to read outside the bounds of the allocated array. Specifically, these lines pass pointers to memory locations that are beyond the allocated memory block.

Line 18 passes a pointer to the 13th element of the array l_a, which is beyond the bounds of the allocated memory block.

Line 21 passes a pointer to the 9th element of the array l_a, which is not beyond the bounds of the allocated memory block per se but the following registers would try to access memory that is out of bounds.

Line 24 passes a pointer to the 7th element of the array l_a, which is still in bounds but again but there are no elements l_a[10], l_a[11] or l_a[12] within bounds of the allocated memory.

When these lines are uncommented and executed, they can cause undefined behavior, including memory access violations, segmentation faults, and other runtime errors. To detect such errors, we can use tools like Valgrind to analyze the program's memory usage.