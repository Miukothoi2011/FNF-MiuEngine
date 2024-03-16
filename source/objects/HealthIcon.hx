package objects;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	private var isOldIcon:Bool = false;
	private var isPlayer:Bool = false;
	private var char:String = '';

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

	private var iconOffsets:Array<Float> = [0, 0, 0];
	public function changeIcon(char:String, ?allowGPU:Bool = true) {
		if(this.char != char) {
			var name:String = 'icons/' + char;
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-' + char; //Older versions of psych engine's support
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-face'; //Prevents crash from missing icon
			var graphic = Paths.image(name, allowGPU);
			
			loadGraphic(graphic); // Load icon first to check width icon size to if icon has 3 frames or 2 frames.
			var width2 = width;
			if (width >= 450 || width != 600 && width >= 900 || width != 1200 && width >= 1800) {
				loadGraphic(graphic, true, Math.floor(/*graphic.*/width / 3), Math.floor(/*graphic.*/height));
				iconOffsets[0] = (width - 150) / 3;
				iconOffsets[1] = (width - 150) / 3;
				iconOffsets[2] = (width - 150) / 3;
			} else if (width >= 300 || width != 450 || width >= 1200 && width != 1800) {
				loadGraphic(graphic, true, Math.floor(/*graphic.*/width / 2), Math.floor(/*graphic.*/height));
				iconOffsets[0] = (width - 150) / 2;
				iconOffsets[1] = (width - 150) / 2;
			}
			updateHitbox();
			
			if(width2 >= 450 || width2 != 600 && width2 >= 900 || width2 != 1200 && width2 >= 1800)
				animation.add(char, [0, 1, 2], 0, false, isPlayer);
			else if(width2 >= 300 || width2 != 450 || width2 >= 1200 && width2 != 1800)
				animation.add(char, [0, 1], 0, false, isPlayer);

			animation.play(char);
			this.char = char;

			if(char.endsWith('-pixel')) antialiasing = false;
			else antialiasing = ClientPrefs.data.antialiasing;
		}
	}

	override function updateHitbox()
	{
		super.updateHitbox();
		offset.x = iconOffsets[0];
		offset.y = iconOffsets[1];
	}

	public function getCharacter():String
		return char;
}
