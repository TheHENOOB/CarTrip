package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class ScoreBoard extends FlxTypedGroup<FlxSprite>
{
	var _background:FlxSprite;
	var _userarray:Array<FlxText> = new Array<FlxText>();
	var _pointsarray:Array<FlxText> = new Array<FlxText>();
	var _yposition:Float = 0;
	var _counter:Int = 0;
	var _supporter:Bool = true;
	var _title:FlxText = new FlxText(0, 0, 0, "", 25);

	public function new()
	{
		super();

		_background = new FlxSprite();
		_background.makeGraphic(550, 350, FlxColor.BLACK);
		_background.screenCenter();
		_background.y += 100;
		add(_background);

		_yposition = _background.y;

		for (_counter in 0...10)
		{
			_userarray.push(new FlxText(_background.x, _yposition, 0, "", 25));
			_userarray[_counter].text = Std.string(_counter + 1) + ". SevenTheEasterBunny";
			if (_supporter)
			{
				var _imgS:FlxSprite = new FlxSprite(_userarray[_counter].x + _userarray[_counter].width, _yposition + 3);
				_imgS.loadGraphic(AssetPaths.Supporter__png);
				add(_imgS);
			}
			add(_userarray[_counter]);

			_pointsarray.push(new FlxText(_background.x + _background.width - 53, _yposition, 0, "", 25));
			_pointsarray[_counter].text = Std.string(120);
			add(_pointsarray[_counter]);

			_yposition += 35;
		}

		_title.setPosition(_background.x, _background.y - 35);
		_title.text = "Top 10";
		add(_title);
	}
}
