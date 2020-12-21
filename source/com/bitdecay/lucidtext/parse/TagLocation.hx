package com.bitdecay.lucidtext.parse;

class TagLocation {
	public var position:Int;
	public var rawPosition:Int;
	public var tag:String;
	public var options:String;
	public var close:Bool;

	public function new(pos:Int, raw:Int, tag:String, options:String, close:Bool) {
		position = pos;
		rawPosition = raw;
		this.tag = tag;
		this.options = options;
		this.close = close;
	}
}