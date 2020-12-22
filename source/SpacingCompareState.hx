package;

import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.FlxG;
import misc.FlxTextFactory;
import flixel.FlxState;
import com.bitdecay.lucidtext.TextGroup;
import com.bitdecay.lucidtext.TypingGroup;

class SpacingCompareState extends FlxState {
	override public function create():Void {
		super.create();
		bgColor = FlxColor.WHITE;

		// FlxTextFactory.defaultFont = AssetPaths.Brain_Slab_8__ttf;
		FlxTextFactory.defaultColor = FlxColor.BLACK;
		TextGroup.textMakerFunc = FlxTextFactory.makeSimple;

		FlxG.autoPause = false;

		var size24Ref = FlxTextFactory.make("Welcome to LucidText!", 50, 150, 24);
		add(size24Ref);
		var size24 = new TextGroup(50, 175, "Welcome to <wave>LucidText!</wave>", 24);
		add(size24);

		var size12Ref = new TextGroup(50, 200, "Welcome to <wave>LucidText!</wave>", 12);
		add(size12Ref);
		var size12 = FlxTextFactory.make("Welcome to LucidText!", 50, 225, 12);
		add(size12);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}
}
