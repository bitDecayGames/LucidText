package com.bitdecay.lucidtext.effect.builtin;

import com.bitdecay.lucidtext.properties.Setters;

@description("Sets typing to be 50% of the current speed")
class Slower extends Speed {
	public function new() {
		super();
		mod = 0.5;
	}

	override public function getUserProperties():Map<String, PropSetterFunc> {
		return [];
	}
}
