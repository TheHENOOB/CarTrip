package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.system.FlxSound;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using flixel.util.FlxSpriteUtil;

enum EnemyType
{
	BLUECAR;
	TRUCK;
	// ORANGECAR;
}

class Enemy extends FlxSprite
{
	public var SPEED:Int = 300;
	public var TYPE:EnemyType;
	public var isDamaged:Bool = false;
	public var isMenu:Bool = false;

	var _rotatetween:FlxTween;
	var _emitter:FlxEmitter;
	var _emittertimer:FlxTimer = new FlxTimer();

	public function new()
	{
		super(0, 0);
		generate();
	}

	override function kill()
	{
		super.kill();

		if (TYPE == BLUECAR && isDamaged)
		{
			_emitter.emitting = false;
			_emittertimer.start(3, function(timer:FlxTimer)
			{
				FlxG.state.remove(_emitter);
			});
		}
	}

	override public function revive()
	{
		generate();
		super.revive();
	}

	override public function update(elapsed:Float)
	{
		if (x <= -50 || x >= FlxG.width + 30)
		{
			kill();
		}

		/*
			if (TYPE == ORANGECAR && x < -5)
			{
				var alert:FlxSprite = new FlxSprite();
				alert.loadGraphic(AssetPaths.OrangeAlert__png);
				alert.x = FlxG.width - 25;
				alert.y = y;
				alert.flicker(0);
				FlxG.state.add(alert);

				if (x > -5 || PlayState.gameended)
				{
					alert.kill();
					FlxG.state.remove(alert);
				}
			}
		 */

		if (velocity.x >= 0 /*&& TYPE != ORANGECAR*/)
		{
			velocity.x = SPEED;
		}

		if (TYPE == BLUECAR && isDamaged)
		{
			_emitter.x = this.x;
			_emitter.y = this.y;
		}

		super.update(elapsed);
	}

	public function damaged()
	{
		var _damagesound:FlxSound = Utils.getAudioByName("damage");
		_damagesound.volume = 1;

		if (!isDamaged)
		{
			_damagesound.play();
			FlxG.cameras.shake(0.0025, 0.5);
			angularVelocity = SPEED * 100;
			elasticity = 1;

			if (FlxG.random.bool(50))
			{
				velocity.y = -SPEED;
			}
			else
			{
				velocity.y = SPEED;
			}

			_emitter = new FlxEmitter(x, y);
			_emitter.loadParticles(AssetPaths.Smoke__png);
			_emitter.alpha.set(0.5, 0.8, 0, 0);
			_emitter.scale.set(4, 4, 4, 4, 2, 2, 2, 2);
			_emitter.color.set(FlxColor.ORANGE, FlxColor.RED, FlxColor.GRAY, FlxColor.GRAY);
			FlxG.state.add(_emitter);
			_emitter.start(false, 0.1);
		}
		isDamaged = true;
	}

	function generate()
	{
		y = FlxG.random.int(34, 660);

		// Remove all stuff damaged() has made to the game object
		if (isDamaged)
		{
			angularVelocity = 0;
			angle = 0;
			isDamaged = false;
		}

		velocity.y = 0;

		// Orange Car is temporarily disabled to focus on the collisions of both Blue Cars and Trucks
		if (!isMenu)
			TYPE = FlxG.random.getObject(EnemyType.createAll(), [90, 10]);
		else
			TYPE = BLUECAR;

		switch (TYPE)
		{
			case BLUECAR:
				x = FlxG.width;
				loadGraphic(AssetPaths.BluCar__png);
				setGraphicSize(32);
				setSize(32, 25);
				centerOffsets();
				velocity.x = -SPEED;
			case TRUCK:
				x = FlxG.width;
				loadGraphic(AssetPaths.Truck__png);
				setGraphicSize(69);
				setSize(69, 48);
				centerOffsets();
				velocity.x = -SPEED - 200;
				/*
					case ORANGECAR:
						x = -30;
						loadGraphic(AssetPaths.OrangeCar__png);
						setGraphicSize(32);
						setSize(32, 25);
						centerOffsets();
						velocity.x = SPEED + 100;
				 */
		}
	}
}
