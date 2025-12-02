Shader "Basics/DistanceField"
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
                //On divise en 4 (une grille simplifiée)
                float2 remappedUVs = (i.uv * 2) - 1;

                //On calcule la distance au centre
                fixed dist = distance(abs(remappedUVs), _Center);

                //On fractionne la distance en une multitude de cercles concentriques
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
