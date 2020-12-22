package game.ui;

class Clock extends h2d.Object {

	inline static private var sectionWidth : Int = 12;
	inline static private var sectionHeight : Int = 12;
	inline static private var lineSize : Int = 1;
	inline static private var triSize : Float = 0.5;
	inline static private var padding : Int = 2;

	inline static private var colorDisable : Int = 0xAAAAAA;
	inline static private var colorBackground : Int = 0x444444;
	inline static private var colorSpent : Int = 0x555555;
	inline static private var colorAvailable : Int = 0x00FF45;
	inline static private var lineColor : Int = 0x222222;

	public var width(default, null) : Float;
	public var height(default, null) : Float;

	private var graphics : h2d.Graphics;

	public function new(parent : h2d.Object) {
		super(parent);

		graphics = new h2d.Graphics(this);

		width = Const.CLOCK_PERIODS * Const.CLOCK_SLOTS * (sectionWidth + 2 * lineSize) + 2 * padding;
		height = sectionHeight + padding;
	}

	public function drawState(clock : game.Clock) {		
		graphics.clear();

		// background
		graphics.beginFill(colorBackground);
		graphics.drawRect(0, 0, width, height);

		graphics.lineStyle(lineSize, lineColor);

		graphics.setColor(colorDisable);
		for (i in 0 ... Const.CLOCK_PERIODS) {
			var px = i * Const.CLOCK_SLOTS * (sectionWidth + 2 * lineSize) + padding;
			for (j in 0 ... Const.CLOCK_SLOTS) {
				if (clock.periodNumber() == (i+1) && clock.slotNumber() == (j+1)) graphics.setColor(colorAvailable);
				graphics.drawRect(px + j * sectionWidth, 0, sectionWidth, sectionHeight);
			}
		}

		// draws the pointer arrow.
		graphics.lineStyle(0);
		graphics.setColor(colorBackground);
		var sx = padding + sectionWidth / 2 + (clock.periodNumber() - 1) * (sectionWidth + 2 * lineSize) * Const.CLOCK_SLOTS; 
		var sy = sectionHeight + padding / 2;
		graphics.moveTo(sx, sy - sectionHeight * triSize);
		graphics.lineTo(sx - sectionWidth * triSize, sy);
		graphics.lineTo(sx + sectionWidth * triSize, sy);

		graphics.endFill();

		// draws some extra lines
		// triangle lines
		graphics.lineStyle(1);
		graphics.moveTo(sx - sectionWidth * triSize, sy);
		graphics.lineTo(sx, sy - sectionHeight * triSize);
		graphics.lineTo(sx + sectionWidth * triSize, sy);

	}
}