package com.bitdecay.lucidtext.parse;

class TextIterator {
	/**
	 * The position in the current text
	**/
	private var cursor:Int;

	/**
	 * The effective render position of the cursor only counting visible characters
	**/
	private var renderCursor:Int;

	private var text:String;

	public function new(text:String) {
		this.text = text;
		cursor = 0;
		renderCursor = 0;
	}

	public function getNextTag():TagLocation {
		for (i in cursor...text.length) {
			if (text.charAt(i) == TagDelimiters.TAG_OPEN) {
				for (k in i+1...text.length) {
					if (text.charAt(k) == TagDelimiters.TAG_OPEN) {
						throw 'Unexpected \'${TagDelimiters.TAG_OPEN}\' found at position ' +
							  '${i + k} while searching for \'${TagDelimiters.TAG_CLOSE}\'';
					}
					if (text.charAt(k) == TagDelimiters.TAG_CLOSE) {
						cursor = k + 1;
						var tagText = text.substr(i + 1, k - i - 1);
						var options = "";
						var closer = false;
						if (tagText.indexOf(TagDelimiters.TAG_OPTION_DELIMITER) > 0) {
							options = tagText.substr(tagText.indexOf(TagDelimiters.TAG_OPTION_DELIMITER) + 1);
							tagText = tagText.substring(0, tagText.indexOf(TagDelimiters.TAG_OPTION_DELIMITER));
						}
						if (tagText.charAt(0) == TagDelimiters.TAG_END) {
							// TODO: We should go close our other open tags instead of creating a new one
							tagText = tagText.substr(1);
							closer = true;
						}
						// if this is a closing tag, subtract 1 to account for '<'
						return new TagLocation(renderCursor + (closer ? -1 : 0), i, tagText, options, closer);
					}
				}
				// Reached the end of the string and never found our tag closer
				throw 'Expected \'${TagDelimiters.TAG_CLOSE}\' but reached end of string';
			} else {
				// not dealing with a tag, move our render cursor
				renderCursor++;
			}
		}
		cursor = text.length;
		return null;
	}
}