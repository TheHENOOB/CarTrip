package;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSave;

class DeathSubState extends FlxSubState
{
	var _scoretext:FlxText = new FlxText(0, 0, 0, "", 50);
	var _scoreboard:ScoreBoard = new ScoreBoard();
	var _continuetext:FlxText = new FlxText(0, 0, 0, "Press Enter To Restart", 30);
	var _save:FlxSave = new FlxSave();
	var _chashsound:FlxSound = Utils.getAudioByName("crash");
	var _startsound:FlxSound = Utils.getAudioByName("start");
	var _restartready:Bool = false;
	var _totaldeaths:FlxText = new FlxText(0, 0, 0, "", 20);

	public function new()
	{
		super(0x991f1f1f);

		_save.bind("CarTrip");

		FlxG.sound.music.fadeOut(1, 0.3);

		if (_save.data.deaths == null)
		{
			_save.data.deaths = 1;
			_save.flush();

			#if ng
			NGio.unlockMedal(63644);
			#end
		}
		else
		{
			_save.data.deaths += 1;
			_save.flush();
		}

		#if ng
		NGio.sendScore(APIStuff.SCOREBOARDID, PlayState.points);

		if (_save.data.deaths >= 15)
		{
			NGio.unlockMedal(63645);
		}

		if (PlayState.points >= 25)
		{
			NGio.unlockMedal(63973);
		}

		if (PlayState.points >= 50)
		{
			NGio.unlockMedal(63646);
		}

		if (PlayState.points >= 60)
		{
			NGio.unlockMedal(64414);
		}
		#end

		FlxG.state.persistentUpdate = true;

		_chashsound.play();
		FlxG.cameras.flash(FlxColor.WHITE, 2, function()
		{
			_restartready = true;
		});
		FlxG.cameras.shake(0.005, 1.5);

		add(_scoreboard);

		_scoretext.text = "SCORE: " + Std.string(PlayState.points) + "\nHIGH SCORE: " + getHighScore();
		_scoretext.alignment = CENTER;
		_scoretext.screenCenter();
		_scoretext.y -= 200;
		add(_scoretext);

		_totaldeaths.text = "TOTAL DEATHS: " + getDeaths();
		_totaldeaths.alignment = CENTER;
		_totaldeaths.screenCenter();
		_totaldeaths.y -= 120;
		add(_totaldeaths);

		_continuetext.screenCenter();
		_continuetext.y += 320;
		add(_continuetext);

		FlxTween.tween(_continuetext, {y: _continuetext.y + 10}, 1.5, {type: PINGPONG, ease: FlxEase.quadInOut});

		if (PlayState.points > _save.data.highscore || _save.data.highscore == null)
		{
			FlxTween.color(_scoretext, 0.5, FlxColor.WHITE, FlxColor.YELLOW, {type: PINGPONG});
			savepoints();
		}

		FlxG.log.add("Current Deaths: " + Std.string(_save.data.deaths));
	}

	override function close()
	{
		PlayState.points = 0;

		super.close();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ENTER && _restartready)
		{
			restart();
		}

		super.update(elapsed);
	}

	function getHighScore():String
	{
		if (_save.data.highscore != null)
			return Std.string(_save.data.highscore);
		else
			return Std.string(0);
	}

	function getDeaths():String
	{
		if (_save.data.deaths != null)
			return Std.string(_save.data.deaths);
		else
			return Std.string(0);
	}

	function savepoints()
	{
		_save.data.highscore = PlayState.points;
		_save.flush();
	}

	function restart()
	{
		_startsound.play();

		PlayState.pixeltween.type = FlxTweenType.BACKWARD;
		PlayState.pixeltween.onComplete = function reset(thetween:FlxTween)
		{
			close();
			FlxG.resetState();
		};
		FlxG.cameras.flash(FlxColor.WHITE, 0.5, function()
		{
			FlxG.camera.filtersEnabled = true;
			PlayState.pixeltween.start();
		});
	}
}
