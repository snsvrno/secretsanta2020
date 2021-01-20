package game.map;

class Location extends h2d.Object {
	
	private var icon : h2d.Bitmap;
	private var shaderOver : shader.Highlight;
	private var shaderDisabled : shader.Darken;
	private var target : Data.ScenesKind;
	private var interactiveLayer : h2d.Object;
	private var actorIcons : h2d.Object;
	private var actorIconsList : Array<h2d.Object> = [];

	private var text : String;
	private var textX : Float;
	private var textY : Float;

	public var setLocationText : (?name : String, ?x : Float, ?y : Float) -> Void;

	public var data(default, null) : Data.Locations;
	
	public function new(location : Data.Locations, ?parent : h2d.Object) {
		super(parent);

		data = location;

		// loads and sets the image to use.
		var tile = hxd.Res.load(location.icon).toTile();
		icon = new h2d.Bitmap(tile, this);
		icon.name = "icon";

		// creates the shader that will be used when mouse-overing
		shaderOver = new shader.Highlight(Const.LOCATION_HIGHLIGHT_ALPHA);
		shaderDisabled = new shader.Darken(Const.LOCATION_UNACCESSABLE_ALPHA);

		// makes the interactives so we can do mouse overs and clicks
		interactiveLayer = new h2d.Object(this);
		interactiveLayer.name = "interactiveLayer";
		createInteractives(location.collision);

		textY = tile.height / 2;
		textX = tile.width / 2;
		text = location.name;

		// creates the actorIcons layer
		actorIcons = new h2d.Object(this);
		actorIcons.name = "actorIcons";

		target = location.scene.id;

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
		setLocationText(text, textX + x, textY + y);
		icon.addShader(shaderOver);
	}

	private function out(?e : hxd.Event) {
		setLocationText();
		icon.removeShader(shaderOver);
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

	public function updateIcons() {
		// removes all the old icons.

		while (actorIconsList.length > 0) actorIcons.removeChild(actorIconsList.pop());

		// gets new sightings
		var sightings = Game.variables.seen(data.id, Game.currentPeriod());
		for (i in 0 ... sightings.length) {
			var tile = hxd.Res.load(Data.characters.get(sightings[i]).icon).toTile();
			var bitmap = new h2d.Bitmap(tile, actorIcons);
			actorIconsList.push(bitmap);
			var scale = Math.min(Const.MAP_ICON_SIZE / tile.width, Const.MAP_ICON_SIZE / tile.height);
			bitmap.setScale(scale);
			bitmap.x = data.iconslots[i].x - tile.width / 2 * bitmap.scaleX;
			bitmap.y = data.iconslots[i].y - tile.height / 2 * bitmap.scaleX;
		}
	}

}