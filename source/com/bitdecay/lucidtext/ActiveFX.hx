package com.bitdecay.lucidtext;

import flixel.text.FlxText;

/**
 * Ties a given FlxText object to an effect that can be updated as time passes
**/
class ActiveFX {
	private var txt:FlxText;
	private var updater:(Float) -> Void;

	public function new(target:FlxText, updateFunc:(Float) -> Void) {
		txt = target;
		updater = updateFunc;
	}

	public function update(delta:Float) {
		updater(delta);
	}
}
