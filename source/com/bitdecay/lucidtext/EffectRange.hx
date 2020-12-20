package com.bitdecay.lucidtext;

import com.bitdecay.lucidtext.effect.Effect;

class EffectRange {
	public var startIndex:Int;
	public var endIndex:Int;
	// This is a stand-in until I figure out what I want to represent this as
	public var effect:Effect;

	public function new(start:Int, end:Int, fx:Effect) {
		startIndex = start;
		endIndex = end;
		effect = fx;
	}

	public function impacts(i:Int):Bool {
		return i >= startIndex && i <= endIndex;
	}
}
