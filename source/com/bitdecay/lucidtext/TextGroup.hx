package com.bitdecay.lucidtext;

import misc.FlxTextFactory;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;

class TextGroup extends FlxSpriteGroup {

	public static var textMakerFunc:(text:String, x:Float, y:Float, size:Int) -> FlxText;

	public function new(?X:Float, ?Y:Float, text:String, size:Int = 24) {
		super(X, Y, text.length);


		// this may be based on the default size of the font (is it 6 for the default font?)
		var spacingMod = -(size/6.0);


		trace('Spacing for font size ${size} is ${spacingMod}');

		spacingMod = -4;

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
			letter.update(0.1);
			x += letter.width + spacingMod;

			for (fx in parser.effects) {
				if (fx.impacts(i)) {
					fx.effect.apply(letter, i);
				}
			}

			add(letter);
		}
	}
}
