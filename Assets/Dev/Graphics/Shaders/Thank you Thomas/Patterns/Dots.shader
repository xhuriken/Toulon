Shader "Patterns/Dots"
{
    Properties
    {
        _GridSize("Grid Size", Float) = 5
        _DotRadius("Dot Radius", Float) = 0.4
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
            fixed _DotRadius;

            float2 MovingGridify(float2 uv, float2 size){

                float2 uvOut = uv * size;

                fixed movement = frac(_Time.y);

                fixed isOdd = step(1, uvOut.y % 2);

                isOdd -= 0.5;

                isOdd *= 2;

                uvOut.x += movement * isOdd; //On décale une ligne sur deux

                return frac(uvOut);
            }

            float Dotify(float2 uv, float radius){
                return step(radius, distance(fixed2(0.5, 0.5), uv));
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //on créé la grille qui bouge
                float2 uv = MovingGridify(i.uv, _GridSize);

                //Et on dessine un cercle, aussi simple que ça !
                float inCircle = Dotify(uv, _DotRadius);

                fixed4 col = fixed4(inCircle, inCircle, inCircle, 1.0);

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
