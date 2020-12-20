package com.bitdecay.lucidtext.effect;

import com.bitdecay.lucidtext.effect.builtin.Color;
import com.bitdecay.lucidtext.effect.builtin.Shake;
import com.bitdecay.lucidtext.effect.builtin.Size;
import com.bitdecay.lucidtext.effect.builtin.Wave;

class EffectRegistry {
	private static var registry:Map<String, () -> Effect> = [
		"color" => () -> return new Color(),
		"wave" => () -> return new Wave(),
		"shake" => () -> return new Shake(),
		"size" => () -> return new Size(),
	];

	public static function register(name:String, makerFunc:() -> Effect) {
		if (registry.exists(name)) {
			trace('lucidtext effect ${name} (${registry.get(name)}) being overwritten by ${makerFunc}');
		}
		registry.set(name, makerFunc);
	}

	public static function get(name:String):() -> Effect {
		if (registry.exists(name)) {
			return registry.get(name);
		} else {
			trace('NO EFFECT EXISTS CALLED: "${name}". This will be ignored');
			return null;
		}
	}
}
