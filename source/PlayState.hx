package;

import flixel.util.FlxColor;
import flixel.FlxG;
import misc.FlxTextFactory;
import flixel.FlxState;
import com.bitdecay.lucidtext.TextGroup;

class PlayState extends FlxState {
	var helloText:TextGroup;

	override public function create():Void {
		super.create();
		bgColor = FlxColor.WHITE;

		// FlxTextFactory.defaultFont = AssetPaths.Brain_Slab_8__ttf;
		FlxTextFactory.defaultColor = FlxColor.BLACK;
		TextGroup.textMakerFunc = FlxTextFactory.makeSimple;

		FlxG.autoPause = false;

		// control. just a FlxText object with everything
		// var other = FlxTextFactory.make("Am I sounding quiet now?", 50, 150, 24);
		// add(other);

		// no effects
		helloText = new TextGroup(50, 175, "Welcome to <wave height=30 speed=5>LucidText!</wave>", 36);
		add(helloText);

		// with smaller
		// var sizingTest = new TextGroup(50, 200, "Am I <smaller>sounding quiet now?</smaller>", 48);
		// add(sizingTest);

		// // with bigger
		// var sizingBiggerTest = new TextGroup(50, 275, "Am I <bigger>sounding quiet now?</bigger>", 48);
		// add(sizingBiggerTest);

		// var sizingTest = new TextGroup(50, 350, "Am I <size mod=1.5>now</size> <size mod=2>much</size> <size mod=3>shout</size>", 24);
		// add(sizingTest);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		// helloText.y += 10 * elapsed;
	}
}
