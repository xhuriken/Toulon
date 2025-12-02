Shader "Patterns/ZigZags"
{
    Properties
    {
        _RibbonWidth("Ribbon Width", Float) = 0.1
		_HeightCurveFrequency("Height curve frequency", Float) = 5
		_HeightCurveAmplitude("Height curve amplitude", Float) = 0.1
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

            fixed _RibbonWidth;
		    fixed _HeightCurveFrequency;
		    fixed _HeightCurveAmplitude;

            fixed4 frag (v2f i) : SV_Target
            {
                //pour se simplifier la vie
                float2 uv = i.uv;

                //On détermine une courbe, c'est assez simple avec un sinus ! On le fait par rapport au Y de nos uv
			    float curvature = sin(uv.y * _HeightCurveFrequency);
                //On détermine où on se trouve, en X, sur la courbe actuelle -> 0 = proche, 1 = loin
                float ribbonPos = frac((uv.x + curvature * _HeightCurveAmplitude) / _RibbonWidth);
                //On dessine, plus c'est noir plus on est proche de la courbe actuelle
                float4 col = float4(ribbonPos, ribbonPos, ribbonPos, 1);

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
