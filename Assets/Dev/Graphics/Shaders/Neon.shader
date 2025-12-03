Shader "Custom/Neon"
{
    Properties
    {
        _InsideColor   ("Inside Color", Color)       = (1,1,1,1)
        _Width         ("Border Width", Range(0,0.5))= 0.1

        _ColorSpeed    ("Color Speed", Range(0,10))  = 1.0
        _NeonIntensity ("Neon Intensity", Range(1,10)) = 3.0

        _GridSize      ("Brick Grid Size", Float)    = 5
        _BoxSize       ("Brick Box Size",  Float)    = 0.9
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex   vert
            #pragma fragment frag
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            // Vertex
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv     : TEXCOORD0;
            };

            // Vertex to fragment
            struct v2f
            {
                float2 uv     : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            // shader properties
            float4 _InsideColor;
            float  _Width;
            float  _ColorSpeed;
            float  _NeonIntensity;

            float  _GridSize;
            float  _BoxSize;

            // Vertex shader
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv     = v.uv;
                UNITY_TRANSFER_FOG(o, o.vertex);
                return o;
            }

            // arc en ciel colooooor
            float3 Rainbow(float t)
            {
                float phase = frac(t) * 6.2831853; // 2π

                float3 col;
                col.r = 0.5 + 0.5 * sin(phase + 0.0);
                col.g = 0.5 + 0.5 * sin(phase + 2.0943951);
                col.b = 0.5 + 0.5 * sin(phase + 4.1887902);

                return col;
            }

            // Décale une ligne de briques sur deux
            float2 Brickify(float2 uv, float size)
            {
                float2 uvOut = uv * size;

                // Décalage horizontal une ligne sur deux
                float row = floor(uvOut.y);
                uvOut.x += fmod(row, 2.0) * 0.5;

                return frac(uvOut);
            }

            // Retourne 1 à l’intérieur du rectangle, 0 sur le “joint”
            float DrawBox(float2 uv, float2 size)
            {
                float2 bottomLeft = step(size, uv);
                float  inSquare   = bottomLeft.x * bottomLeft.y;

                float2 topRight   = step(size, 1.0 - uv);
                inSquare *= topRight.x * topRight.y;

                return inSquare;
            }

            // Fragment shader
            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = i.uv;

                // Eternal border
                float2 distToEdge = min(uv, 1.0 - uv);
                float  minDist    = min(distToEdge.x, distToEdge.y);
                float  insideMask = step(_Width, minDist); // 1 = inside, 0 = border

                // Neon color (border + joints)
                float  t = _Time.y * _ColorSpeed;
                float3 neonCol = Rainbow(t) * _NeonIntensity;

                // Bricks pattern
                // On travaille dans un espace UV brique
                float2 brickUV = uv / float2(2.15, 0.65) / 1.5;
                brickUV = Brickify(brickUV, _GridSize);

                // inBox = 1 inside brick, 0 in joint
                float inBox = DrawBox(brickUV, float2(_BoxSize * 0.5, _BoxSize));

                float3 insideCol  = _InsideColor.rgb;
                float3 brickColor = lerp(neonCol, insideCol, inBox); // joint = neon, brique = inside

                // MIX ! tembouille
                float3 finalColor = lerp(neonCol, brickColor, insideMask);

                // Fog
                UNITY_APPLY_FOG(i.fogCoord, finalColor);

                return float4(finalColor, 1.0);
            }

            ENDCG
        }
    }
}
