package com.bitdecay.lucidtext;

import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import com.bitdecay.lucidtext.parse.Parser;
import com.bitdecay.lucidtext.effect.Effect.EffectUpdater;

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
	var allChars:Array<FlxText>;

	var rawText:String;
	var renderText:String;

	var fontSize:Int;

	var effectUpdateSuccess:Bool = true;

	public function new(?X:Float, ?Y:Float, text:String, fontSize:Int) {
		super(X, Y);
		this.fontSize = fontSize;

		allChars = new Array<FlxText>();
		loadText(text);
	}

	public function loadText(text:String) {
		// TODO: Do we have to worry about this? Likely better to have a pool instead of a complete refresh
		clear();
		while (allChars.length > 0) {
			allChars.pop();
		}

		rawText = text;

		parser = new Parser(text);
		parser.parse();
		renderText = parser.getStrippedText();

		var x = 0.0;
		for (i in 0...renderText.length) {
			if (textMakerFunc == null) {
				textMakerFunc = (text, x, y, fontSize) -> {
					return new FlxText(x, y, text, fontSize);
				}
			}

			var letter = textMakerFunc(renderText.charAt(i), x, 0, fontSize);
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

			allChars.push(letter);
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
