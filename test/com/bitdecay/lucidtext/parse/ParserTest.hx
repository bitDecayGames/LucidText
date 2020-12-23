package com.bitdecay.lucidtext.parse;

import com.bitdecay.lucidtext.effect.builtin.Wave;
import massive.munit.Assert;
import com.bitdecay.lucidtext.parse.Parser;

class ParserTest {
	@Test
	public function testParsedEffect() {
		var text = "Wavy <wave height=543 speed=54 offset=0.123>World</wave>";
		var parser = new Parser(text);
		parser.parse();

		Assert.areEqual(1, parser.effects.length);
		Assert.isType(parser.effects[0].effect, Wave);
		var wave = cast(parser.effects[0].effect, Wave);
		Assert.areEqual(543, wave.height);
		Assert.areEqual(54, wave.speed);
		Assert.areEqual(0.123, wave.offset);
	}

	@Test
	public function testNestedSameTagFails() {
		var text = "<shake>Shaking <shake size=20>harder</shake> World</shake>";
		var parser = new Parser(text);
		var except = Assert.throws(String, parser.parse);
		Assert.isTrue(StringTools.contains(except, "this library doesn't handle nested tags with the same effect"));
		Assert.isTrue(StringTools.contains(except, "shake"));
	}

	@Test
	public function testGetStrippedText() {
		var text = "<shake>Shaking World</shake";
		var parser = new Parser(text);
		var except = Assert.throws(String, parser.getStrippedText);
		Assert.isTrue(StringTools.contains(except, "Expected '>' but reached end of string"), 'Expected "${except} to match');
	}
}