Shader "Patterns/Bricks"
{
    Properties
    {
        _GridSize("Grid Size", Float) = 5
        _BoxSize("Box Size", Float) = 0.9
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed _GridSize;
            fixed _BoxSize;

            float2 Brickify(float2 uv, float2 size){

                float2 uvOut = uv * size;

                uvOut.x += step(1, uvOut.y % 2) * 0.5; //On décale une ligne sur deux

                return frac(uvOut);
            }

            float DrawBox(float2 uv, float2 size){

                //bottom left
                fixed2 bottomLeft = step(size, uv);
                fixed inSquare = bottomLeft.x * bottomLeft.y;

                //top right
                fixed2 topRight = step(size, 1 - uv);
                inSquare *= topRight.x * topRight.y;

                return inSquare;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = i.uv / float2(2.15, 0.65) / 1.5; //taille réelle de brique

                //On "briquifie" les uv. En gros, on créé une grille MAIS à la forme d'une brique
                uv = Brickify(uv, _GridSize);

                //Et on dessine un carré, comme on l'a déjà fait avant
                float inBox = DrawBox(uv, fixed2(_BoxSize * 0.5, _BoxSize));

                fixed4 col = fixed4(inBox, inBox, inBox, 1.0);
                
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
