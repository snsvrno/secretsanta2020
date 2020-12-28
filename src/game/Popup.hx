package game;

class Popup extends h2d.Object {

	static private var queue : Array<Popup> = [];
	static private var activeItem : Null<Popup> = null;
	static private function processQueue() {
		if (activeItem == null && queue.length > 0) {
			activeItem = queue.shift();

			activeItem.setAnimation(activeItem.duration);
		}
	}

	private var background : h2d.Graphics;
	private var image : h2d.Bitmap;
	private var textLayer : h2d.Object;
	private var textItems : Array<game.bubble.Text>;
	private var duration : Null<Float>;

	public function new(parent : h2d.Object) { 
		super(parent);
		
		background = new h2d.Graphics(this);
		textLayer = new h2d.Object(this);
	}

	private function setImage(path : String) {
		// cleans up the old image if it isn't set.
		if (image != null) image.remove();

		// loads the new image.
		var tile = hxd.Res.load(path).toTile();
		setImageRaw(tile);
	}

	private function setImageRaw(tile : h2d.Tile) {
		image = new h2d.Bitmap(tile, this);
		image.setScale(Math.min(Const.POPUP_MIN_IMAGE_SIZE / tile.width, Const.POPUP_MIN_IMAGE_SIZE / tile.height));
		image.x = Const.POPUP_PADDING;
		image.y = Const.POPUP_PADDING;
	}

	private function setText(template : String, ?variables : Array<String>, ?maxWidth : Float) {
		textItems = game.bubble.Text.parse(template, variables, maxWidth);
	}

	private function updateAppearance() {

		var textWidth = 0.;
		var textHeight = 0.;
		var row = 0.; // the current row tracker
		var workingWidth = 0.; // so we can compare the widths of different rows
		// the loop to add the text to the popup and calculate the dimensions.
		for (t in textItems) { 
			textLayer.addChild(t);
			// for calculating the overall height, we need to check if this text item is on
			// a different row elevation than the previous item. this will not work with
			// dancing or italics text ... hopefully we don't have any.
			//
			// TODO : BUG : doesn't accurately calculate the height of the text in all instances.
			if (row == 0. || row != t.y) { 
				row = t.y;
				textHeight += t.height;
				// sets and resets the width
				if (workingWidth > textWidth) textWidth = workingWidth;
				workingWidth = t.width;
			} else {
			// claculates the width, but we need to take into account the rows. 
				workingWidth += t.width;
			}
		}
	
		// a last check to makesure we capture the width
		if (workingWidth > textWidth) textWidth = workingWidth;

		var tileW = 0.;
		var tileH = 0.;
		if (image != null) {
			tileW = image.tile.width * image.scaleX;
			tileH = image.tile.height * image.scaleY;
		}

		// calculates the overall width of the popup.
		var overallWidth = textWidth + Const.POPUP_PADDING * 3 + tileW;
		var overallHeight = tileH;
		if (overallHeight < textHeight) overallHeight = textHeight;
		overallHeight += 2 * Const.POPUP_PADDING;
		
		// setting the text location, this text object layer thing draws at the center, so we need
		// to move that center to the center of where we want the text to display.
		if (image != null) textLayer.x = image.x + tileW + Const.POPUP_PADDING + textWidth / 2;
		else textLayer.x = Const.POPUP_PADDING + textWidth / 2;
		textLayer.y = overallHeight / 2;

		// draws the background because now we know the size we should be drawing.
		background.beginFill(Const.POPUP_BACKGROUND_COLOR, Const.POPUP_BACKGROUND_ALPHA);
		background.drawRoundedRect(0, 0, overallWidth, overallHeight, Const.POPUP_CORNER_RADIUS);
		background.endFill();

		// moves the popup to the right location on the screen.
		x = Const.WORLD_WIDTH/2 - overallWidth/2;
	}

	private function setAnimation(?duration : Float) {
		
		var waitTime = if (duration != null) duration; else Const.POPUP_WAIT_DURATION;

		// sets up the animation stuff.
		var timer = new sn.Timer(Const.POPUP_FADE_DURATION * 2 + waitTime);
		timer.updateCallback = function() {
			// using the same timer to fade in and fade out.

			// fade out.
			if (timer.timer > Const.POPUP_FADE_DURATION + waitTime) {
				alpha = (Const.POPUP_FADE_DURATION * 2 + waitTime - timer.timer) / Const.POPUP_FADE_DURATION;
			// fade in
			} else if (timer.timer < Const.POPUP_FADE_DURATION) {
				alpha = timer.timer / Const.POPUP_FADE_DURATION;
			// the wait
			} else alpha = 1;
		}	
		timer.finalCallback = function() {
			activeItem = null;
			remove();
			processQueue();
		}
	}

	static public function text(text : String, ?duration : Float, parent : h2d.Object) {
		var popup = new Popup(parent);
		popup.setText(text);
		popup.updateAppearance();
		popup.duration = duration;

		popup.alpha = 0;
		queue.push(popup);
		processQueue();
	} 

	static public function item(name : Data.ItemsKind, found : Bool, parent : h2d.Object) {
		var popup = new Popup(parent);

		var itemData = Data.items.get(name);
		popup.setImage(itemData.icon);

		// creates the text.
		var parseableText = if(found) Const.POPUP_TEXT_ITEM_FOUND;
		else Const.POPUP_TEXT_ITEM_LOST;
		popup.setText(parseableText, [itemData.displayname], Const.POPUP_MAX_WIDTH);

		popup.updateAppearance();

		popup.alpha = 0;
		queue.push(popup);
		processQueue();
	}

	static public function achievement(achievement : Data.Achievements, parent : h2d.Object) {
		var popup = new Popup(parent);
		
		popup.setImageRaw(hxd.Res.clock.sun_11.toTile());

		// creates the text.
		popup.setText(Const.ACHIEVEMENTS_POPUP_TEXT, [achievement.title], Const.POPUP_MAX_WIDTH);
		
		popup.updateAppearance();

		popup.alpha = 0;
		queue.push(popup);
		processQueue();
	}

	static public function clearQueue() {
		while (queue.length > 0) queue.pop();
		if (activeItem != null) { 
			activeItem.remove();
			activeItem = null;
		}
	}

}