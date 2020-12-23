package com.bitdecay.lucidtext.parse;

import com.bitdecay.lucidtext.parse.TextParser;
import com.bitdecay.lucidtext.effect.Effect;
import com.bitdecay.lucidtext.effect.EffectRange;
import com.bitdecay.lucidtext.effect.EffectRegistry;

/**
 * Handles parsing a string with HTML-style effect tags
**/
class Parser {
	public var results:TextParser;
	public var effects:Array<EffectRange> = [];

	public function new(text:String) {
		results = TextParser.parseString(text);
	}

	public function parse() {
		var rawTags = results.tags;

		#if lucid_debug
		trace("parsing : '" + results.originalText + "'");
		trace("stripped: '" + results.renderText + "'");
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
				// TODO: We want to throw in the case where we have a closing tag with no opening tag. Not sure where that logic should live
				// throw 'error parsing  ${originalText}:${rawTags[i].position} - found closing tag with no opening tag \'${rawTags[i].tag}\'';
				continue;
			}
			for (k in i + 1...rawTags.length) {
				if (rawTags[k].tag == rawTags[i].tag) {
					if (rawTags[k].close) {
						var fxMaker = EffectRegistry.get(rawTags[i].tag);
						if (fxMaker == null) {
							throw 'error parsing ${results.originalText}:${rawTags[i].position}->${rawTags[k].position} - no registered effect with name \'${rawTags[i].tag}\'';
							break;
						}
						var fx = new EffectRange(rawTags[i].position, rawTags[k].position, EffectRegistry.get(rawTags[i].tag)());

						var defaults = EffectRegistry.getDefaults(rawTags[i].tag);
						if (defaults != null) {
							// Set defaults first, if we have them
							Options.setAll(fx.effect, defaults);
						}

						var options = Options.parse(rawTags[i].options);
						Options.setAll(fx.effect, options);
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
		return results.tags;
	}

	public function getStrippedText():String {
		return results.renderText;
	}
}
