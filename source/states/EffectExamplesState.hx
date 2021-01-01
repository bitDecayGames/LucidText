package states;

import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.FlxG;
import misc.FlxTextFactory;
import flixel.FlxState;
import com.bitdecay.lucidtext.TextGroup;

class EffectExamplesState extends FlxState {
	var xCoord = 20.0;
	var yCoord = 10.0;
	var spacingBuffer = 10;

	override public function create():Void {
		super.create();
		bgColor = FlxColor.WHITE;

		// FlxTextFactory.defaultFont = AssetPaths.Brain_Slab_8__ttf;
		FlxTextFactory.defaultColor = FlxColor.BLACK;
		TextGroup.textMakerFunc = FlxTextFactory.makeSimple;

		FlxG.autoPause = false;

		makeExampleTest("<scrub>Scrub Effect</scrub>");
		makeExampleTest("<wave>Wave Effect</wave>");
		makeExampleTest("<color rgb=0xFF2222>Colored</color> text and <color alpha=0.2>alpha</color>");
		makeExampleTest("<shake>Shake Effect</shake>");
		makeExampleTest("Text of <smaller>smaller size</smaller>");
		makeExampleTest("Text of <bigger>bigger size</bigger>");
		makeExampleTest("<rainbow>Rainbow</rainbow> text");
		makeExampleTest("<fade time=7>Fading text</fade>");

		var button = new FlxButton(0, 0, "Back");
		button.onUp.callback = function() {
			FlxG.switchState(new MainMenuState());
		};
		button.y = FlxG.height - button.height;
		add(button);
	}

	private function makeExampleTest(text:String) {
		var lucid = new TextGroup(xCoord, yCoord, text, 24);
		add(lucid);
		yCoord += lucid.height + spacingBuffer;
		if (yCoord > FlxG.height - 50) {
			yCoord = 10;
			xCoord += 100;
		}
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}
}
