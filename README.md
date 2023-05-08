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

##### 5.2.2 Steping through code like we're hitting the clubs

**line 6**
After telling *GDB* to set a break point it sets it automatically in line 6 at the beginning of the function that we told it to do so. The content of the registers is copied to the following drop down section.

<details>
  <summary> start kernel function load_asm </summary>

```cpp
Breakpoint 1, load_asm () at kernels/build_asm.s:6
6               ldr x1,     [x0, #8]!
(gdb) info registers
x0             0x432ec0            4402880
x1             0x3e8               1000
x2             0x3e8               1000
x3             0x0                 0
x4             0x78                120
x5             0x0                 0
x6             0xfffff7c7138c      281474838762380
x7             0x4                 4
x8             0xfffff7f18000      281474841542656
x9             0x28                40
x10            0x0                 0
x11            0x0                 0
x12            0x3a                58
x13            0x3ba54b            3908939
x14            0xfffff7fff000      281474842488832
```

</details>

</br>

**line 7**
Line 7 loads data into the register `x1` that is 8 bytes shifted from address in register `x0`. One observes that the value changed from 1000 to 400.

<details>
  <summary> load data into register </summary>

```cpp
(gdb) step
7               ldp x2, x3, [x0]
(gdb) info registers
x0             0x432ec8            4402888
x1             0x190               400
x2             0x3e8               1000
x3             0x0                 0
x4             0x78                120
x5             0x0                 0
x6             0xfffff7c7138c      281474838762380
x7             0x4                 4
x8             0xfffff7f18000      281474841542656
x9             0x28                40
x10            0x0                 0
x11            0x0                 0
x12            0x3a                58
x13            0x3ba54b            3908939
x14            0xfffff7fff000      281474842488832
```

</details>

</br>

**line 8**
Line 8 loads two successive doublewords into the registers `x2` and `x3` that are not shifted from address in register `x0`. One observes that the values changed from 1000 and 0 to 400 and 500. It shall be noticed that the the value stored at the address that is stored in x0 is loaded into the register x3 and the value that is shifted by 8 byte is stored in x2. This is due to the fact that the system is little-endian. If the system is big-endian, the reverse is true.

<details>
  <summary> load two doublewords into registers </summary>

```cpp
(gdb) step
8               ldp x4, x5, [x0, #16]
(gdb) info registers
x0             0x432ec8            4402888
x1             0x190               400
x2             0x190               400
x3             0x1f4               500
x4             0x78                120
x5             0x0                 0
x6             0xfffff7c7138c      281474838762380
x7             0x4                 4
x8             0xfffff7f18000      281474841542656
x9             0x28                40
x10            0x0                 0
x11            0x0                 0
x12            0x3a                58
x13            0x3ba54b            3908939
x14            0xfffff7fff000      281474842488832
```

</details>

</br>

**line 9**
Line 9 loads two consecutive doublewords into the registers `x4` and `x5` that are 16 bytes shifted from address in register `x0`. One observes that the values changed from 120 and 0 to 600 and 700.

<details>
  <summary> load two doublewords into registers again </summary>

```cpp
(gdb) step
10              ret
(gdb) info registers
x0             0x432ec8            4402888
x1             0x190               400
x2             0x190               400
x3             0x1f4               500
x4             0x258               600
x5             0x2bc               700
x6             0xfffff7c7138c      281474838762380
x7             0x4                 4
x8             0xfffff7f18000      281474841542656
x9             0x28                40
x10            0x0                 0
x11            0x0                 0
x12            0x3a                58
x13            0x3ba54b            3908939
x14            0xfffff7fff000      281474842488832
```

</details>

</br>

**line 10**
The function returns.

##### 5.2.3 Troublesome code
Lines 18, 21, and 24 in the driver are troublesome because they pass invalid pointers to the load_asm function, which can cause the function to read outside the bounds of the allocated array. Specifically, these lines pass pointers to memory locations that are beyond the allocated memory block.

Line 18 passes a pointer to the 13th element of the array l_a, which is beyond the bounds of the allocated memory block.

Line 21 passes a pointer to the 9th element of the array l_a, which is not beyond the bounds of the allocated memory block per se but the following registers would try to access memory that is out of bounds.

Line 24 passes a pointer to the 7th element of the array l_a, which is still in bounds but again but there are no elements l_a[10], l_a[11] or l_a[12] within bounds of the allocated memory.

When these lines are uncommented and executed, they can cause undefined behavior, including memory access violations, segmentation faults, and other runtime errors. To detect such errors, we can use tools like Valgrind to analyze the program's memory usage.

#### 5.3 Copying Data
Unfortunately, for some reason I was not able to link the resulting three object files, because the compiler couldn't find the reference to the `copy_c` function.
Anyways, by comparing the disassembled assembly code file that was generated from the object of the *copy.c* file it is immediately noticable that there are much more instructions that have to be executed than in the assembly code of *copy_asm.s*. 

<details>
  <summary> assembly code from copy_c.o </summary>

```
0000000000000000 <_Z6copy_cPKjPm>:
   0:   d10043ff        sub     sp, sp, #0x10
   4:   f90007e0        str     x0, [sp, #8]
   8:   f90003e1        str     x1, [sp]
   c:   f94007e0        ldr     x0, [sp, #8]
  10:   b9400000        ldr     w0, [x0]
  14:   2a0003e1        mov     w1, w0
  18:   f94003e0        ldr     x0, [sp]
  1c:   f9000001        str     x1, [x0]
  20:   f94007e0        ldr     x0, [sp, #8]
  24:   91001000        add     x0, x0, #0x4
  28:   b9400001        ldr     w1, [x0]
  2c:   f94003e0        ldr     x0, [sp]
  30:   91002000        add     x0, x0, #0x8
  34:   2a0103e1        mov     w1, w1
  38:   f9000001        str     x1, [x0]
  3c:   f94007e0        ldr     x0, [sp, #8]
  40:   91002000        add     x0, x0, #0x8
  44:   b9400001        ldr     w1, [x0]
  48:   f94003e0        ldr     x0, [sp]
  4c:   91002000        add     x0, x0, #0x8
  50:   2a0103e1        mov     w1, w1
  54:   f9000001        str     x1, [x0]
  58:   f94007e0        ldr     x0, [sp, #8]
  5c:   91003000        add     x0, x0, #0xc
  60:   b9400001        ldr     w1, [x0]
  64:   f94003e0        ldr     x0, [sp]
  68:   91002000        add     x0, x0, #0x8
  6c:   2a0103e1        mov     w1, w1
  70:   f9000001        str     x1, [x0]
  74:   f94007e0        ldr     x0, [sp, #8]
  78:   91004000        add     x0, x0, #0x10
  7c:   b9400001        ldr     w1, [x0]
  80:   f94003e0        ldr     x0, [sp]
  84:   91002000        add     x0, x0, #0x8
  88:   2a0103e1        mov     w1, w1
  8c:   f9000001        str     x1, [x0]
  90:   f94007e0        ldr     x0, [sp, #8]
  94:   91005000        add     x0, x0, #0x14
  98:   b9400001        ldr     w1, [x0]
  9c:   f94003e0        ldr     x0, [sp]
  a0:   91002000        add     x0, x0, #0x8
  a4:   2a0103e1        mov     w1, w1
  a8:   f9000001        str     x1, [x0]
  ac:   f94007e0        ldr     x0, [sp, #8]
  b0:   91006000        add     x0, x0, #0x18
  b4:   b9400001        ldr     w1, [x0]
  b8:   f94003e0        ldr     x0, [sp]
  bc:   91002000        add     x0, x0, #0x8
  c0:   2a0103e1        mov     w1, w1
  c4:   f9000001        str     x1, [x0]
  c8:   d503201f        nop
  cc:   910043ff        add     sp, sp, #0x10
  d0:   d65f03c0        ret
```

</details>

</br>

The same holds true, when assigning the compiler to convert *copy.c* into assembly code through the `-S`flag.

<details>
  <summary> assembly code from copy_c.o </summary>

```
	.arch armv8-a
	.file	"copy.c"
	.text
	.align	2
	.global	_Z6copy_cPKjPm
	.type	_Z6copy_cPKjPm, %function
_Z6copy_cPKjPm:
.LFB16:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x0, [sp, 8]
	str	x1, [sp]
	ldr	x0, [sp, 8]
	ldr	w0, [x0]
	uxtw	x1, w0
	ldr	x0, [sp]
	str	x1, [x0]
	ldr	x0, [sp, 8]
	add	x0, x0, 4
	ldr	w1, [x0]
	ldr	x0, [sp]
	add	x0, x0, 8
	uxtw	x1, w1
	str	x1, [x0]
	ldr	x0, [sp, 8]
	add	x0, x0, 8
	ldr	w1, [x0]
	ldr	x0, [sp]
	add	x0, x0, 8
	uxtw	x1, w1
	str	x1, [x0]
	ldr	x0, [sp, 8]
	add	x0, x0, 12
	ldr	w1, [x0]
	ldr	x0, [sp]
	add	x0, x0, 8
	uxtw	x1, w1
	str	x1, [x0]
	ldr	x0, [sp, 8]
	add	x0, x0, 16
	ldr	w1, [x0]
	ldr	x0, [sp]
	add	x0, x0, 8
	uxtw	x1, w1
	str	x1, [x0]
	ldr	x0, [sp, 8]
	add	x0, x0, 20
	ldr	w1, [x0]
	ldr	x0, [sp]
	add	x0, x0, 8
	uxtw	x1, w1
	str	x1, [x0]
	ldr	x0, [sp, 8]
	add	x0, x0, 24
	ldr	w1, [x0]
	ldr	x0, [sp]
	add	x0, x0, 8
	uxtw	x1, w1
	str	x1, [x0]
	nop
	add	sp, sp, 16
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE16:
	.size	_Z6copy_cPKjPm, .-_Z6copy_cPKjPm
	.ident	"GCC: (GNU) 12.2.1 20221121 (Red Hat 12.2.1-4)"
	.section	.note.GNU-stack,"",@progbits

```

</details>

</br>