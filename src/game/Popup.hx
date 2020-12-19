package game;

class Popup extends h2d.Object {

	static private var minImageSize : Int = 50;
	static private var padding : Int = 10;
	static private var maxWidth : Int = 200;
	static private var fadeDuration : Float = 0.25;
	static private var waitDuration : Float = 1.5;

	static private var foundText : Array<String> = ["You have found", "!"];
	static private var lostText : Array<String> = ["You no longer have", "."];
	
	public function new(parent : h2d.Object) { 
		super(parent);
	}

	static public function item(name : Data.ItemsKind, found : Bool, parent : h2d.Object) {
		var popup = new Popup(parent);
		var background = new h2d.Graphics(popup);


		var itemData = Data.items.get(name);

		var tile = hxd.Res.load(itemData.icon).toTile();
		var image = new h2d.Bitmap(tile, popup);
		image.setScale(Math.min(minImageSize / tile.width, minImageSize / tile.height));
		image.x = padding;
		image.y = padding;

		var text = new h2d.Text(hxd.res.DefaultFont.get(), popup);
		if (found) text.text = foundText[0] + " " + itemData.displayname + " " + foundText[1];
		else text.text = lostText[0] + " " + itemData.displayname + " " + lostText[1];
		text.setScale(1.5);
		text.maxWidth = maxWidth / text.scaleY;

		text.x = image.x + tile.width * image.scaleX + padding;
		text.y = padding;

		var overallWidth = text.x + text.textWidth * text.scaleX + padding;
		var overallHeight = 2 * padding + text.textHeight * text.scaleY;
		
		background.beginFill(0x000000, 0.85);
		background.drawRoundedRect(0, 0, overallWidth, overallHeight, 2.0);
		background.endFill();


		popup.x = Const.WORLDWIDTH/2 - overallWidth/2;

		// sets up the animation stuff.
		var timer = new sn.Timer(fadeDuration * 2 + waitDuration);
		timer.updateCallback = function() {
			// using the same timer to fade in and fade out.

			// fade out.
			if (timer.timer > fadeDuration + waitDuration) {
				popup.alpha = (fadeDuration * 2 + waitDuration - timer.timer) / fadeDuration;
			// fade in
			} else if (timer.timer < fadeDuration) {
				popup.alpha = timer.timer / fadeDuration;
			// the wait
			} else popup.alpha = 1;
		}	
		timer.finalCallback = () -> popup.remove();

	}

}