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

	@Test
	public function testFullTagParse()
	{
		var text = "<wave height=54 speed=32>wave</wave>";
		var iter = new TextIterator(text);
		var waveOpen = iter.getNextTag();

		Assert.isFalse(waveOpen.close);
		Assert.areEqual("wave", waveOpen.tag);
		Assert.areEqual("height=54 speed=32", waveOpen.options);
		Assert.areEqual(0, waveOpen.position);
		Assert.areEqual(0, waveOpen.rawPosition);

		var waveClose = iter.getNextTag();
		Assert.isTrue(waveClose.close);
		Assert.areEqual("wave", waveClose.tag);
		Assert.areEqual("", waveClose.options);
		Assert.areEqual(3, waveClose.position);
		Assert.areEqual(29, waveClose.rawPosition);
	}
}