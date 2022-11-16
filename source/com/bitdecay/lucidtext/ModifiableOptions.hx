package com.bitdecay.lucidtext;

class ModifiableOptions {
	public var speedMultiplier:Float = 1.0;
	public var charsPerSecond:Float = 20.0;

	// if set, adds a one-time delay to the typing timer and is then cleared
	public var delay:Float = 0.0;

	public function new(charPerSec:Float = 20.0) {
		charsPerSecond = charPerSec;
	}

	public function clone():ModifiableOptions {
		return new ModifiableOptions(charsPerSecond);
	}
}
