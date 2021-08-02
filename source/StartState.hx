package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class StartState extends FlxState
{
	var _credits:FlxText = new FlxText(0, 0, 0, "", 60);
	var _musiccredits:FlxText = new FlxText(0, 0, 0, "", 20);
	var _henoobicon:FlxSprite = new FlxSprite();
	var _jbicon:FlxSprite = new FlxSprite();
	var _timer:FlxTimer = new FlxTimer();
	var _introsound:FlxSound = Utils.getAudioByName("intro");

	override function create()
	{
		super.create();

		FlxG.cameras.bgColor = FlxColor.BLACK;

		_introsound.play();

		_credits.text = "Made By\nHENOOB";
		_credits.alignment = CENTER;
		_credits.setBorderStyle(SHADOW, FlxColor.GRAY, 1.5, 1);
		_credits.screenCenter();
		_credits.y -= 40;
		add(_credits);

		_musiccredits.text = "With The Music By\nJimmyBiscuit";
		_musiccredits.alignment = CENTER;
		_musiccredits.setBorderStyle(SHADOW, FlxColor.GRAY, 1.5, 1);
		_musiccredits.screenCenter();
		_musiccredits.y += 90;
		add(_musiccredits);

		_henoobicon.loadGraphic(AssetPaths.HENOOB__png);
		_henoobicon.screenCenter();
		_henoobicon.setGraphicSize(230);
		_henoobicon.x -= 300;
		add(_henoobicon);

		_jbicon.loadGraphic(AssetPaths.JB__png);
		_jbicon.screenCenter();
		_jbicon.setGraphicSize(230);
		_jbicon.x += 300;
		add(_jbicon);

		_timer.start(5, goToGame);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.pressed.ANY)
		{
			_timer.cancel();
			goToGame();
		}
	}

	function goToGame(?timer:FlxTimer)
	{
		FlxG.cameras.fade(FlxColor.BLACK, 0.5, false, function()
		{
			FlxG.switchState(new MenuState());
		});
	}
}
