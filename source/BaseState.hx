package;

import flixel.FlxG;
import flixel.FlxState;

class BaseState extends FlxState
{
	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.F)
			FlxG.fullscreen = !FlxG.fullscreen;

		super.update(elapsed);
	}
}
