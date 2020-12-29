package com.bitdecay.lucidtext;

import openfl.geom.Rectangle;
import flixel.addons.ui.FlxUI9SliceSprite;
import com.bitdecay.lucidtext.parse.Regex;
import flixel.FlxSprite;
import flixel.math.FlxRect;

class TypingGroup extends TextGroup {
	var options:TypeOptions;

	var position:Int = 0;
	var elapsed:Float = 0.0;
	var calcedTimePerChar:Float = 0.0;

	var bounds:FlxRect;
	var window:FlxSprite;
	var nextPageIcon:FlxSprite;

	var pageBreaks:Array<Int>;

	var wordStarts:Array<Int> = [];
	var wordLengths:Map<Int, Int> = [];

	/**
	 * Called each time a character is made visible
	**/
	public var letterCallback:() -> Void;

	/**
	 * Called each time the first character of a 'word' is made visible
	**/
	public var wordCallback:() -> Void;

	public var pageCallback:() -> Void;

	/**
	 * Called when the text has finished being made visible
	**/
	public var finishCallback:() -> Void;

	// Status variables, accessible from outside
	public var waitingForConfirm(default, null):Bool = false;
	public var finished(default, null):Bool = false;

	public function new(box:FlxRect, text:String, ops:TypeOptions, fontSize:Int) {
		options = ops;
		bounds = box;
		pageBreaks = [];
		super(box.left, box.top, text, fontSize);
	}

	override public function loadText(text:String) {
		super.loadText(text);
		position = 0;
		elapsed = 0;
		finished = false;
		while (wordStarts.length > 0) {
			wordStarts.pop();
		}
		while (pageBreaks.length > 0) {
			pageBreaks.pop();
		}

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

		buildPages();

		// We want the preAdd stuff of the FlxSpriteGroup...
		add(window);
		// ...but we also want the backing to be at index zero
		members.remove(window);
		members.insert(0, window);

		if (options.nextIconMaker != null) {
			nextPageIcon = options.nextIconMaker();
			add(nextPageIcon);
			nextPageIcon.setPosition(bounds.right - 40, bounds.bottom - 40);
			nextPageIcon.visible = false;
		}
	}

	private function buildPages() {
		var wordMatcher = new EReg(Regex.WORD_REGEX, Regex.GLOBAL_MODE);
		wordMatcher.map(renderText, (m) -> {
			wordStarts.push(m.matchedPos().pos);
			wordLengths.set(m.matchedPos().pos, m.matchedPos().len);
			return m.matched(0);
		});

		var yRowModTotal = 0.0;
		for (start in wordStarts) {
			for (k in start...start + wordLengths[start]) {
				if (allChars[k].x + allChars[k].width > bounds.right - options.margins) {
					yRowModTotal += shuffleCharactersToNextRow(start);
					if (allChars[start].y + allChars[start].height > bounds.bottom - options.margins) {
						// start new page
						pageBreaks.push(start);
						for (n in start...allChars.length) {
							// reset any y we've added to bring things back to the top
							allChars[n].y -= yRowModTotal;
						}
						yRowModTotal = 0.0;
					}
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
		return yCoordOffset;
	}

	private function checkForPageBreak() {
		// TODO: Can optimize this so we only check the next known pageBreak mark
		for (pageMark in pageBreaks) {
			if (position == pageMark && !waitingForConfirm) {
				waitingForConfirm = true;
				if (nextPageIcon != null) {
					nextPageIcon.visible = true;
				}
			}
		}
	}

	override public function update(delta:Float) {
		super.update(delta);

		if (finished) {
			return;
		}

		if (!effectUpdateSuccess) {
			// wait till all effects are success before continuing
			return;
		}

		calcedTimePerChar = options.getTimePerCharacter();

		checkForPageBreak();

		if (waitingForConfirm) {
			if (options.checkPageConfirm(delta)) {
				waitingForConfirm = false;
				if (nextPageIcon != null) {
					nextPageIcon.visible = false;
				}
				if (position == allChars.length) {
					// no addition work if we are at the end of the string
					// just leave things how they are
					finished = true;
					return;
				}
				for (i in 0...position) {
					// clear out previous characters
					allChars[i].visible = false;
				}
				elapsed = calcedTimePerChar - delta;
			} else {
				return;
			}
		}

		elapsed += delta;
		while (elapsed >= calcedTimePerChar && position < allChars.length) {
			elapsed -= calcedTimePerChar;
			allChars[position].visible = true;

			// TODO: Is this trim a performance concern?
			if (StringTools.trim(allChars[position].text) != "" && letterCallback != null) {
				letterCallback();
			}

			if (wordLengths.exists(position)) {
				if (wordCallback != null) {
					wordCallback();
				}
			}

			// TODO: This should be done via map accesses instead of looping
			for (fxRange in parser.effects) {
				if (fxRange.startIndex == position) {
					fxRange.effect.begin(options.modOps);
				}
			}

			position++;

			// TODO: This should be done via map accesses instead of looping
			for (fxRange in parser.effects) {
				if (fxRange.endIndex == position + 1) {
					fxRange.effect.end(options.modOps);
				}
			}

			if (position == allChars.length) {
				waitingForConfirm = true;
				if (nextPageIcon != null) {
					nextPageIcon.visible = true;
				}
				if (finishCallback != null) {
					finishCallback();
				}
			}
		}
	}
}
