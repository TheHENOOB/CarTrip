package;

import Mosaic.MosaicEffect;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import openfl.filters.ShaderFilter;

class PlayState extends FlxState
{
	// Public Variables
	public static var points:Int = 0;
	public static var pixeltween:FlxTween;
	public static var gameended = false;

	// Gameplay Variables
	var _enemygroup:FlxTypedSpriteGroup<Enemy>;
	var _player:Player;
	var _spawntimer:Float = 0;
	var _hardtimer:FlxTimer = new FlxTimer();
	var _potence:Float = 1;
	var _pointtxt:FlxText;
	var _pointtimer:FlxTimer = new FlxTimer();
	var _bg:BG;
	var _pixelshader:MosaicEffect;

	// Sound Variables
	var _damagesound:FlxSound = Utils.getAudioByName("damage");

	override public function create()
	{
		super.create();

		FlxG.cameras.bgColor = 0xFF757575;

		if (FlxG.sound.music == null)
		{
			FlxG.sound.playMusic(Utils.getMusicByName("gameplaytheme"), 1);
		}

		if (FlxG.sound.music != null && FlxG.sound.music.volume < 1)
		{
			FlxG.sound.music.volume = 1;
		}

		_enemygroup = new FlxTypedSpriteGroup<Enemy>();

		_player = new Player();

		_pointtxt = new FlxText(0, 0, 0, Std.string(points), 24);

		_bg = new BG();

		_pixelshader = new MosaicEffect();
		FlxG.camera.setFilters([new ShaderFilter(_pixelshader.shader)]);

		pixeltween = FlxTween.num(15, 0.1, 1, {type: PERSIST, onComplete: toggleShader}, function(v)
		{
			_pixelshader.setStrength(v, v);
		});

		_pointtxt.visible = true;

		gameended = false;

		add(_bg);
		add(_enemygroup);
		add(_player);
		add(_pointtxt);

		_hardtimer.start(5, harder, 0);
		_pointtimer.start(1, function morepoints(timer:FlxTimer)
		{
			points++;
			_pointtxt.text = Std.string(points);
		}, 0);
	}

	override public function update(elapsed:Float)
	{
		_spawntimer += elapsed * _potence;
		if (_spawntimer > 1 && _player.alive)
		{
			_spawntimer--;
			_enemygroup.add(_enemygroup.recycle(Enemy.new));
		}

		super.update(elapsed);

		FlxG.collide(_player, _bg);
		FlxG.collide(_enemygroup, _bg);
		FlxG.collide(_player, _enemygroup, endgame);

		_enemygroup.forEach(enemyUpdate);
	}

	function endgame(?theplayer:Player, ?theenemy:Enemy)
	{
		_player.kill();
		if (!_player.alive && !gameended)
		{
			gameended = true;
			_pointtxt.visible = false;
			_bg.track.animation.stop();
			_pointtimer.cancel();
			_hardtimer.cancel();
			openSubState(new DeathSubState());
		}
	}

	function harder(timer:FlxTimer)
	{
		_potence++;

		_enemygroup.forEach(function SPEEED(theenemy:Enemy)
		{
			theenemy.SPEED += 100;
		});
	}

	// Probably this is the thing that have taken more time then expected
	function enemyUpdate(_enemy:Enemy)
	{
		FlxG.collide(_enemy, _enemygroup, function onEnemyCollide(enemy1:Enemy, enemy2:Enemy)
		{
			if ((enemy1.TYPE == BLUECAR && enemy2.TYPE == BLUECAR)
				|| (enemy1.TYPE == TRUCK && enemy2.TYPE == TRUCK)
				|| ((enemy1.TYPE == BLUECAR && enemy2.TYPE == TRUCK) && ((enemy1.x > enemy2.x) || !(enemy2.velocity.x <= -500)))
				|| ((enemy2.TYPE == BLUECAR && enemy1.TYPE == TRUCK) && ((enemy2.x > enemy1.x) || !(enemy1.velocity.x <= -500))))
			{
				_damagesound.volume = 0.6;
				_damagesound.play();

				if (enemy1.x < enemy2.x)
				{
					enemy1.velocity.x -= 50;
				}
				else
				{
					enemy2.velocity.x -= 50;
				}
			}
			else
			{
				if (enemy1.TYPE == TRUCK && enemy2.TYPE == BLUECAR)
				{
					enemy2.damaged();
				}
				else if (enemy2.TYPE == TRUCK && enemy1.TYPE == BLUECAR)
				{
					enemy1.damaged();
				}
			}
		});

		if (gameended && !_enemy.isDamaged)
		{
			_enemy.velocity.x = Math.abs(_enemy.velocity.x);
		}
	}

	function toggleShader(thetween:FlxTween)
	{
		FlxG.camera.filtersEnabled = !FlxG.camera.filtersEnabled;
	}
}
