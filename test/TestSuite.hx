import massive.munit.TestSuite;

import com.bitdecay.lucidtext.parse.ParserTest;
import com.bitdecay.lucidtext.parse.TextIteratorTest;

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
		add(TextIteratorTest);
	}
}
