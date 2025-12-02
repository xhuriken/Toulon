Shader "Basics/DistanceFieldBis"
{
    Properties
    {
        _Center("Center", Vector) = (0.5, 0.5, 0, 0)
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

            fixed2 _Center;

            fixed4 frag (v2f i) : SV_Target
            {
                //On divise en 4
                float2 remappedUVs = (i.uv * 2) - 1;

                //Une croix - on calcule comme distance la distance au centre pour tout ce qui est inférieur au centre
                fixed dist = distance(min(abs(remappedUVs), _Center), _Center);
                
                //Un carré - l'inverse de la croix, on calcule la distance de seulement ce qui est supérieur au centre
                //fixed dist = distance(max(abs(remappedUVs), _Center), _Center);

                //On créé des formes concentriques
                dist = frac(dist*10);

                fixed4 col = fixed4(dist, dist, dist, 1.0);
                
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
