texture tex0;

sampler2D DiffuseTexture = 
sampler_state 
{
    texture = <tex0>;
    AddressU  = CLAMP;        
    AddressV  = CLAMP;
    AddressW  = CLAMP;
    MIPFILTER = LINEAR;
    MINFILTER = LINEAR;
    MAGFILTER = LINEAR;
};

float4x4	ViewMatrix;
float4x4	ProjectionMatrix;
float4x4	WorldMatrix;
float3		_vCamPosition;
float3		_vCamRightDir;

float4		_vSizes;
float4		_vTtlGRotDrag;
float4		_IColor;
float4		_FColor;

struct VS_INPUT_FULLSTREAM
{
    float2  vPosition : POSITION;
	float2	vUV		  : TEXCOORD0;
	float3	vStartPos : TEXCOORD1;
	float3  vVelocity : TEXCOORD2;
	float3  vFriction : TEXCOORD3;
	float3	vMinSpeed : TEXCOORD4;
	float   vRotation : TEXCOORD5;
	float   vTtl	  : TEXCOORD6;
};


struct VS_OUTPUT_FULLSTREAM
{
	float4  vPosition : POSITION;
	float2	vUV		  : TEXCOORD0;
	float   vTtl	  : TEXCOORD1;
};

VS_OUTPUT_FULLSTREAM Particle_VS( const VS_INPUT_FULLSTREAM In )
{
	// Current particle time
	float vTime = _vTtlGRotDrag.x - In.vTtl;
	
	// Size is defined by a gradient between the StartSize [_vSizes.x] to MiddleSize [_vSizes.y] to FinalSize [_vSizes.z]
	// The middle size is only used when there is a defined middle time [_vSizes.y]
	float vSize = 0;
	if( _vSizes.w > 0 )
	{
		if( vTime > _vSizes.w )
			vSize = (_vSizes.y + (vTime - _vSizes.w)*( _vSizes.z - _vSizes.y )/(_vTtlGRotDrag.x - _vSizes.w)); // * ( 1 + In.vDragNum * _DragSize );
		else
			vSize = (_vSizes.x + vTime*( _vSizes.y - _vSizes.x )/ _vSizes.w); // * ( 1 + In.vDragNum * _DragSize );
	}
	else
		vSize = (_vSizes.x + vTime*( _vSizes.z - _vSizes.x )/ _vTtlGRotDrag.x); // * ( 1 + In.vDragNum * _DragSize );
	
	// Acceleration is determined by friction and gravity [_vTtlGRotDrag.y]. Will be negative to counter movement and Y-Up direction.
	float3 vAcceleration = - In.vFriction - float3( 0.0f, _vTtlGRotDrag.y, 0.0f);
	// Positioning of the center of the particle
	float3 vCenter;
	float SplitTime = (-(In.vMinSpeed - In.vVelocity) / In.vFriction).x;
	if( SplitTime > 0 && SplitTime < vTime )
	{
		vCenter = In.vStartPos + In.vVelocity * SplitTime + vAcceleration * SplitTime * SplitTime * 0.5f ;
		float RemainingTime = vTime - SplitTime;
		vCenter = vCenter + In.vMinSpeed * RemainingTime - float3(0.0f, _vTtlGRotDrag.y, 0.0f) * RemainingTime * RemainingTime * 0.5f;
	}
	else
	{
		vCenter = In.vStartPos + (In.vVelocity * vTime) + (vAcceleration * vTime * vTime * 0.5f);
	}
	
	VS_OUTPUT_FULLSTREAM Out;
	
	// ROTATION: Particle Rotation is increased in time, in In.vRotation radians per second
	float vRotation = vTime * In.vRotation;
	// Rotation matrix for 2D rotation
	float2x2 vRotationMatrix = { cos( vRotation ), -sin( vRotation ), sin( vRotation ), cos( vRotation ) };
	// The vertex's position in relation to the center, rotated
	float2 vVertexPos = mul( In.vPosition, vRotationMatrix );

	
	// Billboarding
	float3 vLookAt = normalize( vCenter - _vCamPosition );
	float3 vUp = normalize( cross( vLookAt, _vCamRightDir ) );
	float3 vRight = normalize( cross( vUp, vLookAt ) );
	
	float4x4 ViewProj = mul(ViewMatrix, ProjectionMatrix);
//	float4x4 FullWorldMatrix = WorldMatrix;
//	FullWorldMatrix[3].xyz += vCenter;
	
	float3 vFinalPos = vCenter + vVertexPos.x * vRight * vSize + vVertexPos.y * vUp * vSize;
	Out.vPosition = mul(float4( vFinalPos, 1.0f ), WorldMatrix);
	Out.vPosition = mul(Out.vPosition, ViewProj);
	
//	float3 vFinalPos = vVertexPos.x * vRight * vSize + vVertexPos.y * vUp * vSize;
//	Out.vPosition = mul( float4( vFinalPos , 1.0f ) , WorldMatrix );
//	Out.vPosition = mul( Out.vPosition, ViewProj );
	
	Out.vUV = In.vUV;
	Out.vTtl = In.vTtl;
	
	return Out;
}

float4 Particle_PS( const VS_OUTPUT_FULLSTREAM In ) : COLOR
{
	float4 Color = tex2D( DiffuseTexture, In.vUV );
	
	float4 vColorFade = (_FColor - _IColor) /  _vTtlGRotDrag.x;
	float vTime = _vTtlGRotDrag.x - In.vTtl;
	
	vColorFade = _IColor + (vColorFade * vTime);
	
	float4 ReturnColor = Color * vColorFade;
	
	return ReturnColor;
}

technique blast
{
	pass p0
	{
		STENCILENABLE = False;
		ZENABLE = True;
		ZWRITEENABLE = False;
		
		ALPHATESTENABLE = False;
		SEPARATEALPHABLENDENABLE = False;
		ALPHABLENDENABLE = True;
		
		BLENDOP = Add;
        SRCBLEND = One;
		DESTBLEND = InvSrcAlpha;
	
		VertexShader = compile vs_3_0 Particle_VS();
		PixelShader = compile ps_3_0 Particle_PS();
	}
}

technique flame
{
	pass p0
	{
		STENCILENABLE = False;
		ZENABLE = True;
		ZWRITEENABLE = False;
		
		ALPHATESTENABLE = False;
		SEPARATEALPHABLENDENABLE = False;
		ALPHABLENDENABLE = True;
		
		BLENDOP = Add;
        SRCBLEND = One;
		DESTBLEND = One;
	
		VertexShader = compile vs_3_0 Particle_VS();
		PixelShader = compile ps_3_0 Particle_PS();
	}
}

technique colorblend
{
	pass p0
	{
		STENCILENABLE = False;
		ZENABLE = True;
		ZWRITEENABLE = False;
		
		ALPHATESTENABLE = False;
		SEPARATEALPHABLENDENABLE = False;
		ALPHABLENDENABLE = True;
		
		BLENDOP = Add;
        SRCBLEND = Zero;
		DESTBLEND = SrcColor;
	
		VertexShader = compile vs_3_0 Particle_VS();
		PixelShader = compile ps_3_0 Particle_PS();
	}
}

technique smoke
{
	pass p0
	{
		STENCILENABLE = False;
		ZENABLE = True;
		ZWRITEENABLE = False;
		
		ALPHATESTENABLE = False;
		SEPARATEALPHABLENDENABLE = False;
		ALPHABLENDENABLE = True;
		
		BLENDOP = Add;
        SRCBLEND = SrcAlpha;
		DESTBLEND = InvSrcAlpha;
	
		VertexShader = compile vs_3_0 Particle_VS();
		PixelShader = compile ps_3_0 Particle_PS();
	}
}



