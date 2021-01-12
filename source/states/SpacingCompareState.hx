package states;

import flixel.math.FlxRect;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.FlxG;
import misc.FlxTextFactory;
import flixel.FlxState;
import com.bitdecay.lucidtext.TextGroup;

class SpacingCompareState extends FlxState {
	override public function create():Void {
		super.create();
		bgColor = FlxColor.WHITE;

		// FlxTextFactory.defaultFont = AssetPaths.Brain_Slab_8__ttf;
		FlxTextFactory.defaultColor = FlxColor.BLACK;
		TextGroup.textMakerFunc = FlxTextFactory.makeSimple;

		FlxG.autoPause = false;

		var y = 100.0;
		for (i in 1...7) {
			y = makeSpacingTest(i * 6, y);
		}

		var button = new FlxButton(0, 0, "Back");
		button.onUp.callback = function() {
			FlxG.switchState(new MainMenuState());
		};
		button.y = FlxG.height - button.height;
		add(button);
	}

	private function makeSpacingTest(size:Int, yCoord:Float) {
		var textRef = FlxTextFactory.make('Welcome to LucidText! size ${size} (FlxText)', 30, yCoord, size);
		add(textRef);
		yCoord += textRef.height;
		var lucid = new TextGroup(FlxRect.get(30, yCoord, FlxG.width, 100), 'Welcome to <wave>LucidText!</wave> size ${size} (Lucid)', size);
		add(lucid);
		return yCoord + lucid.height;
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}
}
