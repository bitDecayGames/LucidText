package com.bitdecay.lucidtext;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;

class TextGroup extends FlxSpriteGroup {
	public function new(?X:Float, ?Y:Float, text:String) {
		super(X, Y, text.length);
		var spacingMod = -2;

		var tags = Parser.parseText(text);
		var strippedText = Parser.getStrippedText(text);

		var x = 0.0;
		for (i in 0...strippedText.length) {
			var letter = new FlxText(x, 0, text.charAt(i), 24);
			letter.update(0.1);
			x += letter.width + spacingMod;
			add(letter);
			// FlxTween.linearMotion(letter, letter.x, letter.y, letter.x, letter.y + 30, 0.8,
			// 	{ type: FlxTweenType.PINGPONG, ease: FlxEase.sineInOut, startDelay: i * 0.2 });
		}
	}
}
