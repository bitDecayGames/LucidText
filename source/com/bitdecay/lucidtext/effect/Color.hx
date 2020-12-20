package com.bitdecay.lucidtext.effect;

import flixel.text.FlxText;

/**
 * Allows setting the color of characters.
 *
 * Currently only supports colors as integer, most usefully
 * in the hexidecimal form 0xRRGGBB
**/
class Color implements Effect {
	var c:Int;

	public function new() {}

	public function getUserProperties():Map<String, PropertySetters.PropertySetterFunc> {
		return ["c" => PropertySetters.setInt];
	}

	public function apply(o:FlxText, i:Int):ActiveFX {
		o.color = c;
		return null;
	}
}
