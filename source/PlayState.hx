package;

import com.bitdecay.lucidtext.TypeOptions;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.FlxG;
import misc.FlxTextFactory;
import flixel.FlxState;
import com.bitdecay.lucidtext.TextGroup;
import com.bitdecay.lucidtext.TypingGroup;

class PlayState extends FlxState {
	var helloText:TypingGroup;

	override public function create():Void {
		super.create();
		bgColor = FlxColor.WHITE;

		// FlxTextFactory.defaultFont = AssetPaths.Brain_Slab_8__ttf;
		FlxTextFactory.defaultColor = FlxColor.BLACK;
		TextGroup.textMakerFunc = FlxTextFactory.makeSimple;
		FlxG.autoPause = false;

		var options = new TypeOptions(AssetPaths.slice__png, [4, 4, 12, 12]);
		helloText = new TypingGroup(FlxRect.get(50, 175, 400, 75),
			"Welcome to <wave speed=10>LucidText!!</wave> This is a <scrub>fairly long</scrub> piece of text to exhibit the very cool ability to do word wrapping and typing. <smaller>Patent pending</smaller>",
			options);
		add(helloText);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}
}
