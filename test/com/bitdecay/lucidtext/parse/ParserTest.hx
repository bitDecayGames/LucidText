package com.bitdecay.lucidtext.parse;

import massive.munit.Assert;
import com.bitdecay.lucidtext.parse.Parser;

class ParserTest {
	@Test
	public function testTaglessString()
	{
		var noTags = "Hello World";
		var parser = new Parser(noTags);
		parser.parse();

		Assert.areEqual(noTags, parser.getStrippedText());
		Assert.isEmpty(parser.rawTags);
		Assert.isEmpty(parser.effects);
	}

	@Test
	public function testInnerTags()
	{
		var innerWaveTag = "Hello <wave>wavy</wave> World";
		var parser = new Parser(innerWaveTag);
		parser.parse();

		Assert.areEqual("Hello wavy World", parser.getStrippedText());
		Assert.areEqual(2, parser.rawTags.length);
		Assert.areEqual(1, parser.effects.length);
	}
}