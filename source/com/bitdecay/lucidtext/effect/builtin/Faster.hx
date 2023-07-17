package com.bitdecay.lucidtext.effect.builtin;

import com.bitdecay.lucidtext.properties.Setters;

@description("(Extends speed) Sets typing to be 200% of the current speed")
class Faster extends Speed {
	public function new() {
		super();
		mod = 2;
	}

	override public function getUserProperties():Map<String, PropSetterFunc> {
		return [];
	}
}
