package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;

using flixel.util.FlxSpriteUtil;

/*
	TODO LIST on Enemy Class:

	- Make Collisions to other cars
 */
class Enemy extends FlxSprite
{
	public var SPEED:Int = 300;
	public var TYPE:EnemyType;
	public var isDamaged:Bool = false;

	var _nospam:Bool = false;
	var _rotatetween:FlxTween;

	public function new()
	{
		super(0, 0);
		generate();
	}

	override public function revive()
	{
		generate();
		super.revive();
	}

	override public function update(elapsed:Float)
	{
		if (x <= -10 && TYPE != ORANGECAR)
		{
			kill();
		}

		if (TYPE == ORANGECAR && x >= FlxG.width + 10)
		{
			kill();
		}

		if (TYPE == ORANGECAR && x < -5 && !_nospam)
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

				_nospam = true;
			}
		}

		if (velocity.x >= 0 && TYPE != ORANGECAR)
		{
			velocity.x = SPEED;
		}

		if (isDamaged)
		{
			damaged();
		}

		super.update(elapsed);
	}

	function generate()
	{
		var cartypearray:Array<EnemyType> = [BLUECAR, TRUCK, ORANGECAR];

		_nospam = false;

		y = FlxG.random.int(34, 660);

		TYPE = FlxG.random.getObject(cartypearray, [80, 10, 10]);

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
			case ORANGECAR:
				x = -30;
				loadGraphic(AssetPaths.OrangeCar__png);
				setGraphicSize(32);
				setSize(32, 25);
				centerOffsets();
				velocity.x = SPEED + 100;
		}
	}

	function damaged() {}
}

enum EnemyType
{
	BLUECAR;
	TRUCK;
	ORANGECAR;
}
