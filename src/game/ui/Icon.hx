package game.ui;

class Icon extends game.ui.Element {

	override public function getHeight() : Float return image.tile.height * scaleY;
	override public function getWidth() : Float return image.tile.width * scaleX;

	private var horizontal : game.ui.alignment.Horizontal = Left;
	private var vertical : game.ui.alignment.Vertical = Top;

	private var image : h2d.Bitmap;

	public function new(tile : h2d.Tile, ?parent : h2d.Object) {
		super(parent);

		image = new h2d.Bitmap(tile, this);
		setScale(Math.min(Const.ICON_MAX_SIZE / tile.width, Const.ICON_MAX_SIZE / tile.height));

		#if debug
		if (Debug.UI_BOXES_ICONS) {
			var background = new h2d.Graphics(image);
			background.beginFill(0xFF0000,0.15);
			background.drawRect(0,0, image.tile.width, image.tile.height);
			background.endFill();

			var background2 = new h2d.Graphics(this);
			background2.lineStyle(1, 0xff0000);
			background2.beginFill(0xFF0000,1);
			background2.drawCircle(0, 0, 6);
			background2.endFill();
		}
		#end
	}

	override public function setAlignment(?horizontal : game.ui.alignment.Horizontal, ?vertical : game.ui.alignment.Vertical) {

		if (horizontal != null) this.horizontal = horizontal;
		if (vertical != null) this.vertical = vertical;

		switch(this.horizontal) {
			case Left: image.x = 0;
			case Center: image.x = -image.tile.width / 2;
			case Right: image.x = -image.tile.width;
		}

		switch(this.vertical) {
			case Top: image.y = 0;
			case Middle: image.y = -image.tile.height / 2;
			case Bottom: image.y = -image.tile.height;
		}
	}
}