package com.bitdecay.lucidtext;

import flixel.math.FlxPoint;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxRect;
import com.bitdecay.lucidtext.parse.Regex;
import flixel.text.FlxBitmapText;
import com.bitdecay.lucidtext.pool.LucidPooledText;
import com.bitdecay.lucidtext.parse.Parser;
import com.bitdecay.lucidtext.effect.Effect.EffectUpdater;

/**
 * A group that holds all FlxBitmapText objects. This handles parsing the user
 * string and applying all effects to the appropriate characters
**/
class TextGroup extends FlxSpriteGroup {
	public static var textMakerFunc:(text:String, x:Float, y:Float, size:Int) -> FlxBitmapText;
	public static var defaultScrollFactor:FlxPoint = null;

	var bounds:FlxRect;
	var margins:Float = 0.0;


	var parser:Parser;


	private var activeEffects:Array<EffectUpdater> = new Array<EffectUpdater>();
	var allChars:Array<FlxBitmapText>;

	public var rawText(default, null):String;
	public var renderText(default, null):String;

	var fontSize:Int;

	var effectUpdateSuccess:Bool = true;

	var wordStarts:Array<Int> = [];
	var wordLengths:Map<Int, Int> = [];
	var lineBreaks:Array<Int> = [];
	var pageBreaks:Array<Int> = [];

	public function new(bounds:FlxRect, text:String, fontSize:Int, margins:Float = 0.0) {
		super();
		this.bounds = bounds;
		this.fontSize = fontSize;
		this.margins = margins;

		if (TextGroup.defaultScrollFactor != null) {
			scrollFactor.copyFrom(TextGroup.defaultScrollFactor);
		}

		allChars = new Array<FlxBitmapText>();
		loadText(text);
	}

	public function put() {
		for (text in allChars) {
			if (Std.is(text, LucidPooledText)) {
				cast(text, LucidPooledText).put();
			}
		}
		kill();
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

		var x = bounds.x + margins;
		var y = bounds.y + margins;
		for (i in 0...renderText.length) {
			if (textMakerFunc == null) {
				textMakerFunc = (text, x, y, fontSize) -> {
					return LucidPooledText.get(x, y, text, fontSize);
				}
			}

			var letter = textMakerFunc(renderText.charAt(i), x, y, fontSize);
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
			if (letter.text == " ") {
				x += letter.font.spaceWidth * letter.scale.x;
			} else {
				// the charAdvance gives a much more accurate size of the charcter
				x += letter.font.getCharAdvance(letter.text.charCodeAt(0)) * letter.scale.x;
			}

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
					// mark 'k' as a line break so we can use that data for figuring out line spacing
					shuffleCharactersToNextRow(start);
					break;
				}
			}
		}
	}

	private function shuffleCharactersToNextRow(lineBreakPos:Int) {
		lineBreaks.push(lineBreakPos);

		// sort our breaks to makes sure previously added page-breaks are taken into account
		lineBreaks.sort((a, b) -> {
			return a - b;
		});

		var start = 0;
		var end = lineBreakPos;
		var endIndex = lineBreaks.indexOf(lineBreakPos);
		if (endIndex > 0) {
			start = lineBreaks[endIndex-1];
		}

		if (end <= start) {
			// a single word is longer than our field, can't really handle this
			return 0.0;
		}

		var yCoordOffset = 0.0;

		// TODO: We need to figure out the best way to handle this. It seems as though the best option
		// is _ACTUALLY_ to build a row, then retro-actively look at its max height and space it accordingly
		// to fit nicely
		var heightTotal = 0.0;
		for (i in start...end) {
			heightTotal += allChars[i].height * allChars[i].scale.y;
		}
		yCoordOffset = heightTotal / (end-start);


		var xCoord = bounds.x + margins;
		// this likely isn't a great value to use, we want the "base" line size for the font
		// Namely, if  line break happens on a 'bigger' or 'smaller' character, this value
		// is not correct.
		// var yCoordOffset = allChars[lineBreakPos].height;
		var xCoordOffset = allChars[lineBreakPos].x - xCoord;
		for (i in lineBreakPos...allChars.length) {
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
