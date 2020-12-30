package com.bitdecay.lucidtext.parse;

class Regex {
	public static inline var GLOBAL_MODE = "g";

	/**
	 * Captures a tag with 4 groups:
	 *    1) the beginning slash to indicate a closing tag
	 *    2) the tag name itself
	 *    3) the options provided
	 *    4) a potential trailing slash for void elements that have no span
	**/
	public static inline var TAG_REGEX = "<(\\/?)(\\w+)\\s?(.*?)\\s?(/?)>";

	public static inline var WORD_REGEX = "\\S+";

	public static inline var WORD_NO_PUNC_REGEX = "[A-Za-z-_]+";
}
