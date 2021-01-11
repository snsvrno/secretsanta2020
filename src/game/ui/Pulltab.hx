package game.ui;

class Pulltab extends h2d.Object {
	private var items : Map<Data.ItemsKind, game.ui.Icon> = new Map();
	
	private var tab : h2d.Graphics;
	
	private var icon : h2d.Object;
	private var iconScale : Float;
	private var tabWidth : Float;
	private var tabHeight : Float;

	private var overallinteractive : h2d.Interactive;

	private var content : h2d.Graphics;
	private var contentHeight(default, set) : Float;
	private function set_contentHeight(value : Float) : Float {
		overallinteractive.height = value;
		return contentHeight = value;
	}

	public function new(iconImage : h2d.Tile, ?parent : h2d.Object) {
		super(parent);
		createIcon(iconImage);

		content = new h2d.Graphics();
		overallinteractive = new h2d.Interactive(Const.WORLD_WIDTH, contentHeight, content);
		overallinteractive.onOut = deactivate;
	}

	override function onAdd() {
		super.onAdd();
		if (content != null) { 
			drawContent();
			paintTabBackground();
		}
	}

	private function activate(?e : hxd.Event) {
		addChild(content);
		drawContent();
		tab.y = contentHeight;
		icon.setScale(iconScale);
	}

	private function deactivate(?e : hxd.Event) {
		removeChild(content);
		tab.y = 0;
	}

	private function drawContent() {
		content.clear();
		content.beginFill(Const.BACKPACK_COLOR);
		content.drawRoundedRect(0, 0, Const.WORLD_WIDTH, contentHeight, Const.BACKPACK_ROUNDEDCORNERS);
		content.drawRect(0,0, Const.WORLD_WIDTH, contentHeight / 2);
		content.endFill();
	}
	private function createIcon(tile : h2d.Tile) {

		tab = new h2d.Graphics(this);

		// creates the icon.
		icon = new h2d.Object(tab);
		var rawIcon = new h2d.Bitmap(tile, icon);
		rawIcon.x = -tile.width/2;
		rawIcon.y = -tile.height/2;
		iconScale = Math.min(Const.BACKPACK_ICONSIZE / tile.width, Const.BACKPACK_ICONSIZE / tile.height);
		icon.setScale(iconScale);
		icon.x = Const.BACKPACK_ICONPADDING + tile.width / 2 * iconScale;
		icon.y = Const.BACKPACK_ICONPADDING + tile.height / 2 * iconScale;
		
		tabWidth = tile.width * iconScale + 2 * Const.BACKPACK_ICONPADDING;
		tabHeight = tile.height * iconScale + 2 * Const.BACKPACK_ICONPADDING;
		paintTabBackground();

		var interactive = new h2d.Interactive(tabWidth, tabHeight, tab);
		interactive.onOver = function (e : hxd.Event) {
			paintTabBackground(Const.BACKPACK_COLOROVER);
			icon.alpha = Const.BACKPACK_ICONOVERALPHA;
		}
		interactive.onOut = function (e : hxd.Event) { 
			paintTabBackground();
			icon.alpha = 1;
		}
		interactive.onClick = activate;
	}

	private function paintTabBackground(?color : Int = Const.BACKPACK_COLOR) {
		tab.clear();
		tab.beginFill(color);
		tab.drawRoundedRect(0, 0, tabWidth, tabHeight, Const.BACKPACK_ICONROUNDEDCORNERS);
		tab.drawRect(0, 0, tabWidth, tabHeight/2);
		tab.endFill();
	}
}