package com.bitdecay.lucidtext;

import com.bitdecay.lucidtext.effect.Effect;
import com.bitdecay.lucidtext.effect.Wave;
import com.bitdecay.lucidtext.effect.Color;

class Parser {
	private static inline var TAG_OPEN = "<";
	private static inline var TAG_CLOSE = ">";
	private static inline var TAG_END = "/";

	private static var fxMap:Map<String, ()->Effect> = [
		"color" => () -> return new Color(),
		"wave" => () -> return new Wave(),
	];

	/**
	 * The position in the current text
	 */
	private var cursor:Int;

	/**
	 * The effective render position of the cursor only counting visible characters
	 */
	private var renderCursor:Int;

	var text:String;

	public var rawTags:Array<TagLocation> = [];
	public var effects:Array<EffectRange> = [];

	public function new(text:String) {
		this.text = text;
		renderCursor = 0;
		cursor = 0;
	}

	public function parse() {
		trace("parsing : '" + text + "'");
		trace("stripped: '" + getStrippedText() + "'");
		trace("           0    -    1    -    2    -    3");

		rawTags = getRawTags();

		for (tag in rawTags) {
			trace("found raw tag: " + tag.tag);
			trace("   at pos    : " + tag.position);
			trace("   raw pos   : " + tag.rawPosition);
			trace("   with opts : " + tag.options);
			trace("   closer    : " + tag.close);
		}

		effects = new Array<EffectRange>();

		for (i in 0...rawTags.length) {
			if (rawTags[i].close) {
				// we only scan for opening tags in the top loop
				continue;
			}
			for (k in i+1...rawTags.length) {
				if (rawTags[k].tag == rawTags[i].tag) {
					if (rawTags[k].close) {
						if (!fxMap.exists(rawTags[i].tag)) {
							trace("NO EFFECT EXISTS CALLED: " + rawTags[i].tag + ". This will be ignored");
							break;
						}
						var fx = new EffectRange(rawTags[i].position, rawTags[k].position, fxMap.get(rawTags[i].tag)());
						fx.effect.setProperties(parseOptions(rawTags[i].options));
						effects.push(fx);
						break;
					} else {
						throw "Currently this library doesn't handle nested tags with the same effect. Found tag '" +
								rawTags[k].tag + "' at position " + rawTags[k].rawPosition;
					}
				}
			}
		}

		for (fx in effects) {
			trace("Effect: " + fx.effect);
			trace("   applies to range    : " + fx.startIndex + " -> " + fx.endIndex);
		}
	}

	public function getRawTags():Array<TagLocation> {
		var allTags = new Array<TagLocation>();

		var tag:TagLocation = getNextTag();
		while (tag != null) {
			allTags.push(tag);
			tag = getNextTag();
		}

		return allTags;
	}

	public function getNextTag():TagLocation {
		for (i in cursor...text.length) {
			if (text.charAt(i) == TAG_OPEN) {
				for (k in i...text.length) {
					if (text.charAt(k) == TAG_CLOSE) {
						cursor = k + 1;
						var tagText = text.substr(i + 1, k - i - 1);
						var options = "";
						var closer = false;
						if (tagText.indexOf(" ") > 0) {
							options = tagText.substr(tagText.indexOf(" ") + 1);
							tagText = tagText.substring(0, tagText.indexOf(" "));
						}
						if (tagText.charAt(0) == TAG_END) {
							// TODO: We should go close our other open tags instead of creating a new one
							tagText = tagText.substr(1);
							closer = true;
						}
						// if this is a closing tag, subtract 1 to account for '<'
						return new TagLocation(renderCursor + (closer ? -1 : 0), i, tagText, options, closer);
					}
				}
			} else {
				// not dealing with a tag, move our render cursor
				renderCursor++;
			}
		}
		cursor = text.length;
		return null;
	}

	public function getStrippedText():String {
		var stripped = new String(text);
		var position = 0;
		while (position < stripped.length) {
			if (stripped.charAt(position) == "<") {
				for (k in position...stripped.length) {
					if (stripped.charAt(k) == ">") {
						trace("Stripping: '" + stripped.substring(position, k+1));
						stripped = stripped.substring(0, position) + stripped.substr(k + 1);
						trace("left with: '" + stripped + "'");
						break;
					}
				}
			} else {
				// only increment position if we aren't dealing with a tag
				position++;
			}
		}
		return stripped;
	}

	private function parseOptions(raw:String):Dynamic {
		var allOps:haxe.DynamicAccess<Dynamic> = {};
		for (op in raw.split(" ")) {
			var splits = op.split("=");
			allOps.set(splits[0], splits[1]);
		}
		trace("Our dynamic object: " + allOps);
		return allOps;
	}
}
