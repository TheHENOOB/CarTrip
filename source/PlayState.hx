package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxTimer;

class PlayState extends FlxState
{
	var _enemygroup:FlxTypedGroup<Enemy>;
	var _player:Player;
	var _spawntimer:Float = 0;
	var _hardtimer:FlxTimer = new FlxTimer();
	var _potence:Float = 1;
	var _points:Int = 0;
	var _pointtxt:FlxText;
	var _pointtimer:FlxTimer = new FlxTimer();
	var _bg:BG;

	override public function create()
	{
		super.create();

		FlxG.cameras.bgColor = 0xFF757575;

		_enemygroup = new FlxTypedGroup<Enemy>();

		_player = new Player();

		_pointtxt = new FlxText(0, 0, 0, Std.string(_points), 24);

		_bg = new BG();

		add(_bg);
		add(_enemygroup);
		add(_player);
		add(_pointtxt);

		_hardtimer.start(5, harder, 0);
		_pointtimer.start(1, function morepoints(timer:FlxTimer)
		{
			_points++;
			_pointtxt.text = Std.string(_points);
		}, 0);
	}

	override public function update(elapsed:Float)
	{
		_spawntimer += elapsed * _potence;
		if (_spawntimer > 1)
		{
			_spawntimer--;
			_enemygroup.add(_enemygroup.recycle(Enemy.new));
		}

		super.update(elapsed);

		FlxG.collide(_player, _enemygroup, endgame);
	}

	function endgame(theplayer:Player, theenemy:FlxBasic)
	{
		_pointtimer.cancel();
		_hardtimer.cancel();
		FlxG.resetState();
	}

	function harder(timer:FlxTimer)
	{
		_potence++;

		_enemygroup.forEach(function SPEEED(theenemy:Enemy)
		{
			theenemy.SPEED -= 100;
		});
	}
}
