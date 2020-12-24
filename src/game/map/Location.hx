package game.map;

class Location extends h2d.Object {
	
	private var icon : h2d.Bitmap;
	private var shaderOver : shader.Highlight;
	private var shaderDisabled : shader.Darken;
	private var text : h2d.Text;
	private var target : Data.ScenesKind;
	private var interactiveLayer : h2d.Object;

	public var data(default, null) : Data.Locations;
	
	public function new(location : Data.Locations, ?parent : h2d.Object) {
		super(parent);

		data = location;

		// loads and sets the image to use.
		var tile = hxd.Res.load(location.icon).toTile();
		icon = new h2d.Bitmap(tile, this);

		// creates the shader that will be used when mouse-overing
		shaderOver = new shader.Highlight(Const.LOCATION_HIGHLIGHT_ALPHA);
		shaderDisabled = new shader.Darken(Const.LOCATION_UNACCESSABLE_ALPHA);

		// makes the interactives so we can do mouse overs and clicks
		interactiveLayer = new h2d.Object(this);
		createInteractives(location.collision);

		// creates the mouse over text.
		text = new h2d.Text(hxd.res.DefaultFont.get(), this);
		text.alpha = 0;
		text.setScale(Const.LOCATION_TEXT_SIZE);
		text.text = location.name;
		text.filter = new h2d.filter.DropShadow(0, 0, 0, 1, 0.5);
		// centers the text over the image.
		text.y = - text.textHeight * text.scaleY / 2 + tile.height / 2;
		text.x = - text.textWidth * text.scaleX / 2 + tile.width / 2;

		target = location.scene.name;

		x = location.position.x;
		y = location.position.y;
	}


	/**
	 * Creates the interactives based on the definied interactives in the cdb file.
	 * @param collisions 
	 */
	private function createInteractives(collisions : cdb.Types.ArrayRead<Data.Locations_collision>) {
		for (c in collisions) {

			#if debug
			// if we are in debug build, then it will draw the interactives as a graphic, so
			// we can see the coverage.
			var interactiveBox = new h2d.Graphics(interactiveLayer);
			interactiveBox.beginFill(0xFF0000, 0.25);
			interactiveBox.drawRect(c.x, c.y, c.w, c.h);
			interactiveBox.endFill();
			interactiveBox.alpha = 0;
			Debug.displayItems.push(interactiveBox);
			#end

			var interactive = new h2d.Interactive(c.w, c.h, interactiveLayer);
			interactive.x = c.x;
			interactive.y = c.y;
			interactive.onOver = over;
			interactive.onOut = out;
			interactive.onClick = click;
		}
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
		removeChild(interactiveLayer);
		// in the case that this is the location that changes a scene
		// and causes the disabling.
		out();
	}

	public function notAccessable(?reset : Bool = false) {
		if (reset) icon.removeShader(shaderDisabled);
		else icon.addShader(shaderDisabled);
	}

	public function enable() {
		if (interactiveLayer.parent != this) addChild(interactiveLayer);
	}

}