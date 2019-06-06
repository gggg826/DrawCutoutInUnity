Shader "Custom/NotchDisplay"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		//_W_Bound1("Point1",vector) = (85,100,0,0) 
        //_W_Bound2("Point2",vector) = (85,200,0,0) 
		//_H_Bound1("Bound1",vector) = (0,15,0,0) 
        //_H_Bound2("Bound2",vector) = (0,285,0,0) 
       
	}

	SubShader
	{
		Pass 
        { 
            CGPROGRAM 
            #pragma vertex vert 
            #pragma fragment frag 
              
            #include "UnityCG.cginc" 
   
            struct appdata 
            { 
                float4 vertex : POSITION; 
				float2 uv : TEXCOORD0;
            }; 
   
            struct v2f 
            { 
				float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION; 
            }; 

			sampler2D _MainTex;
            float3 _W_Bound1; 
            float3 _W_Bound2; 
			float3 _H_Bound1;   
			float3 _H_Bound2;   
               

			float3 InNotch(float3 a, float3 b, float3 s)
			{
				return cross(normalize(a - s), normalize(b - s));
			}

            v2f vert (appdata v) 
            { 
                v2f o; 
                o.vertex = UnityObjectToClipPos(v.vertex); 
				o.uv = v.uv;
                return o; 
            } 
               
            fixed4 frag (v2f i) : SV_Target 
            { 
				//下三角区
				if((InNotch(i.vertex, _W_Bound1, _H_Bound1).z < 0) && i.vertex.y > _H_Bound1.y && i.vertex.y < _W_Bound1.y)
				{
					return fixed4(0,0,0,1); 
				}
				
				//上三角区
				if((InNotch(i.vertex, _H_Bound2, _W_Bound2).z < 0) && i.vertex.y > _W_Bound2.y && i.vertex.y < _H_Bound2.y)
				{
					return fixed4(0,0,0,1); 
				}

				//矩形区
				if(i.vertex.x < _W_Bound1.x && i.vertex.y > _W_Bound1.y && i.vertex.y < _W_Bound2.y)
				{
					return fixed4(0,0,0,1); 
				}


                ////绘制点
                //if(pow((i.vertex.x- _W_Bound1.x ),2) + pow((i.vertex.y- _W_Bound1.y ),2) <100 ) 
                //{ 
                //    return fixed4(0,0,1,1); 
                //}  
				//if(pow((i.vertex.x- _Bound1.x ),2) + pow((i.vertex.y- _Bound1.y ),2) <100 ) 
                //{ 
                //    return fixed4(0,0,1,1); 
                //}
				
                ////画线 
                //float d = abs((_W_Bound1.y-_Bound1.y)*i.vertex.x + (_Bound1.x - _W_Bound1.x)*i.vertex.y +_W_Bound1.x*_Bound1.y -_W_Bound1.y*_Bound1.x )/sqrt(pow(_W_Bound1.y-_Bound1.y,2) + pow(_Bound1.x-_W_Bound1.x,2)); 
                //if(d<= 10) 
                //{ 
                //    return fixed4(0.8,0.2,0.5,1); 
                //} 
				 
                return tex2D(_MainTex, i.uv); 
   
            } 

            ENDCG 
        } 
	}
}
