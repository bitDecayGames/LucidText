package com.bitdecay.lucidtext;

import com.bitdecay.lucidtext.effect.Effect.EffectUpdater;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import com.bitdecay.lucidtext.parse.Parser;

/**
 * A group that holds all FlxText objects. This handles parsing the user
 * string and applying all effects to the appropriate characters
**/
class TextGroup extends FlxSpriteGroup {
	// It seems that there is a 2-pixel buffer on each side, so we will shave off 4 pixels of each
	// letter to account for that tested and working with various fonts and font sizes
	public static inline var spacingMod = -4;

	public static var textMakerFunc:(text:String, x:Float, y:Float, size:Int) -> FlxText;

	var parser:Parser;

	private var activeEffects:Array<EffectUpdater> = new Array<EffectUpdater>();

	var rawText:String;
	var renderText:String;

	var effectUpdateSuccess:Bool = true;

	public function new(?X:Float, ?Y:Float, text:String, size:Int = 24) {
		super(X, Y, text.length);

		rawText = text;

		parser = new Parser(text);
		parser.parse();
		renderText = parser.getStrippedText();

		var x = 0.0;
		for (i in 0...renderText.length) {
			if (textMakerFunc == null) {
				textMakerFunc = (text, x, y, size) -> {
					return new FlxText(x, y, text, size);
				}
			}

			var letter = textMakerFunc(renderText.charAt(i), x, 0, size);
			// autoSize is why all the alignment works, so we need this enabled for this lib to work
			letter.autoSize = true;

			letter.wordWrap = false;

			var active:EffectUpdater;
			for (fx in parser.effects) {
				if (fx.impacts(i)) {
					active = fx.effect.apply(letter, i);
					if (active != null) {
						activeEffects.push(active);
					}
				}
			}

			// Adjust spacing only after all effects are applied
			x += letter.width + spacingMod;

			add(letter);
		}
	}

	override public function update(delta:Float) {
		super.update(delta);
		effectUpdateSuccess = true;
		for (updater in activeEffects) {
			if (!updater(delta)) {
				effectUpdateSuccess = false;
			}
		}
	}
}
