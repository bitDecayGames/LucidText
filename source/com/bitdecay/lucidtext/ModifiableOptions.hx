package com.bitdecay.lucidtext;

class ModifiableOptions {
	public var charsPerSecond:Float = 20.0;

	public function new(charPerSec:Float = 20.0) {
		charsPerSecond = charPerSec;
	}

	public function clone():ModifiableOptions {
		return new ModifiableOptions(charsPerSecond);
	}
}
