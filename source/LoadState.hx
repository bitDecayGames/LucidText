package;

import flixel.text.FlxBitmapText;
import openfl.display.FPS;
import states.MainMenuState;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.FlxState;
import com.bitdecay.lucidtext.TextGroup;

class LoadState extends FlxState {
	var txt:TextGroup;

	var nextY = 0.0;

	var texts = new Array<TextGroup>();

	var button:FlxButton;
	var characterCount = 0;

	var fpsDisplay:FlxBitmapText;

	override public function create():Void {
		super.create();
		bgColor = FlxColor.WHITE;

		strainNew(10);


		button = new FlxButton(0, 0, "Back");
		button.width = FlxG.width / 4;
		button.onUp.callback = function() {
			FlxG.switchState(new MainMenuState());
		};
		button.y = FlxG.height - button.height;
		add(button);

		fpsDisplay = new FlxBitmapText();
		fpsDisplay.color = FlxColor.BLACK;
		fpsDisplay.text = "FPS";
		fpsDisplay.scale.set(2, 2);
		fpsDisplay.updateHitbox();
		fpsDisplay.setPosition(0, button.y - fpsDisplay.height);
		fpsDisplay.screenCenter(X);
		add(fpsDisplay);
	}

	public function strainNew(count:Int) {
		// for (group in texts) {
		// 	group.put();
		// 	remove(group);
		// }

		for (i in 0...count) {
			var txt = new TextGroup(
				FlxRect.get(10,nextY, 10000, 50),
				"<color rgb=0x000000>Welcome to <wave>LucidText!!</wave> This is a <scrub>fairly long</scrub> piece of text to exhibit the very cool ability to do word wrapping and typing. <smaller>Patent pending</smaller></color>",
				24);
			add(txt);
			nextY += 2;

			characterCount += txt.length;
		}
	}

	var frameCount = 0;

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		if (frameCount == 60) {
			frameCount = 0;
			strainNew(5);
		}
		frameCount++;

		fpsDisplay.text = '${Main.fps.currentFPS}fps with ${characterCount} characters in scene';
	}
}
