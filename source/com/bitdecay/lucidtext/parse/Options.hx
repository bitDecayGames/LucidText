package com.bitdecay.lucidtext.parse;

import com.bitdecay.lucidtext.effect.Effect;

class Options {
	public static function parse(raw:String):Dynamic {
		var allOps:haxe.DynamicAccess<Dynamic> = {};

		#if lucid_debug
		trace('parsing raw tag options: ${raw}');
		#end
		raw = StringTools.trim(raw);
		if (raw.length > 0) {
			for (op in raw.split(TagDelimiters.TAG_OPTION_DELIMITER)) {
				var splits = op.split(TagDelimiters.TAG_OPTION_NAME_SEPARATOR);
				if (splits.length < 2) {
					throw 'unexpected option \'${op}\'';
				}
				#if lucid_debug
				trace('setting tag attribute: ${splits[0]} to ${splits[1]}');
				#end
				allOps.set(splits[0], splits[1]);
			}
		}
		#if lucid_debug
		trace('full parsed tag attributes: ${allOps}');
		#end
		return allOps;
	}

	public static function setAll(o:Effect, props:Dynamic) {
		#if lucid_debug
		trace('setting effect ${o} options to: ${props}');
		#end
		var fields = o.getUserProperties();
		#if lucid_debug
		trace('available fields on effect: $fields');
		#end
		var options:haxe.DynamicAccess<Dynamic> = props;
		#if lucid_debug
		trace('provided options as DynamicAccess: $options');
		#end

		var keys = options.keys();
		#if lucid_debug
		trace('option keys: $keys');
		#end
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
