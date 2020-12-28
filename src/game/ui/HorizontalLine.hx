package game.ui;

class HorizontalLine extends game.ui.Element {

	override public function getHeight() : Float return height;
	override public function getWidth() : Float return width;

	private var line : h2d.Graphics;
	private var width : Float;
	private var height : Float = 2;

	public function new(width : Int) {
		super();

		this.width = width;

		line = new h2d.Graphics(this);
		line.lineStyle(height, 0x000000);
		line.moveTo(-width/2,0);
		line.lineTo(width/2, 0);

	}
}