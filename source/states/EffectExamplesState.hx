package states;

import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.FlxG;
import misc.FlxTextFactory;
import flixel.FlxState;
import com.bitdecay.lucidtext.TextGroup;

class EffectExamplesState extends FlxState {
	var yCoord = 100.0;
	var spacingBuffer = 20;

	override public function create():Void {
		super.create();
		bgColor = FlxColor.WHITE;

		// FlxTextFactory.defaultFont = AssetPaths.Brain_Slab_8__ttf;
		FlxTextFactory.defaultColor = FlxColor.BLACK;
		TextGroup.textMakerFunc = FlxTextFactory.makeSimple;

		FlxG.autoPause = false;

		makeExampleTest("<scrub>Scrub Effect</scrub>");
		makeExampleTest("<wave>Wave Effect</wave>");
		makeExampleTest("<color rgb=0xAA2222>Color</color> <color rgb=0x222288>Effect</color>");
		makeExampleTest("<shake>Shake Effect</shake>");
		makeExampleTest("Text of <smaller>smaller</smaller> size");
		makeExampleTest("Text of <bigger>bigger</bigger> size");

		var button = new FlxButton(0, 0, "Back");
		button.onUp.callback = function() {
			FlxG.switchState(new MainMenuState());
		};
		button.y = FlxG.height - button.height;
		add(button);
	}

	private function makeExampleTest(text:String) {
		var lucid = new TextGroup(30, yCoord, text, 24);
		add(lucid);
		yCoord += lucid.height + spacingBuffer;
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}
}
