package;

import flixel.FlxG;
import flixel.FlxSprite;

/*
	TODO LIST on Enemy Class:

	- Make Collisions to other cars
	- Make Truck Bigger
 */
class Enemy extends FlxSprite
{
	public var SPEED:Int = -200;
	public var TYPE:EnemyType;

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
		if (x <= -10)
		{
			kill();
		}

		super.update(elapsed);

		FlxG.collide(this, this, onCarGotHit);
	}

	function generate()
	{
		x = FlxG.width;
		y = FlxG.random.int(0, FlxG.height);

		if (FlxG.random.bool(5))
		{
			TYPE = TRUCK;
		}
		else
		{
			TYPE = BLUECAR;
		}

		switch (TYPE)
		{
			case BLUECAR:
				loadGraphic(AssetPaths.BluCar__png);
				setGraphicSize(32);
				setSize(32, 25);
				centerOffsets();
				velocity.x = SPEED;
			case TRUCK:
				loadGraphic(AssetPaths.Truck__png);
				setGraphicSize(32);
				setSize(32, 25);
				centerOffsets();
				velocity.x = SPEED - 200;
		}
	}

	function onCarGotHit(enemy1:Enemy, enemy2:Enemy)
	{
		if (enemy1.x < enemy2.x)
		{
			if (FlxG.random.bool(50))
			{
				enemy1.velocity.y = 100;
			}
			else
			{
				enemy1.velocity.y = -100;
			}
		}
		else if (enemy1.x > enemy2.x)
		{
			if (FlxG.random.bool(50))
			{
				enemy2.velocity.y = 100;
			}
			else
			{
				enemy2.velocity.y = -100;
			}
		}
	}
}

enum EnemyType
{
	BLUECAR;
	TRUCK;
}
