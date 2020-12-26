package com.bitdecay.lucidtext;

import flixel.util.FlxArrayUtil;
import flixel.text.FlxText;
import openfl.geom.Rectangle;
import flixel.addons.ui.FlxUI9SliceSprite;
import com.bitdecay.lucidtext.parse.Regex;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.math.FlxRect;

class TypingGroup extends TextGroup {
	var options:TypeOptions;

	var position:Int = 0;
	var elapsed:Float = 0.0;
	var calcedTimePerChar:Float = 0.0;

	var bounds:FlxRect;
	var window:FlxSprite;

	var wordStarts:Array<Int> = [];
	var wordLengths:Map<Int, Int> = [];

	public var letterCallback:() -> Void;
	public var wordCallback:() -> Void;
	public var finishCallback:() -> Void;

	public function new(box:FlxRect, text:String, ops:TypeOptions, fontSize:Int) {
		options = ops;
		bounds = box;
		super(box.left, box.top, text, fontSize);
	}

	override public function loadText(text:String) {
		super.loadText(text);
		position = 0;
		elapsed = 0;
		FlxArrayUtil.clearArray(wordStarts);

		if (options.slice9 != null) {
			var window9Slice = new FlxUI9SliceSprite(0, 0, AssetPaths.slice__png, new Rectangle(0, 0, 50, 50), [4, 4, 12, 12]);
			window9Slice.resize(bounds.width, bounds.height);
			window = window9Slice;
		} else {
			window = new FlxSprite(options.windowAsset);
		}

		for (c in allChars) {
			c.visible = false;
			c.y += options.margins;
			c.x += options.margins;
		}

		organizeTextToRect();

		// We want the preAdd stuff of the FlxSpriteGroup...
		add(window);
		// ...but we also want the backing to be at index zero
		members.remove(window);
		members.insert(0, window);
	}

	private function organizeTextToRect() {
		var wordMatcher = new EReg(Regex.WORD_REGEX, Regex.GLOBAL_MODE);
		wordMatcher.map(renderText, (m) -> {
			wordStarts.push(m.matchedPos().pos);
			wordLengths.set(m.matchedPos().pos, m.matchedPos().len);
			return m.matched(0);
		});

		for (start in wordStarts) {
			for (k in start...start + wordLengths[start]) {
				if (allChars[k].x + allChars[k].width > bounds.right - options.margins) {
					shuffleCharactersToNextRow(start);
					break;
				}
			}
		}
	}

	private function shuffleCharactersToNextRow(begin:Int) {
		var xCoord = x + options.margins;
		// this likely isn't a great value to use, we want the "base" line size for the font
		// Namely, if  line break happens on a 'bigger' or 'smaller' character, this value
		// is not correct.
		var yCoordOffset = allChars[begin].height;
		for (i in begin...allChars.length) {
			allChars[i].x = xCoord;
			allChars[i].y += yCoordOffset;
			xCoord += allChars[i].width + TextGroup.spacingMod;
		}
	}

	override public function update(delta:Float) {
		super.update(delta);

		if (!effectUpdateSuccess) {
			// wait till all effects are success before continuing
			return;
		}

		if (options.charsPerSecond <= 0) {
			calcedTimePerChar = 0;
		} else {
			calcedTimePerChar = 1 / options.charsPerSecond;
		}

		elapsed += delta;
		while (elapsed > calcedTimePerChar && position < allChars.length) {
			elapsed -= calcedTimePerChar;
			allChars[position].visible = true;
			position++;

			// TODO: This should be done via map accesses instead of looping
			for (fxRange in parser.effects) {
				if (fxRange.startIndex == position - 1) {
					fxRange.effect.begin(options);
				}

				if (fxRange.endIndex == position - 1) {
					fxRange.effect.end(options);
				}
			}

			if (letterCallback != null) {
				letterCallback();
			}
			// our border image is our 0th position, so sub one to get proper string index
			if (wordLengths.exists(position - 1)) {
				if (wordCallback != null) {
					wordCallback();
				}
			}
		}

		if (position == allChars.length) {
			position++;
			if (finishCallback != null) {
				finishCallback();
			}
		}
	}
}
