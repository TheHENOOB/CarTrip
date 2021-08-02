package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
#if ng
import io.newgrounds.NG;
#end

class ScoreBoard extends FlxTypedGroup<FlxSprite>
{
	var _background:FlxSprite;
	var _userarray:Array<FlxText> = new Array<FlxText>();
	var _pointsarray:Array<FlxText> = new Array<FlxText>();
	var _yposition:Float = 0;
	var _counter:Int = 0;
	var _supporter:Bool = true;
	var _title:FlxText = new FlxText(0, 0, 0, "", 25);
	#if ng
	var _scoreLoad:Bool = false;
	#end

	public function new()
	{
		super();

		_background = new FlxSprite();
		_background.makeGraphic(550, 350, FlxColor.BLACK);
		_background.screenCenter();
		_background.y += 100;
		add(_background);

		#if ng
		NG.core.requestScoreBoards(function onBoardLoad()
		{
			NG.core.scoreBoards.get(APIStuff.SCOREBOARDID).requestScores(10);
		});
		#else
		var _nopetxt:FlxText = new FlxText(0, 0, 0, "Play the NG version of the game \nto display the scoreboards", 25);
		_nopetxt.alignment = CENTER;
		_nopetxt.screenCenter();
		_nopetxt.y += 30;
		add(_nopetxt);
		#end

		_title.setPosition(_background.x, _background.y - 35);
		_title.text = "Top 10";
		add(_title);
	}

	override function update(elapsed:Float)
	{
		#if ng
		if (NG.core.scoreBoards.get(APIStuff.SCOREBOARDID).scores != null && !_scoreLoad)
		{
			onScoreLoaded();
		}
		#end
	}

	#if ng
	function onScoreLoaded()
	{
		var _scoreBoard = NG.core.scoreBoards.get(APIStuff.SCOREBOARDID);

		_yposition = _background.y;

		for (_counter in 0...10)
		{
			if (_scoreBoard.scores[_counter] != null)
			{
				_userarray.push(new FlxText(_background.x, _yposition, 0, "", 25));
				_userarray[_counter].text = Std.string(_counter + 1) + ". " + _scoreBoard.scores[_counter].user.name;
				if (_scoreBoard.scores[_counter].user.supporter)
				{
					var _imgS:FlxSprite = new FlxSprite(_userarray[_counter].x + _userarray[_counter].width, _yposition + 3);
					_imgS.loadGraphic(AssetPaths.Supporter__png);
					add(_imgS);
				}
				add(_userarray[_counter]);

				_pointsarray.push(new FlxText(_background.x + _background.width - 50, _yposition, 0, "", 25));
				_pointsarray[_counter].text = Std.string(_scoreBoard.scores[_counter].value);
				_pointsarray[_counter].alignment = RIGHT;
				add(_pointsarray[_counter]);

				_yposition += 35;
			}
		}

		_scoreLoad = true;
	}
	#end
}
