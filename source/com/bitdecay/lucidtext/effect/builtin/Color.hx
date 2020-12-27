package com.bitdecay.lucidtext.effect.builtin;

import com.bitdecay.lucidtext.ModifiableOptions;
import com.bitdecay.lucidtext.effect.Effect.EffectUpdater;
import flixel.text.FlxText;
import com.bitdecay.lucidtext.properties.Setters;

/**
 * Allows setting the color of characters.
 *
 * Currently only supports colors as integer, most usefully
 * in the hexidecimal form 0xRRGGBB
**/
class Color implements Effect {
	public var rgb:Int;

	public function new() {}

	public function getUserProperties():Map<String, PropSetterFunc> {
		return ["rgb" => Setters.setInt];
	}

	public function apply(o:FlxText, i:Int):EffectUpdater {
		o.color = rgb;
		return null;
	}

	public function begin(ops:ModifiableOptions) {}

	public function end(ops:ModifiableOptions) {}
}
