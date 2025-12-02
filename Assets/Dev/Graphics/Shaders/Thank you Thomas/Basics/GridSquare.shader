Shader "Basics/GridSquare"
{
    Properties
    {
        _BorderSize("Border Size", Float) = 0.1
        _GridSize("Grid Size", Float) = 10
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

            fixed _BorderSize;
            fixed _GridSize;

            fixed4 frag (v2f i) : SV_Target
            {
                //On créé une grille
                float2 uv = frac(i.uv * _GridSize);

                fixed2 sizeVec = fixed2(_BorderSize, _BorderSize);

                //bottom left
                fixed2 bottomLeft = step(sizeVec, uv); //On aura 1 dès qu'on s'éloigne assez du bord
                fixed inSquare = bottomLeft.x * bottomLeft.y; //On multiplie pour faire un "ET" logique

                //top right
                fixed2 topRight = step(sizeVec, 1 - uv); //On aura 1 dès qu'on s'éloigne assez du bord
                inSquare *= topRight.x * topRight.y; //On multiplie pour faire un "ET" logique

                fixed4 col = fixed4(inSquare, inSquare, inSquare, 1.0);

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
