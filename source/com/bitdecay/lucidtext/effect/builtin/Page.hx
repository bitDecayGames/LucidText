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
class Page implements Effect {
	public function new() {}

	public function getUserProperties():Map<String, PropSetterFunc> {
		return [];
	}

	public function apply(o:FlxText, i:Int):EffectUpdater {
		return null;
	}

	public function begin(ops:ModifiableOptions) {}

	public function end(ops:ModifiableOptions) {}
}
