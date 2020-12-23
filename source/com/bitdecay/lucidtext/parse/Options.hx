package com.bitdecay.lucidtext.parse;

import com.bitdecay.lucidtext.effect.Effect;

class Options {
	public static function parse(raw:String):Dynamic {
		var allOps:haxe.DynamicAccess<Dynamic> = {};

		raw = StringTools.trim(raw);
		if (raw.length > 0) {
			for (op in raw.split(TagDelimiters.TAG_OPTION_DELIMITER)) {
				var splits = op.split(TagDelimiters.TAG_OPTION_NAME_SEPARATOR);
				if (splits.length < 2) {
					throw 'unexpected option \'${op}\'';
				}
				allOps.set(splits[0], splits[1]);
			}
		}
		return allOps;
	}

	public static function setAll(o:Effect, props:Dynamic) {
		var fields = o.getUserProperties();
		var options:haxe.DynamicAccess<Dynamic> = props;

		var keys = options.keys();
		if (keys.length > 0) {
			// Check that all passed props are valid fields
			for (opKey in options.keys()) {
				if (!fields.exists(opKey)) {
					trace('Option Keys: "${options.keys()}"');
					trace('Option Keys: "${options.get("height")}"');
					throw 'Effect ${o} does not have property "${opKey}"';
				}
			}
		}

		for (prop in fields.keys()) {
			// Check that all fields are valid for this object
			if (Reflect.field(o, prop) == null) {
				throw 'Class ${o} does not have field "${prop}". This is a dev issue';
			}

			fields[prop](o, prop, options.get(prop));
		}
	}
}
