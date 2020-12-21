package com.bitdecay.lucidtext.effect;

import com.bitdecay.lucidtext.effect.builtin.Bigger;
import com.bitdecay.lucidtext.effect.builtin.Color;
import com.bitdecay.lucidtext.effect.builtin.Shake;
import com.bitdecay.lucidtext.effect.builtin.Smaller;
import com.bitdecay.lucidtext.effect.builtin.Size;
import com.bitdecay.lucidtext.effect.builtin.Wave;

/**
 * Registry to hold all valid effects. New effects can be registered easily
**/
class EffectRegistry {
	private static var registry:Map<String, () -> Effect> = [
		"color" => () -> return new Color(),
		"wave" => () -> return new Wave(),
		"shake" => () -> return new Shake(),
		"size" => () -> return new Size(),
		"bigger" => () -> return new Bigger(),
		"smaller" => () -> return new Smaller(),
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
