Shader "Basics/Move"
{
    Properties
    {
        _BorderSize("Border Size", Float) = 0.1
        _GridSize("Grid Size", Float) = 10
        _CircleRadius("Circle Radius", Float) = 0.2
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
            fixed _CircleRadius;

            fixed InCircle(float2 uv){
                fixed2 center = fixed2(0.5, 0.5);

                fixed dist = distance(uv, center);

                return 1 - step(_CircleRadius, dist);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //On fait simplement osciller les UVs
                float2 uvTimed = i.uv + (_SinTime.z + 1) * 0.5;

                float2 uv = frac(uvTimed * _GridSize);

                fixed2 sizeVec = fixed2(_BorderSize, _BorderSize);

                //bottom left
                fixed2 bottomLeft = step(sizeVec, uv);
                fixed inSquare = bottomLeft.x * bottomLeft.y;

                //top right
                fixed2 topRight = step(sizeVec, 1 - uv);
                inSquare *= topRight.x * topRight.y;

                fixed4 col = fixed4(inSquare, inSquare, inSquare, 1.0);

                //On ajoute un cercle
                col = saturate(col + InCircle(i.uv));

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
