package com.bitdecay.lucidtext.parse;

import massive.munit.Assert;
import com.bitdecay.lucidtext.parse.TextIterator;

class TextIteratorTest {
	@Test
	public function testUnterminatedTagEndTextFails()
	{
		var text = "<shake";
		var iter = new TextIterator(text);
		var except = Assert.throws(String, iter.getNextTag);
		Assert.isTrue(StringTools.contains(except, "Expected '>' but reached end of string"));
	}
}