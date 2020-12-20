package com.bitdecay.lucidtext;

import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import com.bitdecay.lucidtext.parse.Parser;

/**
 * A group that holds all FlxText objects. This handles parsing the user
 * string and applying all effects to the appropriate characters
**/
class TextGroup extends FlxSpriteGroup {
	public static var textMakerFunc:(text:String, x:Float, y:Float, size:Int) -> FlxText;

	private var activeEffects:Array<ActiveFX> = new Array<ActiveFX>();

	public function new(?X:Float, ?Y:Float, text:String, size:Int = 24) {
		super(X, Y, text.length);

		// It seems that there is a 2-pixel buffer on each side, so we will shave off 4 pixels of each
		// letter to account for that tested and working with various fonts and font sizes
		var spacingMod = -4;

		var parser = new Parser(text);
		parser.parse();
		var strippedText = parser.getStrippedText();

		var x = 0.0;
		for (i in 0...strippedText.length) {
			if (textMakerFunc == null) {
				textMakerFunc = (text, x, y, size) -> {
					return new FlxText(x, y, text, size);
				}
			}

			var letter = textMakerFunc(strippedText.charAt(i), x, 0, size);
			// autoSize is why all the alignment works, so we need this enabled for this lib to work
			letter.autoSize = true;

			letter.wordWrap = false;

			var active:ActiveFX;
			for (fx in parser.effects) {
				if (fx.impacts(i)) {
					active = fx.effect.apply(letter, i);
					if (active != null) {
						activeEffects.push(active);
					}
				}
			}

			// Adjust spacing after all effects are applied
			x += letter.width + spacingMod;

			// Note that groups appear to store members in an array, so this should already be ordered
			add(letter);
		}
	}

	override public function update(delta:Float) {
		super.update(delta);
		for (fx in activeEffects) {
			fx.update(delta);
		}
	}
}
