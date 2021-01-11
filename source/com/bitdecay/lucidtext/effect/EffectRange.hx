package com.bitdecay.lucidtext.effect;

import com.bitdecay.lucidtext.parse.TagLocation;

/**
 * Ties an Effect to a given range of characters
**/
class EffectRange {
	public var startTag:TagLocation;
	public var endTag:TagLocation;
	public var effect:Effect;

	public function new(start:TagLocation, end:TagLocation, fx:Effect) {
		startTag = start;
		endTag = end;
		effect = fx;
	}

	public function impacts(i:Int):Bool {
		if (startTag.position == endTag.position) {
			// handle void tags
			return i == startTag.position;
		} else {
			return i >= startTag.position && i < endTag.position;
		}
	}
}
