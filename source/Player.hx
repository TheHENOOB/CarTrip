package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxAxes;

using flixel.util.FlxSpriteUtil;

class Player extends FlxSprite
{
	public var SPEED:Int = 200;

	public function new()
	{
		super(10, 0, AssetPaths.Car__png);
		screenCenter(FlxAxes.Y);

		setGraphicSize(32);
		setSize(32, 25);
		centerOffsets();
	}

	override public function update(elapsed:Float)
	{
		controls();
		this.bound();
		super.update(elapsed);
	}

	function controls()
	{
		var up:Bool = FlxG.keys.pressed.UP;
		var down:Bool = FlxG.keys.pressed.DOWN;

		velocity.y = 0;
		if (up)
		{
			velocity.y = -SPEED;
		}
		if (down)
		{
			velocity.y = SPEED;
		}
	}
}
