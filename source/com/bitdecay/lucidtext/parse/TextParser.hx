package com.bitdecay.lucidtext.parse;

class TextParser {
	public static inline var TAG_REGEX = "<(\\/?)(\\w+)\\s?(.*?)>";

	public var originalText:String;
	public var renderText:String;
	public var tags:Array<TagLocation>;

	private function new(original:String, render:String, tags:Array<TagLocation>) {
		this.originalText = original;
		this.renderText = render;
		this.tags = tags;
	}

	public static function parseString(text:String):TextParser {
		var allTags = new Array<TagLocation>();
		var regexp = new EReg(TAG_REGEX, "g");
		var removedCharacters = 0;
		var renderText = regexp.map(text, (reg) -> {
			if (StringTools.contains(reg.matched(2), "<") || StringTools.contains(reg.matched(3), "<")) {
				// indicates bad formatting
				throw 'unexpected \'<\' found while parsing contents for tag at position: ${reg.matchedPos().pos}';
			}
			allTags.push(new TagLocation(reg.matchedPos().pos - removedCharacters, reg.matchedPos().pos, reg.matched(2), reg.matched(3),
				reg.matched(1).length > 0));
			removedCharacters += reg.matchedPos().len;
			return "";
		});
		return new TextParser(text, renderText, allTags);
	}
}
