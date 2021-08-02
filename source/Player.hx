package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class Player extends FlxSprite
{
	public static inline var SPEED:Int = 250;

	public var box:FlxObject;
	public var explosion:FlxSprite = new FlxSprite();

	public function new()
	{
		super(10, 0, AssetPaths.Car__png);
		screenCenter(FlxAxes.Y);

		setGraphicSize(32);
		setSize(32, 25);
		centerOffsets();

		box = new FlxObject(0, 0, this.width, this.height * 2);
		FlxG.state.add(box);

		explosion.loadGraphic(AssetPaths.Kaboom__png, true, 20, 20);
		explosion.animation.add('kaboom1', [0]);
		explosion.animation.add('kaboom2', [0]);
		explosion.setGraphicSize(55);
		explosion.visible = false;
		FlxG.state.add(explosion);

		drag.y = 1600;
	}

	override function update(elapsed:Float)
	{
		controls();

		box.setPosition(this.x, this.y - (this.height / 2));

		super.update(elapsed);
	}

	override function kill()
	{
		super.kill();

		var _emmiter:FlxEmitter = new FlxEmitter(this.x, this.y);
		var _emmitertimer:FlxTimer = new FlxTimer();

		explosion.visible = true;
		explosion.setPosition(this.x, this.y);
		explosion.animation.play('kaboom' + Std.string(FlxG.random.int(1, 2)));

		_emmiter.loadParticles(AssetPaths.Smoke__png);
		_emmiter.alpha.set(0.5, 0.8, 0, 0);
		_emmiter.scale.set(4, 4, 4, 4, 2, 2, 2, 2);
		_emmiter.color.set(FlxColor.ORANGE, FlxColor.RED, FlxColor.GRAY, FlxColor.BLACK);
		_emmiter.lifespan.set(5, 5);
		FlxG.state.add(_emmiter);
		_emmiter.start(true);
		_emmitertimer.start(2, function(timer:FlxTimer)
		{
			_emmiter.emitting = false;
		});

		box.kill();
	}

	function controls()
	{
		var up:Bool = FlxG.keys.pressed.UP;
		var down:Bool = FlxG.keys.pressed.DOWN;

		if (up)
		{
			velocity.y = -SPEED;
		}
		if (down)
		{
			velocity.y = SPEED;
		}
		if (up && down)
		{
			velocity.y = 0;
		}
	}
}
