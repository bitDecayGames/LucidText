package com.bitdecay.lucidtext.effect;

import com.bitdecay.lucidtext.effect.builtin.Bigger;
import com.bitdecay.lucidtext.effect.builtin.Color;
import com.bitdecay.lucidtext.effect.builtin.Rainbow;
import com.bitdecay.lucidtext.effect.builtin.Shake;
import com.bitdecay.lucidtext.effect.builtin.Smaller;
import com.bitdecay.lucidtext.effect.builtin.Scrub;
import com.bitdecay.lucidtext.effect.builtin.Size;
import com.bitdecay.lucidtext.effect.builtin.Speed;
import com.bitdecay.lucidtext.effect.builtin.Slower;
import com.bitdecay.lucidtext.effect.builtin.Faster;
import com.bitdecay.lucidtext.effect.builtin.Wave;
import com.bitdecay.lucidtext.effect.builtin.Pause;

/**
 * Registry to hold all valid effects. New effects can be registered easily
**/
class EffectRegistry {
	private static var registry:Map<String, () -> Effect> = [
		"color" => () -> return new Color(),
		"rainbow" => () -> return new Rainbow(),
		"wave" => () -> return new Wave(),
		"shake" => () -> return new Shake(),
		"size" => () -> return new Size(),
		"bigger" => () -> return new Bigger(),
		"smaller" => () -> return new Smaller(),
		"scrub" => () -> return new Scrub(),
		"speed" => () -> return new Speed(),
		"slower" => () -> return new Slower(),
		"faster" => () -> return new Faster(),
		"pause" => () -> return new Pause(),
	];

	private static var defaults:Map<String, Dynamic> = [];

	public static function register(name:String, makerFunc:() -> Effect) {
		if (registry.exists(name)) {
			trace('lucidtext effect ${name} (${registry.get(name)}) being overwritten by ${makerFunc}');
		}
		registry.set(name, makerFunc);
	}

	public static function registerDefault(name, allOpts:Dynamic) {
		if (!registry.exists(name)) {
			throw 'cannot set defaults: no registered effect with name \'${name}\'';
		}
		defaults.set(name, allOpts);
	}

	public static function get(name:String):() -> Effect {
		if (registry.exists(name)) {
			return registry.get(name);
		} else {
			return null;
		}
	}

	public static function getDefaults(name:String):Dynamic {
		return defaults.get(name);
	}
}
