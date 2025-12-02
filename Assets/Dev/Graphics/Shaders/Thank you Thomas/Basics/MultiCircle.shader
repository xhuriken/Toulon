Shader "Basics/MultiCircle"
{
    Properties
    {
        _Radius("Radius", Float) = 0.5
        _MaxRadius("Max Radius", Float) = 0.7
        _Gradients("Gradients", Int) = 10
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

            fixed _Radius;
            fixed _MaxRadius;
            int _Gradients;

            fixed linearstep(fixed a, fixed b, fixed x){
                return saturate((x - a) / (b - a));
            }

            //Celui-ci est assez simple
            fixed4 frag (v2f i) : SV_Target
            {
                fixed2 center = fixed2(0.5, 0.5);

                //Calcule de distance
                fixed dist = distance(i.uv, center);

                //On remap cette distance entre nos bornes
                fixed remappedDistance = 1 - linearstep(_Radius, _MaxRadius, dist);

                //On mutliplie par le nombre de dégradés qu'on veut
                remappedDistance *= _Gradients;

                //On prends la valeur entière uniquement (arrondi inférieur)
                remappedDistance = floor(remappedDistance);

                //On divise par le nombre de dégradés pour revenir en espace 0-1
                remappedDistance /= _Gradients;

                fixed4 col = fixed4(remappedDistance, remappedDistance, remappedDistance, 1.0);
                
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }

            ENDCG
        }
    }
}
