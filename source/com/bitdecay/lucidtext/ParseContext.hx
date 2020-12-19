package com.bitdecay.lucidtext;

class ParseContext {
	private static inline var TAG_OPEN = "<";
	private static inline var TAG_CLOSE = ">";
	private static inline var TAG_END = "/";

	/**
	 * The position in the current text
	 */
	var cursor:Int;

	/**
	 * The effective render position of the cursor only counting visible characters
	 */
	var renderCursor:Int;

	var text:String;

	public function new(text:String) {
		this.text = text;
		renderCursor = -1;
		cursor = 0;
	}

	public function getNextTag():TagLocation {
		for (i in cursor...text.length) {
			renderCursor++;
			if (text.charAt(i) == TAG_OPEN) {
				for (k in i...text.length) {
					if (text.charAt(k) == TAG_CLOSE) {
						cursor = k + 1;
						var tagText = text.substr(i + 1, k - i - 1);
						var options = "";
						var closer = false;
						if (tagText.indexOf(" ") > 0) {
							options = tagText.substr(tagText.indexOf(" ") + 1);
							tagText = tagText.substring(0, tagText.indexOf(" "));
						}
						if (tagText.charAt(0) == TAG_END) {
							// TODO: We should go close our other open tags instead of creating a new one
							tagText = tagText.substr(1);
							closer = true;
						}
						// if this is a closing tag, subtract 2 to account for '<_'
						return new TagLocation(renderCursor + (closer ? -2 : 0), i, tagText, options, closer);
					}
				}
			}
		}
		cursor = text.length;
		return null;
	}
}
