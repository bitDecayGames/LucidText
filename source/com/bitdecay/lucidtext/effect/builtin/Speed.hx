package com.bitdecay.lucidtext.effect.builtin;

import flixel.text.FlxBitmapText;
import com.bitdecay.lucidtext.effect.Effect.EffectUpdater;
import com.bitdecay.lucidtext.properties.Setters;

@description("Allows setting the typing speed as a scalar of the current options")
class Speed implements Effect {
	private var restoreSpeed:Float = 0.0;

	@description("Scalar of how much to modify the base typing speed")
	public var mod:Float = 1.0;

	public function new() {}

	public function getUserProperties():Map<String, PropSetterFunc> {
		return ["mod" => Setters.setFloat];
	}

	public function apply(o:FlxBitmapText, i:Int):EffectUpdater {
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
