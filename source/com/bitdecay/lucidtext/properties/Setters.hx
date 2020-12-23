package com.bitdecay.lucidtext.properties;

typedef PropSetterFunc = (Dynamic, String, String) -> Void;

class Setters {
	public static function setBool(obj:Dynamic, propName:String, val:String) {
		if (val == null) {
			return;
		}
		var fx:haxe.DynamicAccess<Dynamic> = obj;
		if ("true" == val) {
			fx.set(propName, true);
		} else {
			fx.set(propName, false);
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

	public static function setBoolDefault(defVal:String) {
		return (obj, prop, s) -> {
			setBool(obj, prop, defVal);
		};
	}

	public static function setIntDefault(defVal:String) {
		return (obj, prop, s) -> {
			setInt(obj, prop, defVal);
		};
	}

	public static function setFloatDefault(defVal:String) {
		return (obj, prop, s) -> {
			setFloat(obj, prop, defVal);
		};
	}
}
