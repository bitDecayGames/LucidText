package com.bitdecay.lucidtext.parse;

import massive.haxe.log.Log;
import massive.munit.Assert;
import com.bitdecay.lucidtext.parse.TextParser;

class TextParserTest {
	@Test
	public function testTaglessString() {
		var out = TextParser.parseString("Hello World");
		Assert.areEqual(0, out.tags.length);
	}

	@Test
	public function testInnerTags() {
		var out = TextParser.parseString("Hello <inside> World");
		Assert.areEqual(1, out.tags.length);
		var tag = out.tags[0];

		Assert.isNotNull(tag);
		Assert.areEqual("inside", tag.tag);
		Assert.areEqual(6, tag.position);
		Assert.areEqual(6, tag.rawPosition);
		Assert.isEmpty(tag.options);
	}

	@Test
	public function testTagAtBeginning() {
		var out = TextParser.parseString("<start> Hello World");
		Assert.areEqual(1, out.tags.length);
		var tag = out.tags[0];

		Assert.isNotNull(tag);
		Assert.areEqual("start", tag.tag);
		Assert.areEqual(0, tag.position);
		Assert.areEqual(0, tag.rawPosition);
		Assert.isEmpty(tag.options);
	}

	@Test
	public function testTagAtEnd() {
		var out = TextParser.parseString("World</shake>");
		Assert.areEqual(1, out.tags.length);
		var tag = out.tags[0];

		Assert.isNotNull(tag);
		Assert.areEqual("shake", tag.tag);
		Assert.areEqual(5, tag.position);
		Assert.areEqual(5, tag.rawPosition);
		Assert.isEmpty(tag.options);
	}

	// TODO: How to handle error situations now that regex is doing all the heavy liftin?
	// @Test
	// public function testUnterminatedTagEndTextFails(){
	// 	var out = TextParser.parseString("<shake");
	// 	var iter = new TextParser(text);
	// 	var except = Assert.throws(String, iter.getAllTags);
	// 	Assert.isTrue(StringTools.contains(except, "Expected '>' but reached end of string"), 'got except: ${except}');
	// }

	@Test
	public function testParseOptions() {
		var out = TextParser.parseString("<opTag height=54 speed=32>hello");
		Assert.areEqual(1, out.tags.length);
		var tag = out.tags[0];

		Assert.isFalse(tag.close);
		Assert.areEqual("opTag", tag.tag);
		Assert.areEqual("height=54 speed=32", tag.options);
		Assert.areEqual(0, tag.position);
		Assert.areEqual(0, tag.rawPosition);
	}

	@Test
	public function testRawPosition() {
		var out = TextParser.parseString("Chars<tag>moreChars<tag2>");
		Assert.areEqual(2, out.tags.length);

		var tag = out.tags[0];
		Assert.areEqual("tag", tag.tag);
		Assert.areEqual(5, tag.position);
		Assert.areEqual(5, tag.rawPosition);

		tag = out.tags[1];
		Assert.areEqual("tag2", tag.tag);
		Assert.areEqual(14, tag.position);
		Assert.areEqual(19, tag.rawPosition);
	}

	@Test
	public function testFullTagPair()
	{
		var out = TextParser.parseString("<wave height=54 speed=32>wave</wave>");
		Assert.areEqual(2, out.tags.length);

		var waveOpen = out.tags[0];

		Assert.isFalse(waveOpen.close);
		Assert.areEqual("wave", waveOpen.tag);
		Assert.areEqual("height=54 speed=32", waveOpen.options);
		Assert.areEqual(0, waveOpen.position);
		Assert.areEqual(0, waveOpen.rawPosition);

		var waveClose = out.tags[1];
		Assert.isTrue(waveClose.close);
		Assert.areEqual("wave", waveClose.tag);
		Assert.areEqual("", waveClose.options);
		Assert.areEqual(4, waveClose.position);
		Assert.areEqual(29, waveClose.rawPosition);
	}

	@Test
	public function testRegexMatchingSimpleTag() {
		var out = TextParser.parseString("<tag>");
		Assert.areEqual("", out.renderText);
		Assert.areEqual(1, out.tags.length);

		var m = out.tags[0];
		Assert.areEqual(0, m.position);
		Assert.areEqual("tag", m.tag);
	}

	@Test
	public function testRegexIncompleteTag() {
		var except = Assert.throws(String, () -> TextParser.parseString("<tag hello there</tag>"));
		Assert.isTrue(StringTools.contains(except, "unexpected '<' found while parsing contents for tag at position: 0"));
	}

	@Test
	public function testRegexMatchingSimpleCloseTag() {
		var out = TextParser.parseString("</tag>");
		Assert.areEqual("", out.renderText);
		Assert.areEqual(1, out.tags.length);

		var m = out.tags[0];
		Assert.areEqual(0, m.position);
		// Assert.areEqual(6, m.len);
		Assert.isTrue(m.close, "should capture a closing tag");
		Assert.areEqual("tag", m.tag);
	}

	@Test
	public function testRegexTagWithinText() {
		var out = TextParser.parseString("tag <within>string");
		Assert.areEqual("tag string", out.renderText);
		Assert.areEqual(1, out.tags.length);
		var m = out.tags[0];
		Assert.areEqual(4, m.position);
		Assert.areEqual(4, m.rawPosition);
		Assert.isFalse(m.close);
		Assert.areEqual("within", m.tag);
		Assert.areEqual("", m.options);
	}

	@Test
	public function testRegexMultiTag() {
		var out = TextParser.parseString("tag <start>multi</start> string");
		Assert.areEqual("tag multi string", out.renderText);
		Assert.areEqual(2, out.tags.length);

		var m1 = out.tags[0];
		Assert.areEqual(4, m1.position);
		Assert.areEqual(4, m1.rawPosition);
		Assert.isFalse(m1.close);
		Assert.areEqual("start", m1.tag);
		Assert.areEqual("", m1.options);

		var m1 = out.tags[1];
		Assert.areEqual(9, m1.position);
		Assert.areEqual(16, m1.rawPosition);
		Assert.isTrue(m1.close);
		Assert.areEqual("start", m1.tag);
		Assert.areEqual("", m1.options);
	}

	@Test
	public function testRegexTagWithOptions() {
		var out = TextParser.parseString("tag <withOps op1=one op2=two>string");
		Assert.areEqual("tag string", out.renderText);
		Assert.areEqual(1, out.tags.length);
		var m = out.tags[0];
		Assert.areEqual(4, m.position);
		Assert.areEqual(4, m.rawPosition);
		Assert.isFalse(m.close);
		Assert.areEqual("withOps", m.tag);
		Assert.areEqual("op1=one op2=two", m.options);
	}

	@Test
	public function testTrailingSpaceNoOptions() {
		var out = TextParser.parseString("tag <noOpts >string");
		Assert.areEqual("tag string", out.renderText);
		Assert.areEqual(1, out.tags.length);
		var m = out.tags[0];
		Assert.areEqual(4, m.position);
		Assert.areEqual(4, m.rawPosition);
		Assert.isFalse(m.close);
		Assert.isFalse(m.void);
		Assert.areEqual("noOpts", m.tag);
	}

	@Test
	public function testTrailingSpaceWithOptions() {
		var out = TextParser.parseString("tag <withOps op1=test >string");
		Assert.areEqual("tag string", out.renderText);
		Assert.areEqual(1, out.tags.length);
		var m = out.tags[0];
		Assert.areEqual(4, m.position);
		Assert.areEqual(4, m.rawPosition);
		Assert.isFalse(m.close);
		Assert.isFalse(m.void);
		Assert.areEqual("withOps", m.tag);
		Assert.areEqual("op1=test", m.options);

	}

	@Test
	public function testVoidTagsNoSpace() {
		var out = TextParser.parseString("short<pause/> pause");
		Assert.areEqual("short pause", out.renderText);
		Assert.areEqual(1, out.tags.length);
		var m = out.tags[0];
		Assert.areEqual(5, m.position);
		Assert.areEqual(5, m.rawPosition);
		Assert.isFalse(m.close);
		Assert.isTrue(m.void);
		Assert.areEqual("pause", m.tag);
	}

	@Test
	public function testVoidTagsWithSpace() {
		var out = TextParser.parseString("short<pause /> pause");
		Assert.areEqual("short pause", out.renderText);
		Assert.areEqual(1, out.tags.length);
		var m = out.tags[0];
		Assert.areEqual(5, m.position);
		Assert.areEqual(5, m.rawPosition);
		Assert.isFalse(m.close);
		Assert.isTrue(m.void);
		Assert.areEqual("pause", m.tag);
	}

	public function testGetAllTags() {
		var out = TextParser.parseString("<wave><dave><save>");
		Assert.areEqual(3, out.tags.length);
		Assert.areEqual(out.tags[0].tag, "wave");
		Assert.areEqual(out.tags[1].tag, "dave");
		Assert.areEqual(out.tags[2].tag, "save");
	}
}
