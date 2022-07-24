#include <stdio.h>
#include "bit_ops.h"

// Return the nth bit of x.
// Assume 0 <= n <= 31
unsigned get_bit(unsigned x,
                 unsigned n) {
    // YOUR CODE HERE
    // Returning -1 is a placeholder (it makes
    // no sense, because get_bit only returns 
    // 0 or 1)
    unsigned temp = 1 << n;
    x &= temp;
    return x >> n;
}
// Set the nth bit of the value of x to v.
// Assume 0 <= n <= 31, and v is 0 or 1
void set_bit(unsigned * x,
             unsigned n,
             unsigned v) {
    // YOUR CODE HERE
    // if(0 == v){
    //     unsigned temp = ((0XFFFFFFFF << (n+1)) | (0XFFFFFFFF >> (32-n)));
    //     (*x) &= temp;
    // }
    // else
    //     *x |= (1 << n);
    	unsigned a = 1;
	unsigned b = 0;
	
	b = ~b; 
	b = b<<(n+1);
	
	// 构造 v; v = 1x11, x是要改变成的值 0 or 1.
	v = ~v;
	v = v << n;
	v = ~v;
	v = v|b;
	
	// 把 x 的 n 位置为 1
	a = a << n;
	(*x) = (*x)|a;
	
	(*x) = (*x)&v;
}
// Flip the nth bit of the value of x.
// Assume 0 <= n <= 31
void flip_bit(unsigned * x,
              unsigned n) {
    // YOUR CODE HERE
    if(get_bit(*x, n))
        set_bit(x, n, 0);
    else
        set_bit(x, n, 1);
}

