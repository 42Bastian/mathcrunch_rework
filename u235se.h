/*
 * Copyright 2025 James Jones
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the “Software”), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#ifndef U235SE_H_
#define U235SE_H_

extern volatile unsigned long int *u235se_pad1;
extern volatile unsigned long int *u235se_pad2;

/* Bit numbers for buttons in the mask for testing individual bits */
#define U235SE_BBUT_UP      0
#define U235SE_BBUT_DOWN    1
#define U235SE_BBUT_LEFT    2
#define U235SE_BBUT_RIGHT   3
#define U235SE_BBUT_HASH    4
#define U235SE_BBUT_9       5
#define U235SE_BBUT_6       6
#define U235SE_BBUT_3       7
#define U235SE_BBUT_PAUSE   8
#define U235SE_BBUT_A       9
#define U235SE_BBUT_OPTION  11
#define U235SE_BBUT_STAR    12
#define U235SE_BBUT_7       13
#define U235SE_BBUT_4       14
#define U235SE_BBUT_1       15
#define U235SE_BBUT_0       16
#define U235SE_BBUT_8       17
#define U235SE_BBUT_5       18
#define U235SE_BBUT_2       19
#define U235SE_BBUT_B       21
#define U235SE_BBUT_C       25

/* Numerical representations */
#define U235SE_BUT_UP       1
#define U235SE_BUT_DOWN	    2
#define U235SE_BUT_LEFT     4
#define U235SE_BUT_RIGHT    8
#define U235SE_BUT_HASH     16
#define U235SE_BUT_9        32
#define U235SE_BUT_6        64
#define U235SE_BUT_3        0x80
#define U235SE_BUT_PAUSE    0x100
#define U235SE_BUT_A        0x200
#define U235SE_BUT_OPTION   0x800
#define U235SE_BUT_STAR     0x1000
#define U235SE_BUT_7        0x2000
#define U235SE_BUT_4        0x4000
#define U235SE_BUT_1        0x8000
#define U235SE_BUT_0        0x10000
#define U235SE_BUT_8        0x20000
#define U235SE_BUT_5        0x40000
#define U235SE_BUT_2        0x80000
#define U235SE_BUT_B        0x200000
#define U235SE_BUT_C        0x2000000

#endif /* U235SE_H_ */

