package com.bitdecay.lucidtext.effect;

import haxe.rtti.Meta;
import com.bitdecay.lucidtext.effect.builtin.Bigger;
import com.bitdecay.lucidtext.effect.builtin.Callback;
import com.bitdecay.lucidtext.effect.builtin.Color;
import com.bitdecay.lucidtext.effect.builtin.Fade;
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
import com.bitdecay.lucidtext.effect.builtin.Page;

typedef EffectMaker = () -> Effect;

/**
 * Registry to hold all valid effects. New effects can be registered easily
**/
class EffectRegistry {
	private static var registry:Map<String, EffectMaker> = [
		"cb" => () -> return new Callback(),
		"color" => () -> return new Color(),
		"fade" => () -> return new Fade(),
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
		"page" => () -> return new Page(),
	];

	private static var defaults:Map<String, Dynamic> = [];

	/**
	 * Prints all currently registered effects to console based on the available annotations
	**/
	public static function dumpToConsole() {
		for (key => value in registry) {
			trace('${["┌ ", [for (i in 0...key.length) '─'].join(""), " ┐"].join("")}');
			trace('│ ${key} │');
			trace('${["└ ", [for (i in 0...key.length) '─'].join(""), " ┘"].join("")}');

			var concrete = value();
			var clazz = Type.getClass(concrete);
			var meta = Meta.getFields(clazz);
			var clazzMeta = Meta.getType(clazz);
			var clazzFields = Reflect.fields(clazzMeta);
			var clazzFieldCount = clazzFields.length;
			var props = concrete.getUserProperties();
			var propCount = Lambda.count(props);
			var num = 0;

			for (f in clazzFields) {
				num++;
				trace('  ${num == clazzFieldCount && propCount == 0 ? "└" : "├"} ${f}: ${Reflect.field(clazzMeta, f)}');
			}

			if (propCount > 0) {
				var i = 0;
				trace('  └ parameters');
				for (key => _ in props) {
					i++;
					trace('     ${i == propCount ? "└" : "├"} ${key}');
					var fieldMeta = Reflect.field(meta, key);
					if (fieldMeta != null) {
						var fieldMetas = Reflect.fields(fieldMeta);
						var fieldMetaCount = fieldMetas.length;
						var k = 0;
						for (f in fieldMetas) {
							k++;
							trace('     ${i == propCount ? " " : "│"}  ${k == fieldMetaCount ? "└" : "├"} ${f}: ${Reflect.field(fieldMeta, f)}');
						}
					}
				}
			}

			trace('');
		}
	}

	public static function register(name:String, makerFunc:EffectMaker) {
		if (registry.exists(name)) {
			throw 'effect already exists with name \'${name}\'';
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
