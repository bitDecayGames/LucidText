package;

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

		makeExampleTest("<scrub>Scrub</scrub>");
		makeExampleTest("<wave>Wave</wave>");
		makeExampleTest("<color c=0xFF4400>Color</color>");
		makeExampleTest("<shake>Shake</shake>");
		makeExampleTest("<smaller>Smaller</smaller>");
		makeExampleTest("<bigger>Bigger</bigger>");
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
