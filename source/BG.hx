package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.shapes.FlxShapeBox;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;

class BG extends FlxTypedGroup<FlxSprite>
{
	public var track:FlxSprite;

	var _boxup:FlxShapeBox;
	var _boxdown:FlxShapeBox;

	public function new()
	{
		super();

		_boxup = new FlxShapeBox(0, 0, FlxG.width, 15, {thickness: 3, color: FlxColor.WHITE}, FlxColor.GREEN);
		_boxup.immovable = true;
		add(_boxup);

		_boxdown = new FlxShapeBox(0, FlxG.height - 15, FlxG.width, 15, {thickness: 3, color: FlxColor.WHITE}, FlxColor.GREEN);
		_boxdown.immovable = true;
		add(_boxdown);

		track = new FlxSprite();
		track.loadGraphic(AssetPaths.Track__png, true, 75, 1);
		track.screenCenter(FlxAxes.Y);
		track.setGraphicSize(FlxG.width + 1200, 2);
		track.animation.add('Runnin', [0, 1, 2, 3, 4, 5], 20, true);
		track.animation.play('Runnin');
		add(track);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
