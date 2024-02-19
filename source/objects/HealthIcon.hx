package objects;

enum abstract IconType(Int) to Int from Int //abstract so it can hold int values for the frame count
{
    var SINGLE = 0;
    var DEFAULT = 1;
    var WINNING = 2;
}
class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	private var isOldIcon:Bool = false;
	private var isPlayer:Bool = false;
	private var char:String = '';
	public var type:IconType = DEFAULT;

	public function new(char:String = 'bf', isPlayer:Bool = false, ?allowGPU:Bool = true)
	{
		super();
		isOldIcon = (char == 'bf-old');
		this.isPlayer = isPlayer;
		changeIcon(char, allowGPU);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 12, sprTracker.y - 30);
	}

	//private var iconOffsets:Array<Float> = [0, 0];
	public var offsets(default, set):Array<Float> = [0, 0];
	public function changeIcon(char:String, ?allowGPU:Bool = true) {
		if(this.char != char) {
			var name:String = 'icons/' + char;
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-' + char; //Older versions of psych engine's support
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-face'; //Prevents crash from missing icon
			var file:FlxGraphic = Paths.image(name);
			
			/*var graphic = Paths.image(name, allowGPU);
			loadGraphic(graphic, true, Math.floor(graphic.width / 2), Math.floor(graphic.height));
			iconOffsets[0] = (width - 150) / 2;
			iconOffsets[1] = (height - 150) / 2;
			updateHitbox();

			animation.add(char, [0, 1], 0, false, isPlayer);
			animation.play(char);
			this.char = char;*/
			type = (file.width < 200 ? SINGLE : ((file.width > 199 && file.width < 301) ? DEFAULT : WINNING));

			loadGraphic(file, true, Math.floor(file.width / (type+1)), file.height);
			offsets[0] = offsets[1] = (width - 150) / (type+1);
			var frames:Array<Int> = [];
			for (i in 0...type+1) frames.push(i);
			animation.add(char, frames, 0, false, isPlayer);
			animation.play(char);
			this.char = char;

			if(char.endsWith('-pixel'))
				antialiasing = false;
			else
				antialiasing = ClientPrefs.data.antialiasing;
		}
	}

	override function updateHitbox()
	{
		super.updateHitbox();
		offset.x = offsets[0];
		offset.y = offsets[1];
	}

	function set_offsets(newArr:Array<Float>):Array<Float>
	{
		offsets = newArr;
		offset.x = offsets[0];
		offset.y = offsets[1];
		return offsets;
	}

	public function getCharacter():String {
		return char;
	}
}
