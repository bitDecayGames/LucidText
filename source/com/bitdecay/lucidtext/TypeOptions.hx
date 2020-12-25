package com.bitdecay.lucidtext;

import flixel.FlxSprite;

class TypeOptions {
	public var windowAsset:String;
	public var slice9:Array<Int> = null;
	public var margins:Float = 10.0;
	public var fontSize:Int = 16;
	public var charsPerSecond:Float = 20.0;

	public function new(windowAsset:String, slice9:Array<Int> = null, margins:Float = 10, fontSize:Int = 16, charsPerSecond:Float = 20) {
		this.windowAsset = windowAsset;
		this.slice9 = slice9;
		this.margins = margins;
		this.fontSize = fontSize;
		this.charsPerSecond = charsPerSecond;
	}
}
