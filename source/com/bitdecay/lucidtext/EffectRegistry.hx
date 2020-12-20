package com.bitdecay.lucidtext;

import com.bitdecay.lucidtext.effect.Effect;
import com.bitdecay.lucidtext.effect.Color;
import com.bitdecay.lucidtext.effect.Shake;
import com.bitdecay.lucidtext.effect.Size;
import com.bitdecay.lucidtext.effect.Wave;

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
