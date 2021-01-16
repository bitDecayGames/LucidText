package com.bitdecay.lucidtext.effect.builtin;

import flixel.text.FlxText;
import com.bitdecay.lucidtext.effect.Effect.EffectUpdater;
import com.bitdecay.lucidtext.properties.Setters;

/**
 * No-op tag that is used for creating page breaks in typing text
 *
 * NOTE: In it's current state, this works very oddly if placed in the middle
 *       of a word. It works best when placed after a space due to how words
 *       are parsed.
**/
@description("No-op tag that is used for creating page breaks in typing text")
class Page implements Effect {
	var enforcer:Int = -1;

	public function new() {}

	public function getUserProperties():Map<String, PropSetterFunc> {
		return [];
	}

	public function apply(o:FlxText, i:Int):EffectUpdater {
		if (enforcer == -1) {
			enforcer = i;
			return null;
		}

		if (enforcer != i) {
			throw 'the \'page\' tag at position ${i} should be a void tag: <page />';
		}

		return null;
	}

	public function begin(ops:ModifiableOptions) {}

	public function end(ops:ModifiableOptions) {}
}
