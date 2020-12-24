package;

import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.FlxG;
import misc.FlxTextFactory;
import flixel.FlxState;
import com.bitdecay.lucidtext.TextGroup;
import com.bitdecay.lucidtext.TypingGroup;

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
		// helloText = new TypingGroup(FlxRect.get(50, 175, 100, 75), "<scrub>Welcome</scrub> to <wave speed=10>LucidText!</wave>", 16);
		// add(helloText);

		// with smaller
		var sizingTest = new TextGroup(50, 50, "Defaults: <scrub>Welcome</scrub>", 24);
		add(sizingTest);

		var two = new TextGroup(50, 100, "Speed 20: <scrub speed=20>Welcome</scrub>", 24);
		add(two);

		var three = new TextGroup(50, 150, "Offset 0.3: <scrub offset=0.3>Welcome</scrub>", 24);
		add(three);

		var four = new TextGroup(50, 200, "Height 16: <scrub height=16>Welcome</scrub>", 24);
		add(four);

		var four = new TextGroup(50, 250, "Height 32: <scrub height=32>Welcome</scrub>", 24);
		add(four);

		var five = new TextGroup(50, 300, "Offset 0: <scrub offset=0.0>Welcome</scrub>", 24);
		add(five);

		var six = new TextGroup(50, 350, "y_mod 3: <scrub y_mod=3>Welcome</scrub>", 24);
		add(six);

		var sev = new TextGroup(50, 390, "x_mod 0: <scrub height=30 x_mod=0>Welcome</scrub>", 24);
		add(sev);

		var sev = new TextGroup(50, 425, "wave   : <wave speed=10 height=15>Welcome</wave>", 24);
		add(sev);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		// helloText.y += 10 * elapsed;
	}
}
