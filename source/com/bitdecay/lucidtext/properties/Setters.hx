package com.bitdecay.lucidtext.properties;

typedef PropSetterFunc = (Dynamic, String, String) -> Void;

class Setters {
	public static function setIfTrueBool(obj:Dynamic, propName:String, val:String) {
		if (val == null) {
			return;
		}
		var fx:haxe.DynamicAccess<Dynamic> = obj;
		if ("true" == val) {
			fx.set(propName, true);
		}
	}

	public static function setFloat(obj:Dynamic, propName:String, val:String) {
		if (val == null) {
			return;
		}
		var fx:haxe.DynamicAccess<Dynamic> = obj;
		var num = Std.parseFloat(val);
		if (num != Math.NaN) {
			fx.set(propName, num);
		}
	}

	public static function setInt(obj:Dynamic, propName:String, val:String) {
		if (val == null) {
			return;
		}
		var fx:haxe.DynamicAccess<Dynamic> = obj;
		var num = Std.parseInt(val);
		if (num != null) {
			fx.set(propName, num);
		}
	}
}
