package game.map;

class Location extends h2d.Object {
	
	private var icon : h2d.Bitmap;
	private var shaderOver : shader.Highlight;
	private var text : h2d.Text;
	private var target : Data.ScenesKind;
	private var interactive : h2d.Interactive;
	
	public function new(location : Data.Locations, ?parent : h2d.Object) {
		super(parent);

		var tile = hxd.Res.load(location.icon).toTile();
		icon = new h2d.Bitmap(tile, this);

		shaderOver = new shader.Highlight(0.25);

		interactive = new h2d.Interactive(tile.width, tile.height, this);
		interactive.onOver = over;
		interactive.onOut = out;
		interactive.onClick = click;

		text = new h2d.Text(hxd.res.DefaultFont.get(), this);
		text.alpha = 0;
		text.text = location.name;
		text.filter = new h2d.filter.DropShadow(0, 0, 0, 1, 0.5);
		text.y = tile.height + 2;
		text.x = - text.textWidth / 2 + tile.width/2;

		target = location.scene.name;

		x = location.position.x;
		y = location.position.y;
	}

	private function over(?e : hxd.Event) {
		icon.addShader(shaderOver);
		text.alpha = 1;
	}

	private function out(?e : hxd.Event) {
		icon.removeShader(shaderOver);
		text.alpha = 0;
	}

	private function click(?e : hxd.Event) {
		Game.changeScene(target);
	}

	public function disable() {
		removeChild(interactive);
		// in the case that this is the location that changes a scene
		// and causes the disabling.
		out();
	}

	public function enable() {
		if (interactive.parent != this) addChild(interactive);
	}

}