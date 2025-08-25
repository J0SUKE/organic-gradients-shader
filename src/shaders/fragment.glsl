varying vec2 vUv;
uniform vec2 uViewportRes;
uniform float uTime;
uniform float uRedFactor;
uniform float uGreenFactor;
uniform float uBlueFactor;

// #include "./pnoise.glsl";
#include "./snoise.glsl";

vec2 coverUvs(vec2 imageRes,vec2 containerRes,vec2 vUv)
{
    float imageAspectX = imageRes.x/imageRes.y;
    float imageAspectY = imageRes.y/imageRes.x;
    
    float containerAspectX = containerRes.x/containerRes.y;
    float containerAspectY = containerRes.y/containerRes.x;

    vec2 ratio = vec2(
        min(containerAspectX / imageAspectX, 1.0),
        min(containerAspectY / imageAspectY, 1.0)
    );

    vec2 newUvs = vec2(
        vUv.x * ratio.x + (1.0 - ratio.x) * 0.5,
        vUv.y * ratio.y + (1.0 - ratio.y) * 0.5
    );

    return newUvs;
}

void main()
{
    
    vec2 squareUvs = coverUvs(vec2(1.),uViewportRes,vUv);

    float mainNoise = snoise(vec3(squareUvs, uTime*0.15));


    float horizontalWaves = sin(mainNoise*10. + uTime);

    vec3 finalColor = vec3(
        0.5+horizontalWaves*uRedFactor + exp(squareUvs.x),
        0.7+horizontalWaves*uGreenFactor ,
        0.9+horizontalWaves*uBlueFactor - exp(squareUvs.y)
    );

    gl_FragColor = vec4(finalColor, 1.);
}