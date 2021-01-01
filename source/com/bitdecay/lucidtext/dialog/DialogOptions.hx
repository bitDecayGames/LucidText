package com.bitdecay.lucidtext.dialog;

import flixel.input.keyboard.FlxKey;

class DialogOptions {
	public var progressionKey:FlxKey = FlxKey.NONE;

	public var onTypingBegin:() -> Void = null;
	public var onTypingEnd:() -> Void = null;
	public var onTypingSpeedUp:() -> Void = null;

	public function new() {}
}
