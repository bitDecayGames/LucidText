package com.bitdecay.lucidtext.effect.builtin;

import flixel.text.FlxText;
import com.bitdecay.lucidtext.effect.Effect.EffectUpdater;
import com.bitdecay.lucidtext.properties.Setters;

/**
 * Allows setting the typing speed as a scalar of the current options
**/
class Speed implements Effect {
	private var restoreSpeed:Float = 0.0;

	public var mod:Float = 1.0;

	public function new() {}

	public function getUserProperties():Map<String, PropSetterFunc> {
		return ["mod" => Setters.setFloat];
	}

	public function apply(o:FlxText, i:Int):EffectUpdater {
		return null;
	}

	public function begin(ops:ModifiableOptions) {
		restoreSpeed = ops.charsPerSecond;
		ops.charsPerSecond *= mod;
	}

	public function end(ops:ModifiableOptions) {
		ops.charsPerSecond = restoreSpeed;
	}
}
