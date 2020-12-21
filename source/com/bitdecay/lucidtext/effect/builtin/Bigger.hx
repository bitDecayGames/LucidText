package com.bitdecay.lucidtext.effect.builtin;

import flixel.text.FlxText;
import com.bitdecay.lucidtext.properties.Setters;

/**
 * Sets characters to be 50% bigger than their current size
**/
class Bigger extends Size {
	public function new() {
		super();
	}

	override public function getUserProperties():Map<String, PropSetterFunc> {
		return [];
	}

	override public function apply(o:FlxText, i:Int):ActiveFX {
		mod = 1.5;
		return super.apply(o, i);
	}
}
