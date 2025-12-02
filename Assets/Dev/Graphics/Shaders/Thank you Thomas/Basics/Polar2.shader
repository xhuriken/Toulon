Shader "Basics/Polar2"
{
    Properties
    {
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

            fixed4 frag (v2f i) : SV_Target
            {
                fixed2 center = fixed2(0.5, 0.5);

                //Des maths encore
                fixed2 pos = fixed2(0.5, 0.5) - i.uv;
                fixed r = length(pos)*2.0;
                fixed a = atan2(pos.y, pos.x);

                //On joue avec les coordonnées, le smoothstep va créer un seuil et le cosinus va influencer sur les "dents"
                fixed f = smoothstep(-0.5, 1, cos(a * 10)) * 0.2 + 0.5;

                //On pourrait utiliser un step, mais le smoothstep va créer une séparation blanc noir plus lisse
                //Jouez avec le +0.02 pour voir ce lissage évoluer
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
