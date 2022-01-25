#version 310 es
precision mediump float;

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void unused_entry_point() {
  return;
}
void main() {
  unused_entry_point();
}



struct S {
  uvec3 v;
};

layout(binding = 0) uniform S_1 {
  uvec3 v;
} U;

void f() {
  uvec3 v = U.v;
  uint x = U.v.x;
  uint y = U.v.y;
  uint z = U.v.z;
  uvec2 xx = U.v.xx;
  uvec2 xy = U.v.xy;
  uvec2 xz = U.v.xz;
  uvec2 yx = U.v.yx;
  uvec2 yy = U.v.yy;
  uvec2 yz = U.v.yz;
  uvec2 zx = U.v.zx;
  uvec2 zy = U.v.zy;
  uvec2 zz = U.v.zz;
  uvec3 xxx = U.v.xxx;
  uvec3 xxy = U.v.xxy;
  uvec3 xxz = U.v.xxz;
  uvec3 xyx = U.v.xyx;
  uvec3 xyy = U.v.xyy;
  uvec3 xyz = U.v.xyz;
  uvec3 xzx = U.v.xzx;
  uvec3 xzy = U.v.xzy;
  uvec3 xzz = U.v.xzz;
  uvec3 yxx = U.v.yxx;
  uvec3 yxy = U.v.yxy;
  uvec3 yxz = U.v.yxz;
  uvec3 yyx = U.v.yyx;
  uvec3 yyy = U.v.yyy;
  uvec3 yyz = U.v.yyz;
  uvec3 yzx = U.v.yzx;
  uvec3 yzy = U.v.yzy;
  uvec3 yzz = U.v.yzz;
  uvec3 zxx = U.v.zxx;
  uvec3 zxy = U.v.zxy;
  uvec3 zxz = U.v.zxz;
  uvec3 zyx = U.v.zyx;
  uvec3 zyy = U.v.zyy;
  uvec3 zyz = U.v.zyz;
  uvec3 zzx = U.v.zzx;
  uvec3 zzy = U.v.zzy;
  uvec3 zzz = U.v.zzz;
  uvec4 xxxx = U.v.xxxx;
  uvec4 xxxy = U.v.xxxy;
  uvec4 xxxz = U.v.xxxz;
  uvec4 xxyx = U.v.xxyx;
  uvec4 xxyy = U.v.xxyy;
  uvec4 xxyz = U.v.xxyz;
  uvec4 xxzx = U.v.xxzx;
  uvec4 xxzy = U.v.xxzy;
  uvec4 xxzz = U.v.xxzz;
  uvec4 xyxx = U.v.xyxx;
  uvec4 xyxy = U.v.xyxy;
  uvec4 xyxz = U.v.xyxz;
  uvec4 xyyx = U.v.xyyx;
  uvec4 xyyy = U.v.xyyy;
  uvec4 xyyz = U.v.xyyz;
  uvec4 xyzx = U.v.xyzx;
  uvec4 xyzy = U.v.xyzy;
  uvec4 xyzz = U.v.xyzz;
  uvec4 xzxx = U.v.xzxx;
  uvec4 xzxy = U.v.xzxy;
  uvec4 xzxz = U.v.xzxz;
  uvec4 xzyx = U.v.xzyx;
  uvec4 xzyy = U.v.xzyy;
  uvec4 xzyz = U.v.xzyz;
  uvec4 xzzx = U.v.xzzx;
  uvec4 xzzy = U.v.xzzy;
  uvec4 xzzz = U.v.xzzz;
  uvec4 yxxx = U.v.yxxx;
  uvec4 yxxy = U.v.yxxy;
  uvec4 yxxz = U.v.yxxz;
  uvec4 yxyx = U.v.yxyx;
  uvec4 yxyy = U.v.yxyy;
  uvec4 yxyz = U.v.yxyz;
  uvec4 yxzx = U.v.yxzx;
  uvec4 yxzy = U.v.yxzy;
  uvec4 yxzz = U.v.yxzz;
  uvec4 yyxx = U.v.yyxx;
  uvec4 yyxy = U.v.yyxy;
  uvec4 yyxz = U.v.yyxz;
  uvec4 yyyx = U.v.yyyx;
  uvec4 yyyy = U.v.yyyy;
  uvec4 yyyz = U.v.yyyz;
  uvec4 yyzx = U.v.yyzx;
  uvec4 yyzy = U.v.yyzy;
  uvec4 yyzz = U.v.yyzz;
  uvec4 yzxx = U.v.yzxx;
  uvec4 yzxy = U.v.yzxy;
  uvec4 yzxz = U.v.yzxz;
  uvec4 yzyx = U.v.yzyx;
  uvec4 yzyy = U.v.yzyy;
  uvec4 yzyz = U.v.yzyz;
  uvec4 yzzx = U.v.yzzx;
  uvec4 yzzy = U.v.yzzy;
  uvec4 yzzz = U.v.yzzz;
  uvec4 zxxx = U.v.zxxx;
  uvec4 zxxy = U.v.zxxy;
  uvec4 zxxz = U.v.zxxz;
  uvec4 zxyx = U.v.zxyx;
  uvec4 zxyy = U.v.zxyy;
  uvec4 zxyz = U.v.zxyz;
  uvec4 zxzx = U.v.zxzx;
  uvec4 zxzy = U.v.zxzy;
  uvec4 zxzz = U.v.zxzz;
  uvec4 zyxx = U.v.zyxx;
  uvec4 zyxy = U.v.zyxy;
  uvec4 zyxz = U.v.zyxz;
  uvec4 zyyx = U.v.zyyx;
  uvec4 zyyy = U.v.zyyy;
  uvec4 zyyz = U.v.zyyz;
  uvec4 zyzx = U.v.zyzx;
  uvec4 zyzy = U.v.zyzy;
  uvec4 zyzz = U.v.zyzz;
  uvec4 zzxx = U.v.zzxx;
  uvec4 zzxy = U.v.zzxy;
  uvec4 zzxz = U.v.zzxz;
  uvec4 zzyx = U.v.zzyx;
  uvec4 zzyy = U.v.zzyy;
  uvec4 zzyz = U.v.zzyz;
  uvec4 zzzx = U.v.zzzx;
  uvec4 zzzy = U.v.zzzy;
  uvec4 zzzz = U.v.zzzz;
}
