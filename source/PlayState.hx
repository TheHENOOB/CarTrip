package;

import Mosaic.MosaicEffect;
import flixel.FlxG;
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
	var _beatsound:FlxSound = Utils.getAudioByName("beat");

	override public function create()
	{
		super.create();

		FlxG.cameras.bgColor = 0xFF757575;

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

		_enemygroup.forEach(carCollision);
	}

	function endgame(?theplayer:Player, ?theenemy:Enemy)
	{
		_player.kill();
		_pointtxt.visible = false;
		if (!_player.alive && !gameended)
		{
			gameended = true;
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
			theenemy.SPEED -= 100;
		});
	}

	function carCollision(_enemy:Enemy)
	{
		if (_enemy.TYPE != ORANGECAR)
			FlxG.collide(_enemy, _enemygroup, function onEnemyCollide(enemy1:Enemy, enemy2:Enemy)
			{
				if (enemy1.x < enemy2.x)
				{
					if (enemy1.y < enemy2.y)
					{
						enemy1.velocity.y = -20;
					}
					else
					{
						enemy1.velocity.y = 20;
					}

					if (enemy1.TYPE == BLUECAR && enemy2.TYPE == TRUCK)
					{
						enemy1.isDamaged = true;
					}
				}
				else
				{
					if (enemy2.y < enemy1.y)
					{
						enemy2.velocity.y = -20;
					}
					else
					{
						enemy2.velocity.y = 20;
					}
				}
			});
	}

	function toggleShader(thetween:FlxTween)
	{
		FlxG.camera.filtersEnabled = !FlxG.camera.filtersEnabled;
	}
}
