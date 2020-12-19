package com.bitdecay.lucidtext;

import com.bitdecay.lucidtext.ParseContext;

class Parser {
	// Need to parse string
	// take out all tags, transforming them into positional effects that need to be applied
	// create each letter with appropriate effects
	// NOTE: We may be able to 'join' characters together that don't need to be separate for an effect
	var tags = {
		"wave": null
	}

	public static function parseText(text:String):Array<TagLocation> {
		var allTags = new Array<TagLocation>();
		var context = new ParseContext(text);

		var tag:TagLocation = context.getNextTag();
		while (tag != null) {
			allTags.push(tag);
			tag = context.getNextTag();
		}

		trace("parsing : '" + text + "'");
		trace("stripped: '" + getStrippedText(text) + "'");
		trace("           0    -    1    -    2    -    3");

		for (tag in allTags) {
			trace("found tag: " + tag.tag);
			trace("   at pos   : " + tag.position);
			trace("   raw pos  : " + tag.rawPosition);
			trace("   with opts: " + tag.options);
			trace("   closer   : " + tag.close);
		}

		// TODO: Loop through our raw tag locations and turn them into a "tagged range"
		//       which should have a start and end, and what effect should be applied.

		return allTags;
	}

	public static function getStrippedText(text:String):String {
		var position = 0;
		while (position < text.length) {
			if (text.charAt(position) == "<") {
				for (k in position...text.length) {
					if (text.charAt(k) == ">") {
						text = text.substring(0, position) + text.substr(k + 1);
					}
				}
			}
			position++;
		}
		return text;
	}
}
