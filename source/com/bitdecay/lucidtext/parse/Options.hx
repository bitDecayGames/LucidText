package com.bitdecay.lucidtext.parse;

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
}
