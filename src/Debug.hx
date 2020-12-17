class Debug {
	static public function mouseCoordinatesOverlay(s2d : h2d.Scene) {

		var interactive = new h2d.Interactive(Const.WORLDWIDTH, Const.WORLDHEIGHT, s2d);
		interactive.propagateEvents = true;

		var font = hxd.res.DefaultFont.get();
		var xc = new h2d.Text(font, interactive);

		interactive.onMove = function(e : hxd.Event) {
			xc.text = '${Math.floor(e.relX / Const.WORLDWIDTH * 100) / 100}, ${Math.floor(e.relY / Const.WORLDHEIGHT * 100) / 100}';
			xc.x = e.relX;
			xc.y = e.relY;
		};
	}

	static public function warning(s2d : h2d.Scene) {
		var font = hxd.res.DefaultFont.get();
		var warningtext = new h2d.Text(font, s2d);
		warningtext.text = "DEBUG ENABLED!";
		warningtext.setScale(3);
	}
}