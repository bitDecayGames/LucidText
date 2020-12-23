import massive.munit.TestSuite;

import com.bitdecay.lucidtext.parse.OptionsTest;
import com.bitdecay.lucidtext.parse.ParserTest;
import com.bitdecay.lucidtext.parse.TextParserTest;
import com.bitdecay.lucidtext.effect.EffectRegistryTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */
class TestSuite extends massive.munit.TestSuite
{
	public function new()
	{
		super();

		add(ParserTest);
		add(TextParserTest);
		add(OptionsTest);
		add(EffectRegistryTest);
	}
}
