package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		addChild(new FlxGame(0, 0, #if FLX_NO_DEBUG StartState #else PlayState #end, 1, 60, 60, true));

		FlxG.mouse.visible = false;

		#if debug
		// adding this because the Flixel Debugger makes this game more slower so instead i made this FPS object
		var _fps:FPS = new FPS(10, FlxG.height - 20, 0xFFFFFF);
		addChild(_fps);
		#end

		#if ng
		new NGio(APIStuff.GAMEID, APIStuff.ENCKEY, #if FLX_DEBUG true #else false #end);
		#end
	}
}
