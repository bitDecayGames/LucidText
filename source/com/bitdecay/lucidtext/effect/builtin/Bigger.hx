package com.bitdecay.lucidtext.effect.builtin;

import com.bitdecay.lucidtext.properties.Setters;

@description("(Extends size) Sets characters to be 50% bigger than their current size")
class Bigger extends Size {
	public function new() {
		super();
		mod = 1.5;
	}

	override public function getUserProperties():Map<String, PropSetterFunc> {
		return [];
	}
}
