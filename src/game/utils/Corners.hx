package game.utils;

class Corners {

	/**
	 * Draws the rounded corners.
	 * @param scene the working scene to make the corners in.
	 */
	static public function make(scene : h2d.Scene) {
		
		var graphic = new h2d.Graphics(scene);

		// sets the drawing style / information.
		graphic.beginFill(Const.BACKGROUND_COLOR);
		graphic.lineStyle(2, Const.BACKGROUND_COLOR);

		// top left
		graphic.moveTo(Const.WORLD_CORNER_RADIUS, 0);
		graphic.curveTo(0, 0, 0, Const.WORLD_CORNER_RADIUS);
		graphic.lineTo(-Const.WORLD_CORNER_RADIUS_OVERSHOOT, Const.WORLD_CORNER_RADIUS);
		graphic.lineTo(-Const.WORLD_CORNER_RADIUS_OVERSHOOT, -Const.WORLD_CORNER_RADIUS_OVERSHOOT);
		graphic.lineTo(Const.WORLD_CORNER_RADIUS, -Const.WORLD_CORNER_RADIUS_OVERSHOOT);
		graphic.lineTo(Const.WORLD_CORNER_RADIUS, 0);
		
		// top right
		graphic.moveTo(Const.WORLD_WIDTH - Const.WORLD_CORNER_RADIUS, 0);
		graphic.curveTo(Const.WORLD_WIDTH, 0, Const.WORLD_WIDTH, Const.WORLD_CORNER_RADIUS);
		graphic.lineTo(Const.WORLD_WIDTH + Const.WORLD_CORNER_RADIUS_OVERSHOOT, Const.WORLD_CORNER_RADIUS);
		graphic.lineTo(Const.WORLD_WIDTH + Const.WORLD_CORNER_RADIUS_OVERSHOOT, -Const.WORLD_CORNER_RADIUS_OVERSHOOT);
		graphic.lineTo(Const.WORLD_WIDTH - Const.WORLD_CORNER_RADIUS, -Const.WORLD_CORNER_RADIUS_OVERSHOOT);
		graphic.lineTo(Const.WORLD_WIDTH - Const.WORLD_CORNER_RADIUS, 0);
		
		// bottom left
		graphic.moveTo(Const.WORLD_CORNER_RADIUS, Const.WORLD_HEIGHT);
		graphic.curveTo(0, Const.WORLD_HEIGHT, 0, Const.WORLD_HEIGHT - Const.WORLD_CORNER_RADIUS);
		graphic.lineTo(-Const.WORLD_CORNER_RADIUS_OVERSHOOT, Const.WORLD_HEIGHT - Const.WORLD_CORNER_RADIUS);
		graphic.lineTo(-Const.WORLD_CORNER_RADIUS_OVERSHOOT, Const.WORLD_HEIGHT + Const.WORLD_CORNER_RADIUS_OVERSHOOT);
		graphic.lineTo(Const.WORLD_CORNER_RADIUS, Const.WORLD_HEIGHT + Const.WORLD_CORNER_RADIUS_OVERSHOOT);
		graphic.lineTo(Const.WORLD_CORNER_RADIUS, Const.WORLD_HEIGHT);
		
		// bottom right
		graphic.moveTo(Const.WORLD_WIDTH - Const.WORLD_CORNER_RADIUS, Const.WORLD_HEIGHT);
		graphic.curveTo(Const.WORLD_WIDTH, Const.WORLD_HEIGHT, Const.WORLD_WIDTH, Const.WORLD_HEIGHT - Const.WORLD_CORNER_RADIUS);
		graphic.lineTo(Const.WORLD_WIDTH + Const.WORLD_CORNER_RADIUS_OVERSHOOT, Const.WORLD_HEIGHT - Const.WORLD_CORNER_RADIUS);
		graphic.lineTo(Const.WORLD_WIDTH + Const.WORLD_CORNER_RADIUS_OVERSHOOT, Const.WORLD_HEIGHT + Const.WORLD_CORNER_RADIUS_OVERSHOOT);
		graphic.lineTo(Const.WORLD_WIDTH - Const.WORLD_CORNER_RADIUS, Const.WORLD_HEIGHT + Const.WORLD_CORNER_RADIUS_OVERSHOOT);
		graphic.lineTo(Const.WORLD_WIDTH - Const.WORLD_CORNER_RADIUS, Const.WORLD_HEIGHT);

		// finished drawing.
		graphic.endFill();
	}
}