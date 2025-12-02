Shader "Basics/Polar"
{
    Properties
    {
        _Petals("Petals", Int) = 4
        _Radius("Radius", Float) = 1
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

            int _Petals;
            fixed _Radius;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed2 center = fixed2(0.5, 0.5);

                //Des maths, on récupère à partir des UV le rayon (distance au centre) et l'angle du point
                fixed2 pos = fixed2(0.5, 0.5) - i.uv;
                fixed r = length(pos)*2.0;
                fixed a = atan2(pos.y, pos.x);

                //On joue avec les cosinus et sinus de l'angle pour dessiner des pétales
                fixed f = abs(cos(a * _Petals * 0.25) * sin(a * _Petals * 0.25)) * _Radius;

                //On dessine plus ou moins grand suivant le rayon
                fixed inShape = 1 - smoothstep(f, f+0.02, r);

                fixed4 col = fixed4(inShape, inShape, inShape, 1.0);
                
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
