package;

import flixel.system.FlxSound;

class Utils
{
	// since compiler conditionals is a little repetitive with sounds i made this function to get sounds more easier
	public static function getAudioByName(audioname:String, isMusic:Bool = false):FlxSound
	{
		var fileformat:String = #if (cpp || neko) ".ogg" #else ".mp3" #end;
		var sound:FlxSound = new FlxSound();
		if (isMusic)
			sound.loadEmbedded("assets/music/" + audioname + fileformat);
		else
			sound.loadEmbedded("assets/sounds/" + audioname + fileformat);
		return sound;
	}
}
