package com.bitdecay.lucidtext;

import com.bitdecay.lucidtext.effect.EffectRange;
import com.bitdecay.lucidtext.parse.TagLocation;
import flixel.FlxSprite;
import flixel.math.FlxRect;
import flixel.addons.display.FlxSliceSprite;

class TypingGroup extends TextGroup {
	var options:TypeOptions;

	var position:Int = 0;
	var checkInitialChar = false;

	var elapsed:Float = 0.0;
	var calcedTimePerChar:Float = 0.0;

	public var window:FlxSprite;
	var nextPageIcon:FlxSprite;

	/**
	 * Called each time a character is made visible
	**/
	public var letterCallback:() -> Void;

	/**
	 * Called each time the first character of a 'word' is made visible
	**/
	public var wordCallback:(word:String) -> Void;

	public var pageCallback:() -> Void;

	/**
	 * Called each time a tag is encountered
	**/
	public var tagCallback:(tag:TagLocation) -> Void;

	/**
	 * Called when the text has finished being made visible
	**/
	public var finishCallback:() -> Void;

	// Status variables, accessible from outside
	public var waitingForConfirm(default, null):Bool = false;
	public var finished(default, null):Bool = false;

	var fxByStart:Map<Int, Array<EffectRange>> = [];
	var fxByEnd:Map<Int, Array<EffectRange>> = [];

	public function new(bounds:FlxRect, text:String, ops:TypeOptions) {
		this.bounds = bounds;
		options = ops;
		super(bounds, text, options.fontSize, ops.margins);
	}

	override public function loadText(text:String) {
		super.loadText(text);
		setupTagMaps();
		checkInitialChar = true;
		position = 0;
		elapsed = 0;
		finished = false;

		for (c in allChars) {
			c.visible = false;
		}

		buildPages();

		if (options.windowAsset != null) {
			if (options.slice9 != null) {
				var sliceRect = FlxRect.get(
					options.slice9[0],
					options.slice9[1],
					options.slice9[2],
					options.slice9[3]
				);
				var window9Slice = new FlxSliceSprite(options.windowAsset, sliceRect, bounds.width, bounds.height);
				window9Slice.x = bounds.x;
				window9Slice.y = bounds.y;
				window = window9Slice;
			} else {
				window = new FlxSprite(options.windowAsset);
			}

			// We want the preAdd stuff of the FlxSpriteGroup...
			add(window);
			// ...but we also want the backing to be at index zero
			// so it renders underneath all the text objects
			members.remove(window);
			members.insert(0, window);
		}

		if (nextPageIcon == null && options.nextIconMaker != null) {
			nextPageIcon = options.nextIconMaker();
		}

		if (nextPageIcon != null) {
			nextPageIcon.setPosition(bounds.right - margins[3] - nextPageIcon.width, bounds.bottom - margins[1] - nextPageIcon.height);
			nextPageIcon.visible = false;
			add(nextPageIcon);
		}
	}

	private function setupTagMaps() {
		fxByStart.clear();
		fxByEnd.clear();

		for (range in parser.effects) {
			var startPos = range.startTag.position;
			var endPos = range.endTag.position;
			if (!fxByStart.exists(startPos)) {
				fxByStart.set(startPos, []);
			}
			if (!fxByEnd.exists(endPos)) {
				fxByEnd.set(endPos, []);
			}

			fxByStart.get(startPos).push(range);
			fxByEnd.get(endPos).push(range);
		}
	}

	private function buildPages() {
		for (i in 0...allChars.length) {
			if (allChars[i].y + allChars[i].height > bounds.bottom - margins[1]) {
				newPage(i);
				continue;
			}

			for (charIndex in pageBreaks) {
				if (i == charIndex) {
					newPage(i, false);
					break;
				}
			}
		}
	}

	private function newPage(index:Int, push:Bool = true) {
		// start new page
		if (push) {
			pageBreaks.push(index);
		}
		var yOffset = allChars[index].y - (bounds.y + margins[0]);
		for (n in index...allChars.length) {
			// reset any y we've added to bring things back to the top
			allChars[n].y -= yOffset;
		}
	}

	private function checkForPageBreak():Bool {
		// TODO: Can optimize this so we only check the next known pageBreak mark
		for (pageMark in pageBreaks) {
			if (position == pageMark && !waitingForConfirm) {
				waitingForConfirm = true;
				if (nextPageIcon != null) {
					nextPageIcon.visible = true;
				}
				return true;
			}
		}
		return false;
	}

	override public function update(delta:Float) {
		if (finished) {
			return;
		}

		if (checkInitialChar) {
			// We need to do this check once up front
			if (fxByStart.exists(position)) {
				for (fxRange in fxByStart.get(position)) {
					if (fxRange.startTag.void) {
						fxRange.effect.begin(options.modOps);
						if (tagCallback != null) {
							tagCallback(fxRange.startTag);
						}
					}
				}
			}
			checkInitialChar = false;
		}

		super.update(delta);

		if (!effectUpdateSuccess) {
			// wait till all effects are success before continuing
			return;
		}

		calcedTimePerChar = options.getTimePerCharacter();
		elapsed -= options.modOps.delay;
		options.modOps.delay = 0;

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
					if (finishCallback != null) {
						finishCallback();
					}
					return;
				}
				for (i in 0...position) {
					// clear out previous characters
					allChars[i].visible = false;
				}
			}

			return;
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
					wordCallback(renderText.substr(position, wordLengths.get(position)));
				}
			}

			if (fxByStart.exists(position)) {
				for (fxRange in fxByStart.get(position)) {
					if (!fxRange.startTag.void) {
						// only handle non-void tags here
						fxRange.effect.begin(options.modOps);
						if (tagCallback != null) {
							tagCallback(fxRange.startTag);
						}
					}
				}
			}

			position++;

			if (fxByEnd.exists(position)) {
				for (fxRange in fxByEnd.get(position)) {
					if (!fxRange.endTag.void) {
						fxRange.effect.end(options.modOps);
					} else {
						// this explicitly handles void tags as we hit new positions rather than as we 'leave' them
						fxRange.effect.begin(options.modOps);
					}
					if (tagCallback != null) {
						tagCallback(fxRange.endTag);
					}
				}
			}

			if (position == allChars.length) {
				waitingForConfirm = true;
				if (nextPageIcon != null) {
					nextPageIcon.visible = true;
				}
				return;
			}

			if (checkForPageBreak()) {
				return;
			}
		}
	}
}
