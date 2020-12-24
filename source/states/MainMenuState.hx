package states;

import flixel.FlxObject;
import com.bitdecay.lucidtext.TextGroup;
import flixel.FlxState;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class MainMenuState extends FlxState {
	var _txtTitle:FlxObject;

	override public function create():Void {
		super.create();

		_txtTitle = new TextGroup(0, 100, "<wave><bigger>LucidText</bigger></wave>");
		add(_txtTitle);

		var menuItems = [
			"Samples" => () -> FlxG.switchState(new EffectExamplesState()),
			"Spacing" => () -> FlxG.switchState(new SpacingCompareState()),
			"Typing" => () -> FlxG.switchState(new TypingState()),
		];

		var yCoord = FlxG.height / 2;
		for (buttonName => stateFunc in menuItems) {
			var _btn = createMenuButton(buttonName, stateFunc, yCoord);
			_btn.setPosition(FlxG.width / 2 - _btn.width / 2, yCoord);
			_btn.updateHitbox();
			yCoord += _btn.height + 10;
			add(_btn);
		}
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		_txtTitle.x = (FlxG.width - _txtTitle.width) / 2;
	}

	/**
	 * Creates a simple button with a label and a callback
	 *
	 * @param   Text           The text to display on the button
	 * @param   Callback       Function to be called when the button is clicked
	 */
	public static function createMenuButton(Text:String, Callback:Void->Void, yCoord:Float):FlxButton {
		var button = new FlxButton(0, yCoord, Text);
		button.allowSwiping = false;
		button.onOver.callback = function() {
			button.color = FlxColor.GRAY;
		};
		button.onOut.callback = function() {
			button.color = FlxColor.WHITE;
		};
		button.onUp.callback = function() {
			Callback();
		};

		return button;
	}
}
