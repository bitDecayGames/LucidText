package com.bitdecay.lucidtext.parse;

import com.bitdecay.lucidtext.effect.Effect;
import com.bitdecay.lucidtext.effect.EffectRange;
import com.bitdecay.lucidtext.effect.EffectRegistry;

/**
 * Handles parsing a string with HTML-style effect tags
**/
class Parser {
	private var originalText:String;
	private var iter:TextIterator;

	public var rawTags:Array<TagLocation> = [];
	public var effects:Array<EffectRange> = [];

	public function new(text:String) {
		originalText = text;
		iter = new TextIterator(text);
	}

	public function parse() {
		rawTags = iter.getAllTags();

		#if lucid_debug
		trace("parsing : '" + originalText + "'");
		trace("stripped: '" + getStrippedText() + "'");
		trace("           0    -    1    -    2    -    3");

		for (tag in rawTags) {
			trace("found raw tag: " + tag.tag);
			trace("   at pos    : " + tag.position);
			trace("   raw pos   : " + tag.rawPosition);
			trace("   with opts : " + tag.options);
			trace("   closer    : " + tag.close);
		}
		#end

		effects = new Array<EffectRange>();

		for (i in 0...rawTags.length) {
			if (rawTags[i].close) {
				// we only scan for opening tags in the top loop
				continue;
			}
			for (k in i + 1...rawTags.length) {
				if (rawTags[k].tag == rawTags[i].tag) {
					if (rawTags[k].close) {
						var fxMaker = EffectRegistry.get(rawTags[i].tag);
						if (fxMaker == null) {
							break;
						}
						var fx = new EffectRange(rawTags[i].position, rawTags[k].position, EffectRegistry.get(rawTags[i].tag)());
						var options = Options.parse(rawTags[i].options);
						setProperties(fx.effect, options);
						effects.push(fx);
						break;
					} else {
						throw "Currently this library doesn't handle nested tags with the same effect. Found tag '"
							+ rawTags[k].tag + "' at position " + rawTags[k].rawPosition;
					}
				}
			}
		}

		#if lucid_debug
		for (fx in effects) {
			trace("Effect: " + fx.effect);
			trace("   applies to range    : " + fx.startIndex + " -> " + fx.endIndex);
		}
		#end
	}

	private function getRawTags():Array<TagLocation> {
		return rawTags;
	}

	public function getStrippedText():String {
		var stripped = new String(originalText);
		var position = 0;
		var foundClose = false;
		while (position < stripped.length) {
			if (stripped.charAt(position) == TagDelimiters.TAG_OPEN) {
				foundClose = false;
				for (k in position + 1...stripped.length) {
					if (stripped.charAt(k) == TagDelimiters.TAG_CLOSE) {
						stripped = stripped.substring(0, position) + stripped.substr(k + 1);
						foundClose = true;
						break;
					}
				}

				if (!foundClose) {
					throw 'getStrippedText: Expected \'${TagDelimiters.TAG_CLOSE}\' but reached end of string';
				}
			} else {
				// only increment position if we aren't dealing with a tag
				position++;
			}
		}
		return stripped;
	}

	private function setProperties(o:Effect, props:Dynamic) {
		var fields = o.getUserProperties();
		var options:haxe.DynamicAccess<Dynamic> = props;

		var keys = options.keys();
		if (keys.length > 0) {
			// Check that all passed props are valid fields
			for (opKey in options.keys()) {
				if (!fields.exists(opKey)) {
					trace('Option Keys: "${options.keys()}"');
					trace('Option Keys: "${options.get("height")}"');
					throw 'Effect ${o} does not have property "${opKey}"';
				}
			}
		}

		for (prop in fields.keys()) {
			// Check that all fields are valid for this object
			if (Reflect.field(o, prop) == null) {
				throw 'Class ${o} does not have field "${prop}". This is a dev issue';
			}

			fields[prop](o, prop, options.get(prop));
		}
	}
}
