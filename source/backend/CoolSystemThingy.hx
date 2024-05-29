package backend;

import haxe.macro.Compiler;

class SussySystem
{
	// Variable.
	inline public static var getHaxeVer(get, never):Dynamic;
	inline public static var getOpenFLVer(get, never):Dynamic;
	inline public static var getLimeVer(get, never):Dynamic;
	inline public static var getUser(get, never):String;
	inline public static var getUserPath(get, never):String;

	// Methods.
	// wait what why not have any method here? -?
	// cuz i to lazy. -Miukothoi2011

	// Set/Get Methods (a.k.a Accessor Methods).
	private static function get_getHaxeVer():Dynamic
		return Compiler.getDefine("haxe");

	private static function get_getOpenFLVer():Dynamic
		return Compiler.getDefine("openfl");

	private static function get_getLimeVer():Dynamic
		return Compiler.getDefine("lime");

	private static function get_getUser():String
		return Sys.getEnv('USERNAME');

	private static function get_getUserPath():String
		return Sys.getEnv('USERPROFILE');
}

typedef CoolSystemThingy = SussySystem;