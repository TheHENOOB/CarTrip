package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		var game:FlxGame = new FlxGame(0, 0, #if FLX_NO_DEBUG StartState #else MenuState #end, 1, 60, true);

		#if ng
		new NGio(APIStuff.GAMEID, APIStuff.ENCKEY, #if FLX_DEBUG true #else false #end);
		#end

		#if html5
		js.Browser.window.focus();
		#end

		addChild(game);

		FlxG.mouse.visible = false;
		FlxG.mouse.enabled = false;
	}
}
