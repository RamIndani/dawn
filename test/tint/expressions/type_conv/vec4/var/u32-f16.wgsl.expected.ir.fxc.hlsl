SKIP: INVALID


static uint4 u = (1u).xxxx;
void f() {
  vector<float16_t, 4> v = vector<float16_t, 4>(u);
}

[numthreads(1, 1, 1)]
void unused_entry_point() {
}

FXC validation failure:
C:\src\dawn\Shader@0x000002B7C2411820(4,10-18): error X3000: syntax error: unexpected token 'float16_t'

