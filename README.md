# LucidText

![Title IMage](assets/images/ludic.gif?raw=true "Title")

LucidText is a HaxeFlixel library designed to give easy access to juicy text boxes in the style of games like Animal Crossing and Celeste

## Table of Contents

* [DesignPrincipals](#design-principals)
* [Tagging](#tagging)
* [Custom Tags](#custom-tags)
* [Testing](#testing)

### Design Principals

#### **Foundational Concepts**

* User Input
	* This library is designed to allow a user to customize in-game text without needing to touch the code.
	* This is achieved by expecting styling directives to be part of the text strings in the form of HTML-style tagging. See [Tagging](#tagging) for more information.
* Parsing
* Effects

### Tagging

Tags follow an HTML style and are contained directly in the input strings.

The title image at the top of this readme is created by specifying:

`Hello <wave>LucidText</wave> user!`

This library comes with various generic style tags, a few of which are:

* `wave` - A sine wave that moves through the text
* `color` - Set the color of the text
* `shake` - Adds a random shake to the text

### Custom Tags

If the built-in tags are insufficient for a project's needs, custom tags can be eaily added:

1. Create a class that implements the `Effect` interface
1. Register the effect with the `EffectRegistry` via the `EffectRegistry.register(...)` function

### Testing

This project has been set up with MUnit to handle the unit tests. After various failed attempts at getting MUnit working with other projects, [this article](https://ashes999.github.io/learnhaxe/integration-testing-in-munit-with-haxeflixel.html) finally had a simple setup that cooperated well.

#### **Dependencies**

```
haxelib install munit
haxelib install hamcrest
```

#### **Running Tests**

From the `test/` directory, simply run `lime test neko` and the tests will be executed

#### **Adding Tests**

Tests should be put into a class that groups relevant tests together. If these tests are added to a new class, it must be added to the `TestSuite.hx` for it to be seen and run by MUnit.
* In `TestSuite.hx`, add a new line to add a class to the test suite with `add(<Class with tests>);`
