package game.ui;

import h2d.Interactive;

class Backpack extends h2d.Object {
	private var items : Map<Data.ItemsKind, game.ui.Icon> = new Map();
	
	private var tab : h2d.Graphics;
	private var icon : h2d.Object;
	private var iconScale : Float;
	private var tabWidth : Float;
	private var tabHeight : Float;

	private var notificationTimer : sn.Timer;

	private var content : h2d.Graphics;
	private var contentHeight : Float;

	private var contentStack : game.ui.HStack;

	private var title : h2d.Text;
	static private var normalTitleText : String = "Backpack";
	private var description : h2d.Text;
	static private var normalDescriptionText : String = "";

	public function new(?parent : h2d.Object) {
		super(parent);
		createIcon();
		createContent();

		notificationTimer = new sn.Timer(Const.BACKPACK_NOTIFICATIONTIMER, true);
		notificationTimer.infinite = true;
		notificationTimer.stop();
		notificationTimer.updateCallback = function() {
			icon.setScale(iconScale + Math.sin(notificationTimer.timerPercent * 2 * Math.PI)*Const.BACKPACK_NOTIFICATIONTIMERINTENSITY);
		}
	}

	override function onAdd() {
		super.onAdd();
		if (content != null) drawContent();
	}

	public function addItem(item : Data.ItemsKind) {
		if (items.get(item) == null) { 

			var data = Data.items.get(item);

			// makes the object.
			var tile = hxd.Res.load(data.icon).toTile();
			var itemIcon = new game.ui.Icon(tile);
			itemIcon.filter = new h2d.filter.Nothing();
			itemIcon.alpha = Const.BACKPACK_ITEMOPACITY;
			itemIcon.setAlignment(Center, Middle);

			// makes the items if listed.
			var choices : Array<game.dialogue.Choice> = [];
			if (data.actions != null) for (a in data.actions) {

				var choice = game.dialogue.Choice.fromString(a.text);
				choice.passThroughEvents();
				choices.push(choice);

				choice.onClick = function() {
					for (action in a.action) {
						switch(action.action) {
							case ExtraAction:
								Game.addSlot();

							case Transform(item):
								addItem(item.name);
							
							case Remove:
								removeItem(item);
						}
					}
				}

				choice.onOver = () -> description.text = a.description; 

			}

			var iteminteractive = new h2d.Interactive(tile.width, tile.height, itemIcon);
			iteminteractive.y = -tile.height/2;
			if (choices.length > 0)
				iteminteractive.onOver = (e:hxd.Event) -> itemOverAction(itemIcon, data.displayname, data.description);
			else 
				iteminteractive.onOver = (e:hxd.Event) -> itemOver(itemIcon, data.displayname, data.description);				
			iteminteractive.onOut = function(e:hxd.Event){ 
				itemOut(itemIcon);
				for (c in choices) c.remove();
			}
			iteminteractive.onClick = (e : hxd.Event) -> for (c in choices) itemIcon.addChild(c);
			iteminteractive.propagateEvents = true;

			#if debug
			var interactivebounds = new h2d.Graphics(iteminteractive);
			interactivebounds.lineStyle(2, 0xFF0000);
			interactivebounds.drawRect(0, 0, iteminteractive.width, iteminteractive.height);
			#end

			contentStack.push(itemIcon);
			contentStack.setChildrenAlignment(Middle);

			notificationTimer.reset();
			notificationTimer.start();
			
			items.set(item, itemIcon);
		}
	}

	public function removeItem(item : Data.ItemsKind) {
		var existing = items.get(item);
		if (existing != null) {
			contentStack.removeObject(existing);
			existing.remove();
			items.remove(item);
		}
	}

	public function removeAllItems() {
		for (i in items.keys()) items.remove(i);
	}

	private function activate(?e : hxd.Event) {
		addChild(content);
		drawContent();
		tab.y = contentHeight;

		notificationTimer.reset();
		notificationTimer.stop();
		icon.setScale(iconScale);
	}

	private function deactivate(?e : hxd.Event) {
		removeChild(content);
		tab.y = 0;
	}

	private function itemOver(item : game.ui.Icon, name : String, description : String) {
		title.text = name;
		this.description.text = evaluateVariables(description);
		item.alpha = 1;
	}

	private function itemOverAction(item : game.ui.Icon, name : String, description : String) {
		title.text = name;
		item.filter = new h2d.filter.Outline(2);
		this.description.text = evaluateVariables(description);
		item.alpha = 1;
	}

	private function itemOut(item : game.ui.Icon) {
		title.text = normalTitleText;
		description.text = normalDescriptionText;
		item.alpha = Const.BACKPACK_ITEMOPACITY;
		item.filter = null;
	}

	private function createContent() {
		content = new h2d.Graphics();
		contentHeight = Const.BACKPACK_ITEMPADDING * 4 + Const.BACKPACK_ITEMSIZE
			+ Const.BACKPACK_DESCRIPTIONFONT.lineHeight + Const.BACKPACK_NAMEFONT.lineHeight;

		drawContent();

		title = new h2d.Text(Const.BACKPACK_NAMEFONT, content);
		title.x = Const.BACKPACK_ITEMPADDING;
		title.y = Const.BACKPACK_ITEMPADDING;
		title.text = normalTitleText;
		title.color = h3d.Vector.fromColor(Const.BACKPACK_NAMECOLOR);
		description = new h2d.Text(Const.BACKPACK_DESCRIPTIONFONT, content);
		description.x = Const.BACKPACK_ITEMPADDING;
		description.y = title.y + title.font.lineHeight;
		description.color = h3d.Vector.fromColor(Const.BACKPACK_DESCRIPTIONCOLOR);
		description.text = normalDescriptionText;

		var overallinteractive = new h2d.Interactive(Const.WORLD_WIDTH, contentHeight, content);
		overallinteractive.onOut = deactivate;

		contentStack = new game.ui.HStack(content);
		contentStack.padding = Const.BACKPACK_ITEMPADDING;
		contentStack.x = Const.BACKPACK_ITEMPADDING;
		contentStack.y = description.y + description.font.lineHeight + Const.BACKPACK_ITEMPADDING;
	}

	private function drawContent() {
		content.beginFill(Const.BACKPACK_COLOR);
		content.drawRoundedRect(0, 0, Const.WORLD_WIDTH, contentHeight, Const.BACKPACK_ROUNDEDCORNERS);
		content.drawRect(0,0, Const.WORLD_WIDTH, contentHeight / 2);
		content.endFill();
	}

	private function evaluateVariables(text : String) : String {

		var parsedText = "";
		for (qt in game.utils.Quoted.parse(text)) {
			switch(qt.quote) {
				case "%": parsedText += Data.characters.resolve(qt.text).name;
				case "#": parsedText += Game.variables.getValue(qt.text);
				case null: parsedText += qt.text;
				case _: throw("unknown quote");
			}
		}

		return parsedText;
	}

	private function createIcon() {

		tab = new h2d.Graphics(this);
		tab.x = Const.WORLD_WIDTH * 0.9;

		// creates the icon.
		icon = new h2d.Object(tab);
		var tile = hxd.Res.props.backpack.toTile();
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
		tab.drawRoundedRect(0, 0, tabWidth, tabHeight, Const.BACKPACK_ROUNDEDCORNERS);
		tab.drawRect(0, 0, tabWidth, tabHeight/2);
		tab.endFill();
	}
}