package states;

import flixel.math.FlxRect;
import com.bitdecay.lucidtext.TypingGroup;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.FlxG;
import misc.FlxTextFactory;
import flixel.FlxState;
import com.bitdecay.lucidtext.TextGroup;

class TypingState extends FlxState {
	override public function create():Void {
		super.create();
		bgColor = FlxColor.WHITE;

		FlxTextFactory.defaultColor = FlxColor.BLACK;
		TextGroup.textMakerFunc = FlxTextFactory.makeSimple;
		FlxG.autoPause = false;

		var txt = new TypingGroup(FlxRect.get(50, 50, 400, 120),
			"Welcome to <wave speed=10>LucidText!!</wave> This is a <scrub>fairly long</scrub> piece of text to exhibit the very cool ability to do word wrapping and typing. <smaller>Patent pending</smaller>",
			16);
		add(txt);

		var letterSound = FlxG.sound.load(AssetPaths.letter_blip__wav);
		letterSound.volume = 0.05;
		var wordSound = FlxG.sound.load(AssetPaths.word_blip__wav);
		wordSound.volume = 0.2;

		var letterBeepCallback = () -> {
			letterSound.stop();
			letterSound.play();
		}

		var wordBeepCallback = () -> {
			wordSound.stop();
			wordSound.play();
		};

		txt.letterCallback = letterBeepCallback;
		txt.wordCallback = wordBeepCallback;
		txt.finishCallback = () -> {
			var secondTxt = new TypingGroup(FlxRect.get(50, 200, 250, 250),
				"A fancy thing called <scrub>callbacks</scrub> can be used to attach behavior to various parts of the text system", 16);
			add(secondTxt);

			secondTxt.letterCallback = letterBeepCallback;
			secondTxt.wordCallback = wordBeepCallback;
		}

		var button = new FlxButton(0, 0, "Back");
		button.onUp.callback = function() {
			FlxG.switchState(new MainMenuState());
		};
		button.y = FlxG.height - button.height;
		add(button);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}
}
