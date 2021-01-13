package com.bitdecay.lucidtext;

import flixel.math.FlxRect;
import com.bitdecay.lucidtext.parse.Regex;
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

	var bounds:FlxRect;
	var margins:Float = 0.0;

	public static var textMakerFunc:(text:String, x:Float, y:Float, size:Int) -> FlxText;

	var parser:Parser;

	private var activeEffects:Array<EffectUpdater> = new Array<EffectUpdater>();
	var allChars:Array<FlxText>;

	public var rawText(default, null):String;
	public var renderText(default, null):String;

	var fontSize:Int;

	var effectUpdateSuccess:Bool = true;

	var wordStarts:Array<Int> = [];
	var wordLengths:Map<Int, Int> = [];
	var pageBreaks:Array<Int> = [];

	public function new(bounds:FlxRect, text:String, fontSize:Int, margins:Float = 0.0) {
		super(bounds.left, bounds.top);
		this.bounds = bounds;
		this.fontSize = fontSize;
		this.margins = margins;

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

			var letter = textMakerFunc(renderText.charAt(i), x + margins, 0 + margins, fontSize);
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

		wrap();
	}

	private function wrap() {
		for (i in 0...renderText.length) {
			// not terribly efficient, but will suffice for now
			for (fx in parser.effects) {
				if (fx.impacts(i) && fx.startTag.tag == "page") {
					pageBreaks.push(i);
					shuffleCharactersToNextRow(i);
					break;
				}
			}
		}
		var matcher = new EReg(Regex.WORD_REGEX, Regex.GLOBAL_MODE);
		var continuousStarts:Array<Int> = [];
		var continuousLengths:Map<Int, Int> = [];
		matcher.map(renderText, (m) -> {
			continuousStarts.push(m.matchedPos().pos);
			continuousLengths.set(m.matchedPos().pos, m.matchedPos().len);
			return m.matched(0);
		});

		var wordMatcher = new EReg(Regex.WORD_NO_PUNC_REGEX, Regex.GLOBAL_MODE);

		for (start in continuousStarts) {
			// match indivial words for nicer callback values
			wordMatcher.map(renderText, (m) -> {
				wordStarts.push(m.matchedPos().pos);
				wordLengths.set(m.matchedPos().pos, m.matchedPos().len);
				return m.matched(0);
			});

			for (k in start...start + continuousLengths[start]) {
				if (allChars[k].text == " ") {
					// don't let spaces cause line breaks
					continue;
				}

				if (allChars[k].x + allChars[k].width > bounds.right - margins) {
					shuffleCharactersToNextRow(start);
					break;
				}
			}
		}
	}

	private function shuffleCharactersToNextRow(begin:Int) {
		var xCoord = x + margins;
		// this likely isn't a great value to use, we want the "base" line size for the font
		// Namely, if  line break happens on a 'bigger' or 'smaller' character, this value
		// is not correct.
		var yCoordOffset = allChars[begin].height;
		var xCoordOffset = allChars[begin].x - xCoord;
		for (i in begin...allChars.length) {
			for (pb in pageBreaks) {
				if (i == pb) {
					// reset our x coord as we added a line break for this
					xCoordOffset = allChars[i].x - xCoord;
					break;
				}
			}
			allChars[i].x -= xCoordOffset;
			allChars[i].y += yCoordOffset;
		}
		return yCoordOffset;
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
