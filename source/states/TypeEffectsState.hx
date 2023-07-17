package states;

import com.bitdecay.lucidtext.TypeOptions;
import flixel.math.FlxRect;
import com.bitdecay.lucidtext.TypingGroup;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.FlxG;
import misc.FlxBitmapTextFactory;
import flixel.FlxState;
import com.bitdecay.lucidtext.TextGroup;

class TypeEffectsState extends FlxState {
	override public function create():Void {
		super.create();
		bgColor = FlxColor.WHITE;

		FlxBitmapTextFactory.defaultColor = FlxColor.BLACK;
		TextGroup.textMakerFunc = FlxBitmapTextFactory.makeSimple;
		FlxG.autoPause = false;

		var sliceCoords = [4, 4, 4, 4];
		var margins:Array<Float> = [14, 8, 8, 8];
		var options = new TypeOptions(AssetPaths.slice__png, sliceCoords, margins);

		var speedTxt = new TypingGroup(FlxRect.get(20, 20, FlxG.width - 40, FlxG.height / 2 - 40),
			"Text speed can be modified dynamically <faster>either to be typed at a much faster rate</faster> <speed mod=10>(as fast as anybody could need),</speed> or <slower>to be typed slower</slower> <speed mod=0.25>(sluggish, even).</speed>",
			options);
		add(speedTxt);

		var pauseOps = options.clone();
		pauseOps.fontSize = 30;
		var pauseText = new TypingGroup(FlxRect.get(20, 300, FlxG.width - 40, 100), "Pauses<pause/> can also be added<pause/> for dramatic<pause/> impact",
			pauseOps);

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
