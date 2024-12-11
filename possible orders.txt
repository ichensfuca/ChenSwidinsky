
// possible orders for the deviation group
list_divisors:={};
n:=20;

bb:=(6*16^(n-1))^2;
list_divisors:={d : d in Divisors(bb) | d le 255};

assert list_divisors eq { 1, 2, 3, 4, 6, 8, 9, 12, 16, 18, 24, 32, 36, 48, 64, 72, 96, 128, 144, 192 };
