package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, #if FLX_NO_DEBUG StartState #else PlayState #end, 1, 60, 60, true));

		#if ng
		new NGio(APIStuff.GAMEID, APIStuff.ENCKEY, #if FLX_DEBUG true #else false #end);
		#end
	}
}
