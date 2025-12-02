Shader "Patterns/RandomGlitch"
{
    Properties
    {
        _Threshold("Threshold", Float) = 0.85
        _Size("Size", Float) = 10
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

            fixed _Threshold;
            fixed _Size;

            //Une fonction aléatoire qui se résume en fait à une fonction tellement incompréhensible qu'on pourrait croire à de l'aléatoire
            //Avantage : rapide à calculer
            //Désavantage (qui est un avantage si on s'en sert bien !) : c'est déterministe -> même résultat à chaque fois pour les mêmes valeurs d'entrée
            float random(float2 uv){
                return frac(sin(dot(uv, fixed2(14.9752, 78.233))) * 51729.513527);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //On transforme nos UV en une grille pixelisée
                float2 uv = floor(i.uv * _Size) / _Size;

                //On décale les UV par rappot au temps
                uv += frac(_Time.y);

                //On lit la valeur random, on s'en sert pour savoir si le pixel est noir ou blanc suivant un seuil
                float rand = step(_Threshold, random(uv));

                fixed4 col = fixed4(rand, rand, rand, 1.0);

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
