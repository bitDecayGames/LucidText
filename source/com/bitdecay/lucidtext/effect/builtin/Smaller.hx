package com.bitdecay.lucidtext.effect.builtin;

import com.bitdecay.lucidtext.properties.Setters;

@description("Sets characters to be 50% smaller than their current size")
class Smaller extends Size {
	public function new() {
		super();
		mod = 0.5;
	}

	override public function getUserProperties():Map<String, PropSetterFunc> {
		return [];
	}
}
