
RWByteAddressBuffer output : register(u0);
[numthreads(1, 1, 1)]
void foo() {
  int i = int(0);
  {
    while(true) {
      int x = asint(output.Load((0u + (min(uint(i), 9u) * 4u))));
      {
        int x_1 = asint(output.Load((0u + (min(uint(x), 9u) * 4u))));
        i = (i + x_1);
        if ((i > int(10))) { break; }
      }
      continue;
    }
  }
  output.Store(0u, asuint(i));
}

