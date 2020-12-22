package game;

class Popup extends h2d.Object {

	public function new(parent : h2d.Object) { 
		super(parent);
	}

	static public function item(name : Data.ItemsKind, found : Bool, parent : h2d.Object) {
		var popup = new Popup(parent);
		var background = new h2d.Graphics(popup);

		var itemData = Data.items.get(name);

		var tile = hxd.Res.load(itemData.icon).toTile();
		var image = new h2d.Bitmap(tile, popup);
		image.setScale(Math.min(Const.POPUP_MIN_IMAGE_SIZE / tile.width, Const.POPUP_MIN_IMAGE_SIZE / tile.height));
		image.x = Const.POPUP_PADDING;
		image.y = Const.POPUP_PADDING;

		// creates the text.
		var textLayer = new h2d.Object(popup);
		var parseableText = if(found) Const.POPUP_TEXT_ITEM_FOUND;
		else Const.POPUP_TEXT_ITEM_LOST;
		var text = game.bubble.Text.parse(parseableText, [itemData.displayname], Const.POPUP_MAX_WIDTH);
		// variables used for calculating the dimensions of this new text element..
		// we should probably have something inside the text item.
		var textWidth = 0.;
		var textHeight = 0.;
		var row = 0.; // the current row tracker
		var workingWidth = 0.; // so we can compare the widths of different rows
		// the loop to add the text to the popup and calculate the dimensions.
		for (t in text) { 
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

		// calculates the overall width of the popup.
		var overallWidth = textWidth + Const.POPUP_PADDING * 3 + tile.width * image.scaleX;
		var overallHeight = tile.height * image.scaleY;
		if (overallHeight < textHeight) overallHeight = textHeight;
		overallHeight += 2 * Const.POPUP_PADDING;

		// setting the text location, this text object layer thing draws at the center, so we need
		// to move that center to the center of where we want the text to display.
		textLayer.x = image.x + tile.width * image.scaleX + Const.POPUP_PADDING + textWidth / 2;
		textLayer.y = overallHeight / 2;

		// draws the background because now we know the size we should be drawing.
		background.beginFill(Const.POPUP_BACKGROUND_COLOR, Const.POPUP_BACKGROUND_ALPHA);
		background.drawRoundedRect(0, 0, overallWidth, overallHeight, Const.POPUP_CORNER_RADIUS);
		background.endFill();

		// moves the popup to the right location on the screen.
		popup.x = Const.WORLDWIDTH/2 - overallWidth/2;

		// sets up the animation stuff.
		var timer = new sn.Timer(Const.POPUP_FADE_DURATION * 2 + Const.POPUP_WAIT_DURATION);
		timer.updateCallback = function() {
			// using the same timer to fade in and fade out.

			// fade out.
			if (timer.timer > Const.POPUP_FADE_DURATION + Const.POPUP_WAIT_DURATION) {
				popup.alpha = (Const.POPUP_FADE_DURATION * 2 + Const.POPUP_WAIT_DURATION - timer.timer) / Const.POPUP_FADE_DURATION;
			// fade in
			} else if (timer.timer < Const.POPUP_FADE_DURATION) {
				popup.alpha = timer.timer / Const.POPUP_FADE_DURATION;
			// the wait
			} else popup.alpha = 1;
		}	
		timer.finalCallback = () -> popup.remove();

	}

}