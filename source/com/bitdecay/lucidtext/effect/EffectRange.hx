package com.bitdecay.lucidtext.effect;

/**
 * Ties an Effect to a given range of characters
**/
class EffectRange {
	public var startIndex:Int;
	public var endIndex:Int;
	public var effect:Effect;

	public function new(start:Int, end:Int, fx:Effect) {
		startIndex = start;
		endIndex = end;
		effect = fx;
	}

	public function impacts(i:Int):Bool {
		return i >= startIndex && i < endIndex;
	}
}
