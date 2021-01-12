package com.bitdecay.lucidtext;

import com.bitdecay.lucidtext.parse.TagLocation;
import openfl.geom.Rectangle;
import flixel.FlxSprite;
import flixel.math.FlxRect;
import flixel.addons.ui.FlxUI9SliceSprite;
import com.bitdecay.lucidtext.parse.Regex;

class TypingGroup extends TextGroup {
	var options:TypeOptions;

	var position:Int = 0;
	var elapsed:Float = 0.0;
	var calcedTimePerChar:Float = 0.0;

	var window:FlxSprite;
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

	public function new(bounds:FlxRect, text:String, ops:TypeOptions) {
		this.bounds = bounds;
		options = ops;
		pageBreaks = [];
		super(bounds, text, options.fontSize, ops.margins);
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

		for (c in allChars) {
			c.visible = false;
			c.y += options.margins;
			c.x += options.margins;
		}

		buildPages();

		if (options.windowAsset != null) {
			if (options.slice9 != null) {
				var window9Slice = new FlxUI9SliceSprite(0, 0, options.windowAsset, new Rectangle(0, 0, 50, 50), [4, 4, 12, 12]);
				window9Slice.resize(bounds.width, bounds.height);
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

		if (options.nextIconMaker != null) {
			nextPageIcon = options.nextIconMaker();
			add(nextPageIcon);
			nextPageIcon.setPosition(bounds.right - 40, bounds.bottom - 40);
			nextPageIcon.visible = false;
		}
	}

	private function buildPages() {
		for (i in 0...allChars.length) {
			if (allChars[i].y + allChars[i].height > bounds.bottom - margins) {
				newPage(i);
				continue;
			}

			for (pageIndex in pageBreaks) {
				if (i == pageIndex) {
					newPage(i);
					break;
				}
			}
		}
	}

	private function newPage(index:Int) {
		// start new page
		pageBreaks.push(index);
		var yOffset = allChars[index].y - (y + margins);
		for (n in index...allChars.length) {
			// reset any y we've added to bring things back to the top
			allChars[n].y -= yOffset;
		}
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
					if (finishCallback != null) {
						finishCallback();
					}
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
					wordCallback(renderText.substr(position, wordLengths.get(position)));
				}
			}

			// TODO: This should be done via map accesses instead of looping
			for (fxRange in parser.effects) {
				if (fxRange.startTag.position == position) {
					fxRange.effect.begin(options.modOps);
					if (tagCallback != null) {
						tagCallback(fxRange.startTag);
					}
				}
			}

			position++;

			// TODO: This should be done via map accesses instead of looping
			for (fxRange in parser.effects) {
				if (fxRange.endTag.position == position + 1) {
					fxRange.effect.end(options.modOps);
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
			}
		}
	}
}
