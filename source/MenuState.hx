package;

import Mosaic.MosaicEffect;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.filters.ShaderFilter;

class MenuState extends FlxState
{
	var _logo:FlxSprite = new FlxSprite();
	var _bg:BG;
	var _starttext:FlxText;
	var _enemygroup:FlxTypedSpriteGroup<Enemy>;
	var _spawntimer:Float = 0;
	var _flashtimer:FlxTimer = new FlxTimer();
	var _isgamestarted:Bool = false;
	var _startsound:FlxSound = Utils.getAudioByName("start");
	#if ng
	var _username:FlxText = new FlxText(0, 0, 0, "", 24);
	#end

	override function create()
	{
		super.create();

		FlxG.cameras.bgColor = 0xFF757575;

		FlxG.cameras.flash(FlxColor.WHITE, 1);

		FlxG.sound.playMusic(Utils.getMusicByName("menutheme"), 1);

		_bg = new BG();
		add(_bg);

		_enemygroup = new FlxTypedSpriteGroup<Enemy>();
		add(_enemygroup);

		#if ng
		_username.text = "Connecting to NG...";
		add(_username);
		#end

		_logo.loadGraphic(AssetPaths.Logo__png, false);
		_logo.setGraphicSize(900);
		_logo.screenCenter();
		_logo.y -= 60;
		add(_logo);

		_starttext = new FlxText(0, 0, 0, "Press Enter", 60);
		_starttext.screenCenter(FlxAxes.X);
		_starttext.y = _logo.y + 250;
		add(_starttext);

		_flashtimer.start(1, function(timer:FlxTimer)
		{
			if (_starttext.alive)
				_starttext.kill();
			else
				_starttext.revive();
		}, 0);
	}

	override function update(elapsed:Float)
	{
		_spawntimer += elapsed;
		if (_spawntimer > 1)
		{
			_enemygroup.add(_enemygroup.recycle(Enemy.new));
			_spawntimer--;
		}

		_enemygroup.forEach(function(enemy:Enemy)
		{
			enemy.isMenu = true;
		});

		#if ng
		if (NGio.isConnected())
		{
			_username.text = "Connected as " + NGio.getUsername();
		}
		#end

		if (FlxG.keys.justPressed.ENTER && !_isgamestarted)
		{
			startgame();
			_isgamestarted = true;
		}

		super.update(elapsed);
	}

	function startgame()
	{
		var _timer:FlxTimer = new FlxTimer();

		_flashtimer.time = 0.1;

		FlxG.sound.music.stop();
		FlxG.sound.music = null;

		_startsound.play();
		FlxG.cameras.flash(FlxColor.WHITE, 0.5);

		_timer.start(0.5, flashComplete);
	}

	function flashComplete(timer:FlxTimer)
	{
		var _mosaicShader:MosaicEffect = new MosaicEffect();
		FlxG.camera.setFilters([new ShaderFilter(_mosaicShader.shader)]);
		FlxTween.num(0.1, 15, 1, {type: PERSIST, onComplete: onComplete}, function(v)
		{
			_mosaicShader.setStrength(v, v);
		});
	}

	function onComplete(tween:FlxTween)
	{
		FlxG.switchState(new PlayState());
	}
}
