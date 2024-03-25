package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.display.shapes.FlxShapeBox;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxDirectionFlags;

class BG extends FlxTypedSpriteGroup<FlxSprite>
{
	public var track:FlxSprite;

	public var trackSpeed:Float;

	// I could make own sprites for those two boxes and not use the flixel-addons
	// but i thought it would take a lot of time to make those stuff work
	var _boxup:FlxShapeBox;
	var _boxdown:FlxShapeBox;

	public function new()
	{
		super();

		_boxup = new FlxShapeBox(-5, -2, FlxG.width + 10, 35, {thickness: 3, color: FlxColor.WHITE}, FlxColor.GREEN);
		_boxup.allowCollisions = FlxDirectionFlags.ANY;
		_boxup.immovable = true;
		add(_boxup);

		_boxdown = new FlxShapeBox(-5, FlxG.height - 35, FlxG.width + 10, 40, {thickness: 3, color: FlxColor.WHITE}, FlxColor.GREEN);
		_boxdown.allowCollisions = FlxDirectionFlags.ANY;
		_boxdown.immovable = true;
		add(_boxdown);

		track = new FlxSprite();
		track.loadGraphic(AssetPaths.RoadTrack__png, true, 75, 1);
		track.screenCenter(FlxAxes.Y);
		track.setGraphicSize(FlxG.width + 1200, 2);
		track.animation.add('Runnin', [0, 1, 2, 3, 4, 5], 20, true);
		track.animation.play('Runnin');
		track.allowCollisions = FlxDirectionFlags.NONE;
		add(track);

		trackSpeed = 0.5;
	}

	override public function update(elapsed:Float)
	{
		track.animation.timeScale = trackSpeed;

		super.update(elapsed);
	}
}
