Shader "Basics/Rotate"
{
    Properties
    {
        _BorderSize("Border Size", Float) = 0.1
        _GridSize("Grid Size", Float) = 10
        _RotationSpeed("Rotation Speed", Float) = 5
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
            fixed _RotationSpeed;

            float2 Rotate(float2 input, float angle)
		    {
			    float c = cos(radians(angle));
			    float s = sin(radians(angle));
			    return float2(
				    input.x * c - input.y * s,
				    input.x * s + input.y * c);
		    }

            //l'astuce est simple, on tourne simplement les UV avant de faire nos calculs en dessous, comme si de rien était
            //Et paf ! Tout tourne !
            fixed4 frag (v2f i) : SV_Target
            {
                //On recentre les UV avant de les faire tourner (on détermine simplement le point qui sert de centre à la rotation)
                float2 rotatedUVs = Rotate(i.uv - fixed2(0.5, 0.5), _Time.w * _RotationSpeed % 360);

                //On recentre les UV
                rotatedUVs += fixed2(0.5, 0.5);

                //On créé la grille
                float2 uv = frac(rotatedUVs * _GridSize);

                fixed2 sizeVec = fixed2(_BorderSize, _BorderSize);

                //bottom left
                fixed2 bottomLeft = step(sizeVec, uv);
                fixed inSquare = bottomLeft.x * bottomLeft.y;

                //top right
                fixed2 topRight = step(sizeVec, 1 - uv);
                inSquare *= topRight.x * topRight.y;

                fixed4 col = fixed4(inSquare, inSquare, inSquare, 1.0);

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
