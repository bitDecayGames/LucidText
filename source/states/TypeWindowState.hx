package states;

import flixel.FlxSprite;
import com.bitdecay.lucidtext.TypeOptions;
import flixel.math.FlxRect;
import com.bitdecay.lucidtext.TypingGroup;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.FlxG;
import misc.FlxTextFactory;
import flixel.FlxState;
import com.bitdecay.lucidtext.TextGroup;

class TypeWindowState extends FlxState {
	override public function create():Void {
		super.create();
		bgColor = FlxColor.WHITE;

		FlxTextFactory.defaultColor = FlxColor.BLACK;
		TextGroup.textMakerFunc = FlxTextFactory.makeSimple;
		FlxG.autoPause = false;

		var options = new TypeOptions(AssetPaths.slice__png, [4, 4, 12, 12]);

		var txt = new TypingGroup(FlxRect.get(20, 20, FlxG.width - 40, FlxG.height/2 - 40),
			"Welcome to <wave>LucidText!!</wave> This is a <scrub>fairly long</scrub> piece of text to exhibit the very cool ability to do word wrapping and typing. <smaller>Patent pending</smaller>",
			options, 24);
		add(txt);

		var secondOptions = new TypeOptions(AssetPaths.slice__png, [4, 4, 12, 12]);

		secondOptions.checkPageConfirm = (delta) -> {
			return FlxG.keys.justPressed.SPACE;
		}
		secondOptions.nextIconMaker = () -> {
			var nextPageIcon = new FlxSprite();
			nextPageIcon.loadGraphic(AssetPaths.nextPage__png, true, 32, 32);
			nextPageIcon.animation.add("play", [0, 1, 2, 3, 4, 1], 10);
			nextPageIcon.animation.play("play");
			return nextPageIcon;
		};
		var secondTxt = new TypingGroup(FlxRect.get(50, 200, 300, 250),
			"Press <color rgb=0x3333FF>SPACE</color> when the arrow appears in the bottom right of this window to go to the next page. A fancy thing called <scrub>callbacks</scrub> can be used to attach behavior to various parts of the text system.", secondOptions, 24);

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
			// add our 'response' text to the state
			add(secondTxt);
		}

		secondTxt.letterCallback = letterBeepCallback;
		secondTxt.wordCallback = wordBeepCallback;

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
