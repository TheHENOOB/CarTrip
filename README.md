# CarTrip

A Game made for fun by HENOOB with the music by JimmyBiscuit

## Play the Game

If you want to play the game there isn't any links yet

## Compiling the Game

You need A Knowledgement about using Command Prompt, Haxe, HaxeFlixel, and the game required librarys

´´´
haxelib install newgrounds
haxelib install flixel-addons
´´´

After that make a file called APIStuff.hx on the source folder with this exact text
´´´
package;

class APIStuff
{
	public static inline var GAMEID:String = "";
	public static inline var ENCKEY:String = "";
	public static inline var SCOREBOARDID:Int = 0;
}
´´´

Now test your game with HTML5 or Neko and hooray game works
´´´
lime test neko
lime test html5
´´´
