package game.utils;

class Corners {

	/**
	 * Draws the rounded corners.
	 * @param scene the working scene to make the corners in.
	 */
	static public function make(scene : h2d.Scene) {
		
		var graphic = new h2d.Graphics(scene);

		// sets the drawing style / information.
		graphic.beginFill(Const.BACKGROUNDCOLOR);
		graphic.lineStyle(2, Const.BACKGROUNDCOLOR);

		// top left
		graphic.moveTo(Const.SOFTCORNERRADIUS, 0);
		graphic.curveTo(0, 0, 0, Const.SOFTCORNERRADIUS);
		graphic.lineTo(-Const.RADIUSBLEED, Const.SOFTCORNERRADIUS);
		graphic.lineTo(-Const.RADIUSBLEED, -Const.RADIUSBLEED);
		graphic.lineTo(Const.SOFTCORNERRADIUS, -Const.RADIUSBLEED);
		graphic.lineTo(Const.SOFTCORNERRADIUS, 0);
		
		// top right
		graphic.moveTo(Const.WORLDWIDTH - Const.SOFTCORNERRADIUS, 0);
		graphic.curveTo(Const.WORLDWIDTH, 0, Const.WORLDWIDTH, Const.SOFTCORNERRADIUS);
		graphic.lineTo(Const.WORLDWIDTH + Const.RADIUSBLEED, Const.SOFTCORNERRADIUS);
		graphic.lineTo(Const.WORLDWIDTH + Const.RADIUSBLEED, -Const.RADIUSBLEED);
		graphic.lineTo(Const.WORLDWIDTH - Const.SOFTCORNERRADIUS, -Const.RADIUSBLEED);
		graphic.lineTo(Const.WORLDWIDTH - Const.SOFTCORNERRADIUS, 0);
		
		// bottom left
		graphic.moveTo(Const.SOFTCORNERRADIUS, Const.WORLDHEIGHT);
		graphic.curveTo(0, Const.WORLDHEIGHT, 0, Const.WORLDHEIGHT - Const.SOFTCORNERRADIUS);
		graphic.lineTo(-Const.RADIUSBLEED, Const.WORLDHEIGHT - Const.SOFTCORNERRADIUS);
		graphic.lineTo(-Const.RADIUSBLEED, Const.WORLDHEIGHT + Const.RADIUSBLEED);
		graphic.lineTo(Const.SOFTCORNERRADIUS, Const.WORLDHEIGHT + Const.RADIUSBLEED);
		graphic.lineTo(Const.SOFTCORNERRADIUS, Const.WORLDHEIGHT);
		
		// bottom right
		graphic.moveTo(Const.WORLDWIDTH - Const.SOFTCORNERRADIUS, Const.WORLDHEIGHT);
		graphic.curveTo(Const.WORLDWIDTH, Const.WORLDHEIGHT, Const.WORLDWIDTH, Const.WORLDHEIGHT - Const.SOFTCORNERRADIUS);
		graphic.lineTo(Const.WORLDWIDTH + Const.RADIUSBLEED, Const.WORLDHEIGHT - Const.SOFTCORNERRADIUS);
		graphic.lineTo(Const.WORLDWIDTH + Const.RADIUSBLEED, Const.WORLDHEIGHT + Const.RADIUSBLEED);
		graphic.lineTo(Const.WORLDWIDTH - Const.SOFTCORNERRADIUS, Const.WORLDHEIGHT + Const.RADIUSBLEED);
		graphic.lineTo(Const.WORLDWIDTH - Const.SOFTCORNERRADIUS, Const.WORLDHEIGHT);

		// finished drawing.
		graphic.endFill();
	}
}