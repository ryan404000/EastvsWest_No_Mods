#ifndef STANDARDFUNCS_H__
#define STANDARDFUNCS_H__

float4x4 ViewProjectionMatrix	: register( c0 );
float4x4 ViewMatrix				: register( c4 );
float4x4 InvViewMatrix			: register( c8 );
float4x4 InvViewProjMatrix		: register( c12 );
float3 vLightDir				: register( c16 );
float3 vDiffuseLight = float3( 1.0f, 1.0f, 1.0f );//: register( c17 );
float3 vCamPos					: register( c18 );
float3 vCamRightDir				: register( c19 );
float3 vCamLookAtDir			: register( c20 );
float3 vCamUpDir				: register( c21 );
float2 vFoWOpacity_Time			: register( c22 );

float  vIntensity    = 1.2f; //: register( c21 );

// CONSTANTS
uniform float HDR_RANGE = 0.8f;


// Photoshop filters, kinda...
float3 Hue( float H )
{
	float X = 1 - abs( ( H % 2  ) - 1 );
	if ( H < 1.0f )			return float3( 1.0f,    X, 0.0f );
	else if ( H < 2.0f )	return float3(    X, 1.0f, 0.0f );
	else if ( H < 3.0f )	return float3( 0.0f, 1.0f,    X );
	else if ( H < 4.0f )	return float3( 0.0f,    X, 1.0f );
	else if ( H < 5.0f )	return float3(    X, 0.0f, 1.0f );
	else					return float3( 1.0f, 0.0f,    X );
}

float3 HSVtoRGB( in float3 HSV )
{
	if ( HSV.y != 0.0f )
	{
		float C = HSV.y * HSV.z;
		return saturate( Hue( HSV.x ) * C + ( HSV.z - C ) );
	}
	return saturate( HSV.zzz );
}

float3 RGBtoHSV( in float3 RGB )
{
    float3 HSV = 0;
    HSV.z = max( RGB.r, max( RGB.g, RGB.b ) );
    float M = min( RGB.r, min( RGB.g, RGB.b ) );
    float C = HSV.z - M;
    
	if ( C != 0.0f )
    {
        HSV.y = C / HSV.z;

		float3 vDiff = ( RGB.gbr - RGB.brg ) / C;
		// vDiff.x %= 6.0f; // We make this operation after tweaking the value
		vDiff.yz += float2( 2.0f, 4.0f );

        if ( RGB.r == HSV.z )		HSV.x = vDiff.x;
        else if ( RGB.g == HSV.z )	HSV.x = vDiff.y;
        else						HSV.x = vDiff.z;
    }
    return HSV;
}




float3 GetOverlay( float3 vColor, float3 vOverlay, float vOverlayPercent )
{
	float3 res;
	res.r = vOverlay.r < .5 ? (2 * vOverlay.r * vColor.r) : (1 - 2 * (1 - vOverlay.r) * (1 - vColor.r));
	res.g = vOverlay.g < .5 ? (2 * vOverlay.g * vColor.g) : (1 - 2 * (1 - vOverlay.g) * (1 - vColor.g));
	res.b = vOverlay.b < .5 ? (2 * vOverlay.b * vColor.b) : (1 - 2 * (1 - vOverlay.b) * (1 - vColor.b));

	return lerp( vColor, res, vOverlayPercent );
}

float3 Levels( float3 vInColor, float vMinInput, float vMaxInput )
{
	float3 vRet = saturate( vInColor - vMinInput );
	vRet /= vMaxInput - vMinInput;
	return saturate( vRet );
}


// Standard functions
float3 CalculateLighting( float3 vColor, float3 vNormal, float3 vLightDirection )
{
	float NdotL = dot( vNormal, -vLightDirection );

	float vAmbient = 0.2f;

	float vHalfLambert = NdotL * 0.5f + 0.5f;
	vHalfLambert *= vHalfLambert;

	vHalfLambert = vAmbient + ( 1.0f - vAmbient ) * vHalfLambert;

	return  saturate( vHalfLambert * vColor * vDiffuseLight * vIntensity );
}

float3 CalculateLighting( float3 vColor, float3 vNormal )
{
	return CalculateLighting( vColor, vNormal, vLightDir );
}

float CalculateSpecular( float3 vPos, float3 vNormal, float vIntensity )
{
	float3 H = normalize( -normalize( vPos - vCamPos ) + -vLightDir );
	float vSpecWidth = 200.0f;
	float vSpecMultiplier = 3.0f;
	return saturate( pow( saturate( dot( H, vNormal ) ), vSpecWidth ) * vSpecMultiplier ) * vIntensity;
}

float3 ComposeSpecular( float3 vColor, float vSpecular ) 
{
	return saturate( vColor + vSpecular ) * HDR_RANGE + ( 1.0f - HDR_RANGE ) * vSpecular;
}

float3 ApplyDistanceFog( float3 vColor, float3 vPos )
{
	float3 vDiff = vCamPos - vPos;
	float vFogFactor = 1.0f - normalize( vDiff ).y;
	float vSqDistance = dot( vDiff, vDiff );

	float vBegin = 400.0f;
	float vEnd = 1200.0f;
	vBegin *= vBegin;
	vEnd *= vEnd;

	return lerp( vColor, float3( 0.5f, 0.5f, 0.5f ), saturate( min( ( vSqDistance - vBegin ) / ( vEnd - vBegin ), 0.5f ) ) * vFogFactor );
}

float GetFoW( float3 vPos, in sampler2D FoWTexture, in sampler2D FoWDiffuse )
{
	float vFoWDiffuse = tex2D( FoWDiffuse, ( vPos.xz + 0.5f ) / 256.0f + vFoWOpacity_Time.y * 0.02f ).r;
	vFoWDiffuse = sin( ( vFoWDiffuse + frac( vFoWOpacity_Time.y * 0.1f ) ) * 6.28318531f ) * 0.1f;
	float vShade = vFoWDiffuse + 0.5f;
	float vIsFow = 1 - tex2D( FoWTexture, ( vPos.xz + 0.5f ) / 2048.0f ).a;
	return lerp( 1.0f, saturate( vIsFow + vShade ), vFoWOpacity_Time.x );
}

float3 ApplyDistanceFog( float3 vColor, float3 vPos, in sampler2D FoWTexture, in sampler2D FoWDiffuse )
{
	return ApplyDistanceFog( vColor, vPos ) * GetFoW( vPos, FoWTexture, FoWDiffuse );
}

#endif // STANDARDFUNCS_H__
