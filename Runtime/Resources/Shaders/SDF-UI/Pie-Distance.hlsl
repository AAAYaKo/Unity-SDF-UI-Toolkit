/**
* SDF fragment to determin distance from shape (Pie.shader)
*/

//////////////////////////////////////////////////////////////

#ifdef SDF_UI_STEP_SETUP

#ifdef SDF_UI_AA_SUBPIXEL
float4 dist;
float r, g, b;
#else
float dist;
#endif

float2x2 j;

#endif  // SDF_UI_STEP_SETUP

//////////////////////////////////////////////////////////////

#if defined(SDF_UI_STEP_SHAPE_OUTLINE) || defined(SDF_UI_STEP_SHADOW)

#ifdef SDF_UI_AA_SUPER_SAMPLING
if (_Theta >= 3.14) {
    j = JACOBIAN(p);
    dist = 0.25 * (
        length(p + mul(j, float2(1, 1) * 0.25)) - _Radius +
        length(p + mul(j, float2(1, -1) * 0.25)) - _Radius +
        length(p + mul(j, float2(-1, 1) * 0.25)) - _Radius +
        length(p + mul(j, float2(-1, -1) * 0.25)) - _Radius);
}
else {
    j = JACOBIAN(p);
    dist = 0.25 * (
        sdPie(p + mul(j, float2(1, 1) * 0.25), float2(sin(_Theta), cos(_Theta)), _Radius) +
        sdPie(p + mul(j, float2(1, -1) * 0.25), float2(sin(_Theta), cos(_Theta)), _Radius) +
        sdPie(p + mul(j, float2(-1, 1) * 0.25), float2(sin(_Theta), cos(_Theta)), _Radius) +
        sdPie(p + mul(j, float2(-1, -1) * 0.25), float2(sin(_Theta), cos(_Theta)), _Radius));
}
#elif SDF_UI_AA_SUBPIXEL
if (_Theta >= 3.14) {
    j = JACOBIAN(p);
    r = length(p + mul(j, float2(-0.333, 0))) - _Radius;
    g = length(p) - _Radius;
    b = length(p + mul(j, float2(0.333, 0))) - _Radius;
    dist = half4(r, g, b, (r + g + b) / 3.);
}
else {
    j = JACOBIAN(p);
    r = sdPie(p + mul(j, float2(-0.333, 0)), float2(sin(_Theta), cos(_Theta)), _Radius);
    g = sdPie(p, float2(sin(_Theta), cos(_Theta)), _Radius);
    b = sdPie(p + mul(j, float2(0.333, 0)), float2(sin(_Theta), cos(_Theta)), _Radius);
    dist = half4(r, g, b, (r + g + b) / 3.);
}
#else
if (_Theta >= 3.14) {
    dist = length(p) - _Radius;
}
else {
    dist = sdPie(p, float2(sin(_Theta), cos(_Theta)), _Radius);
}
#endif

#ifdef SDF_UI_ONION
dist = abs(dist) - _OnionWidth;
#endif

#endif

//////////////////////////////////////////////////////////////