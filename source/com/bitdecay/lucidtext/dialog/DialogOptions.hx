package com.bitdecay.lucidtext.dialog;

import flixel.math.FlxRect;
import flixel.input.keyboard.FlxKey;

class DialogOptions {
	public var window:FlxRect = null;
	public var progressionKey:FlxKey = FlxKey.NONE;

	public var onTypingBegin:() -> Void = null;
	public var onTypingEnd:() -> Void = null;
	public var onTypingSpeedUp:() -> Void = null;

	public function new(window:FlxRect) {
		this.window = window;
	}
}
