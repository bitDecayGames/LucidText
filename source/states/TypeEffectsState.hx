package states;

import com.bitdecay.lucidtext.TypeOptions;
import flixel.math.FlxRect;
import com.bitdecay.lucidtext.TypingGroup;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.FlxG;
import misc.FlxTextFactory;
import flixel.FlxState;
import com.bitdecay.lucidtext.TextGroup;

class TypeEffectsState extends FlxState {
	override public function create():Void {
		super.create();
		bgColor = FlxColor.WHITE;

		FlxTextFactory.defaultColor = FlxColor.BLACK;
		TextGroup.textMakerFunc = FlxTextFactory.makeSimple;
		FlxG.autoPause = false;

		var options = new TypeOptions(FlxRect.get(20, 20, FlxG.width - 40, FlxG.height / 2 - 40), AssetPaths.slice__png, [4, 4, 12, 12]);
		options.fontSize = 24;
		trace('so the font size is ${options.fontSize}');
		options.modOps.charsPerSecond = 10;

		var speedTxt = new TypingGroup("Text speed can be modified dynamically <faster>either to be typed at a much faster rate</faster> <speed mod=10>(as fast as anybody could need),</speed> or <slower>to be typed slower</slower> <speed mod=0.25>(sluggish, even).</speed>",
			options);
		add(speedTxt);

		var pauseOps = options.clone();
		pauseOps.fontSize = 30;
		pauseOps.bounds = FlxRect.get(20, FlxG.height / 2, FlxG.width - 40, FlxG.height / 2 - 20);
		var pauseText = new TypingGroup("Pauses<pause /> can also be added<pause /> for dramatic<pause /> impact", pauseOps);

		speedTxt.finishCallback = () -> {
			add(pauseText);
		}

		var button = new FlxButton(0, 0, "Back");
		button.onUp.callback = function() {
			FlxG.switchState(new MainMenuState());
		};
		button.y = FlxG.height - button.height;
		add(button);
	}
}
