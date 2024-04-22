package psychlua;

#if (!flash && sys)
import flixel.addons.display.FlxRuntimeShader;
import shaders.Shaders;
#end

class ShaderFunctions
{
	public static function implement(funk:FunkinLua)
	{
		var lua = funk.lua;
		// shader shit
		if (ClientPrefs.data.shaders) {
			funk.addLocalCallback("initLuaShader", function(name:String, ?glslVersion:Int = 120) {
				if(!ClientPrefs.data.shaders) return false;

				#if (!flash && MODS_ALLOWED && sys)
				return funk.initLuaShader(name, glslVersion);
				#else
				FunkinLua.luaTrace("initLuaShader: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
				#end
				return false;
			});
			
			funk.addLocalCallback("setSpriteShader", function(obj:String, shader:String) {
				if(!ClientPrefs.data.shaders) return false;

				#if (!flash && MODS_ALLOWED && sys)
				if(!funk.runtimeShaders.exists(shader) && !funk.initLuaShader(shader))
				{
					FunkinLua.luaTrace('setSpriteShader: Shader $shader is missing!', false, false, FlxColor.RED);
					return false;
				}

				var split:Array<String> = obj.split('.');
				var leObj:FlxSprite = LuaUtils.getObjectDirectly(split[0]);
				if(split.length > 1) {
					leObj = LuaUtils.getVarInArray(LuaUtils.getPropertyLoop(split), split[split.length-1]);
				}

				if(leObj != null) {
					var arr:Array<String> = funk.runtimeShaders.get(shader);
					leObj.shader = new FlxRuntimeShader(arr[0], arr[1]);
					return true;
				}
				#else
				FunkinLua.luaTrace("setSpriteShader: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
				#end
				return false;
			});
			funk.set(lua, "removeSpriteShader", function(obj:String) {
				var split:Array<String> = obj.split('.');
				var leObj:FlxSprite = LuaUtils.getObjectDirectly(split[0]);
				if(split.length > 1) {
					leObj = LuaUtils.getVarInArray(LuaUtils.getPropertyLoop(split), split[split.length-1]);
				}

				if(leObj != null) {
					leObj.shader = null;
					return true;
				}
				return false;
			});


			funk.set(lua, "getShaderBool", function(obj:String, prop:String) {
				#if (!flash && MODS_ALLOWED && sys)
				var shader:FlxRuntimeShader = getShader(obj);
				if (shader == null)
				{
					FunkinLua.luaTrace("getShaderBool: Shader is not FlxRuntimeShader!", false, false, FlxColor.RED);
					return null;
				}
				return shader.getBool(prop);
				#else
				FunkinLua.luaTrace("getShaderBool: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
				return null;
				#end
			});
			funk.set(lua, "getShaderBoolArray", function(obj:String, prop:String) {
				#if (!flash && MODS_ALLOWED && sys)
				var shader:FlxRuntimeShader = getShader(obj);
				if (shader == null)
				{
					FunkinLua.luaTrace("getShaderBoolArray: Shader is not FlxRuntimeShader!", false, false, FlxColor.RED);
					return null;
				}
				return shader.getBoolArray(prop);
				#else
				FunkinLua.luaTrace("getShaderBoolArray: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
				return null;
				#end
			});
			funk.set(lua, "getShaderInt", function(obj:String, prop:String) {
				#if (!flash && MODS_ALLOWED && sys)
				var shader:FlxRuntimeShader = getShader(obj);
				if (shader == null)
				{
					FunkinLua.luaTrace("getShaderInt: Shader is not FlxRuntimeShader!", false, false, FlxColor.RED);
					return null;
				}
				return shader.getInt(prop);
				#else
				FunkinLua.luaTrace("getShaderInt: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
				return null;
				#end
			});
			funk.set(lua, "getShaderIntArray", function(obj:String, prop:String) {
				#if (!flash && MODS_ALLOWED && sys)
				var shader:FlxRuntimeShader = getShader(obj);
				if (shader == null)
				{
					FunkinLua.luaTrace("getShaderIntArray: Shader is not FlxRuntimeShader!", false, false, FlxColor.RED);
					return null;
				}
				return shader.getIntArray(prop);
				#else
				FunkinLua.luaTrace("getShaderIntArray: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
				return null;
				#end
			});
			funk.set(lua, "getShaderFloat", function(obj:String, prop:String) {
				#if (!flash && MODS_ALLOWED && sys)
				var shader:FlxRuntimeShader = getShader(obj);
				if (shader == null)
				{
					FunkinLua.luaTrace("getShaderFloat: Shader is not FlxRuntimeShader!", false, false, FlxColor.RED);
					return null;
				}
				return shader.getFloat(prop);
				#else
				FunkinLua.luaTrace("getShaderFloat: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
				return null;
				#end
			});
			funk.set(lua, "getShaderFloatArray", function(obj:String, prop:String) {
				#if (!flash && MODS_ALLOWED && sys)
				var shader:FlxRuntimeShader = getShader(obj);
				if (shader == null)
				{
					FunkinLua.luaTrace("getShaderFloatArray: Shader is not FlxRuntimeShader!", false, false, FlxColor.RED);
					return null;
				}
				return shader.getFloatArray(prop);
				#else
				FunkinLua.luaTrace("getShaderFloatArray: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
				return null;
				#end
			});


			funk.set(lua, "setShaderBool", function(obj:String, prop:String, value:Bool) {
				#if (!flash && MODS_ALLOWED && sys)
				var shader:FlxRuntimeShader = getShader(obj);
				if(shader == null)
				{
					FunkinLua.luaTrace("setShaderBool: Shader is not FlxRuntimeShader!", false, false, FlxColor.RED);
					return false;
				}
				shader.setBool(prop, value);
				return true;
				#else
				FunkinLua.luaTrace("setShaderBool: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
				return false;
				#end
			});
			funk.set(lua, "setShaderBoolArray", function(obj:String, prop:String, values:Dynamic) {
				#if (!flash && MODS_ALLOWED && sys)
				var shader:FlxRuntimeShader = getShader(obj);
				if(shader == null)
				{
					FunkinLua.luaTrace("setShaderBoolArray: Shader is not FlxRuntimeShader!", false, false, FlxColor.RED);
					return false;
				}
				shader.setBoolArray(prop, values);
				return true;
				#else
				FunkinLua.luaTrace("setShaderBoolArray: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
				return false;
				#end
			});
			funk.set(lua, "setShaderInt", function(obj:String, prop:String, value:Int) {
				#if (!flash && MODS_ALLOWED && sys)
				var shader:FlxRuntimeShader = getShader(obj);
				if(shader == null)
				{
					FunkinLua.luaTrace("setShaderInt: Shader is not FlxRuntimeShader!", false, false, FlxColor.RED);
					return false;
				}
				shader.setInt(prop, value);
				return true;
				#else
				FunkinLua.luaTrace("setShaderInt: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
				return false;
				#end
			});
			funk.set(lua, "setShaderIntArray", function(obj:String, prop:String, values:Dynamic) {
				#if (!flash && MODS_ALLOWED && sys)
				var shader:FlxRuntimeShader = getShader(obj);
				if(shader == null)
				{
					FunkinLua.luaTrace("setShaderIntArray: Shader is not FlxRuntimeShader!", false, false, FlxColor.RED);
					return false;
				}
				shader.setIntArray(prop, values);
				return true;
				#else
				FunkinLua.luaTrace("setShaderIntArray: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
				return false;
				#end
			});
			funk.set(lua, "setShaderFloat", function(obj:String, prop:String, value:Float) {
				#if (!flash && MODS_ALLOWED && sys)
				var shader:FlxRuntimeShader = getShader(obj);
				if(shader == null)
				{
					FunkinLua.luaTrace("setShaderFloat: Shader is not FlxRuntimeShader!", false, false, FlxColor.RED);
					return false;
				}
				shader.setFloat(prop, value);
				return true;
				#else
				FunkinLua.luaTrace("setShaderFloat: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
				return false;
				#end
			});
			funk.set(lua, "setShaderFloatArray", function(obj:String, prop:String, values:Dynamic) {
				#if (!flash && MODS_ALLOWED && sys)
				var shader:FlxRuntimeShader = getShader(obj);
				if(shader == null)
				{
					FunkinLua.luaTrace("setShaderFloatArray: Shader is not FlxRuntimeShader!", false, false, FlxColor.RED);
					return false;
				}

				shader.setFloatArray(prop, values);
				return true;
				#else
				FunkinLua.luaTrace("setShaderFloatArray: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
				return true;
				#end
			});

			funk.set(lua, "setShaderSampler2D", function(obj:String, prop:String, bitmapdataPath:String) {
				#if (!flash && MODS_ALLOWED && sys)
				var shader:FlxRuntimeShader = getShader(obj);
				if(shader == null)
				{
					FunkinLua.luaTrace("setShaderSampler2D: Shader is not FlxRuntimeShader!", false, false, FlxColor.RED);
					return false;
				}

				// trace('bitmapdatapath: $bitmapdataPath');
				var value = Paths.image(bitmapdataPath);
				if(value != null && value.bitmap != null)
				{
					// trace('Found bitmapdata. Width: ${value.bitmap.width} Height: ${value.bitmap.height}');
					shader.setSampler2D(prop, value.bitmap);
					return true;
				}
				return false;
				#else
				FunkinLua.luaTrace("setShaderSampler2D: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
				return false;
				#end
			});
			
			// SHADER freak
			funk.set(lua, "addChromaticAbberationEffect", function(camera:String, chromeOffset:Float = 0.005) {
				PlayState.instance.addLuaShaderToCamera(camera, new ChromaticAberrationEffect(chromeOffset));
			});
			funk.set(lua, "addScanlineEffect", function(camera:String, lockAlpha:Bool = false) {
				PlayState.instance.addLuaShaderToCamera(camera, new ScanlineEffect(lockAlpha));
			});
			funk.set(lua, "addGrainEffect", function(camera:String, grainSize:Float, lumAmount:Float, lockAlpha:Bool = false) {
				PlayState.instance.addLuaShaderToCamera(camera, new GrainEffect(grainSize, lumAmount, lockAlpha));
			});
			funk.set(lua, "addTiltshiftEffect", function(camera:String, blurAmount:Float, center:Float) {
				PlayState.instance.addLuaShaderToCamera(camera, new TiltshiftEffect(blurAmount, center));
			});
			funk.set(lua, "addVCREffect", function(camera:String, glitchFactor:Float = 0.0, distortion:Bool = false, perspectiveOn:Bool = false, vignetteMoving:Bool = false) {
					PlayState.instance.addLuaShaderToCamera(camera, new VCRDistortionEffect(glitchFactor, distortion, perspectiveOn, vignetteMoving));
				});
			funk.set(lua, "addGlitchEffect", function(camera:String, waveSpeed:Float = 0.1, waveFrq:Float = 0.1, waveAmp:Float = 0.1) {
				PlayState.instance.addLuaShaderToCamera(camera, new GlitchEffect(waveSpeed, waveFrq, waveAmp));
			});
			funk.set(lua, "addWiggleEffect", function(camera:String, effectType:String = 'dreamy', waveSpeed:Float = 0.1, waveFrq:Float = 0.1, waveAmp:Float = 0.1) {
				PlayState.instance.addLuaShaderToCamera(camera, new WiggleEffectLUA(effectType, waveSpeed, waveFrq, waveAmp));
			});
			funk.set(lua, "addPulseEffect", function(camera:String, waveSpeed:Float = 0.1, waveFrq:Float = 0.1, waveAmp:Float = 0.1) {
				PlayState.instance.addLuaShaderToCamera(camera, new PulseEffect(waveSpeed, waveFrq, waveAmp));
			});
			funk.set(lua, "addDistortionEffect", function(camera:String, waveSpeed:Float = 0.1, waveFrq:Float = 0.1, waveAmp:Float = 0.1) {
				PlayState.instance.addLuaShaderToCamera(camera, new DistortBGEffect(waveSpeed, waveFrq, waveAmp));
			});
			funk.set(lua, "addInvertEffect", function(camera:String, lockAlpha:Bool = false) {
				PlayState.instance.addLuaShaderToCamera(camera, new InvertColorsEffect(lockAlpha));
			});
			funk.set(lua, "addGreyscaleEffect", function(camera:String) { // for dem funkies
				PlayState.instance.addLuaShaderToCamera(camera, new GreyscaleEffect());
			});
			funk.set(lua, "addGrayscaleEffect", function(camera:String) { // for dem funkies
				PlayState.instance.addLuaShaderToCamera(camera, new GreyscaleEffect());
			});
			funk.set(lua, "add3DEffect",
				function(camera:String, xrotation:Float = 0, yrotation:Float = 0, zrotation:Float = 0, depth:Float = 0) { // for dem funkies
					PlayState.instance.addLuaShaderToCamera(camera, new ThreeDEffect(xrotation, yrotation, zrotation, depth));
				});
			funk.set(lua, "addBloomEffect", function(camera:String, intensity:Float = 0.35, blurSize:Float = 1.0) {
				PlayState.instance.addLuaShaderToCamera(camera, new BloomEffect(blurSize / 512.0, intensity));
			});
			funk.set(lua, "clearEffects", function(camera:String) {
				PlayState.instance.clearShaderFromCamera(camera);
			});
		}
	}
	
	#if (!flash && sys)
	public static function getShader(obj:String):FlxRuntimeShader
	{
		var split:Array<String> = obj.split('.');
		var target:FlxSprite = null;
		if(split.length > 1) target = LuaUtils.getVarInArray(LuaUtils.getPropertyLoop(split), split[split.length-1]);
		else target = LuaUtils.getObjectDirectly(split[0]);

		if(target == null)
		{
			FunkinLua.luaTrace('Error on getting shader: Object $obj not found', false, false, FlxColor.RED);
			return null;
		}
		return cast (target.shader, FlxRuntimeShader);
	}
	#end
}