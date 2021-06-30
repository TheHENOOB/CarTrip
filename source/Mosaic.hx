package;

import flixel.system.FlxAssets.FlxShader;

// The GLSL Mosaic Shader (AKA The Pixel Transition) was made by the HaxeFlixel Core Team specifically for https://haxeflixel.com/demos/MosaicEffect/
class MosaicShader extends FlxShader
{
	@:glFragmentSource('    	
	    #pragma header
		uniform vec2 uBlocksize;

		void main()
		{
			vec2 blocks = openfl_TextureSize / uBlocksize;
			gl_FragColor = flixel_texture2D(bitmap, floor(openfl_TextureCoordv * blocks) / blocks);
        }')
	public function new()
	{
		super();
	}
}

class MosaicEffect
{
	public static inline var DEFAULT_STRENGTH:Float = 1;

	public var shader(default, null):MosaicShader;
	public var strengthX(default, null):Float = DEFAULT_STRENGTH;
	public var strengthY(default, null):Float = DEFAULT_STRENGTH;

	public function new()
	{
		shader = new MosaicShader();
		shader.data.uBlocksize.value = [strengthX, strengthY];
	}

	public function setStrength(strengthX:Float, strengthY:Float)
	{
		this.strengthX = strengthX;
		this.strengthY = strengthY;

		shader.uBlocksize.value[0] = strengthX;
		shader.uBlocksize.value[1] = strengthY;
	}
}
