package game.ui;

class Backpack extends Pulltab {

	private var notificationTimer : sn.Timer;

	private var contentStack : game.ui.HStack;

	private var title : h2d.Text;
	static private var normalTitleText : String = "Backpack";
	private var description : h2d.Text;
	static private var normalDescriptionText : String = "";

	public function new(?parent : h2d.Object) {
		var tabicon = hxd.Res.props.backpack.toTile();
		super(tabicon, parent);
		createContent();

		notificationTimer = new sn.Timer(Const.BACKPACK_NOTIFICATIONTIMER, true);
		notificationTimer.infinite = true;
		notificationTimer.stop();
		notificationTimer.updateCallback = function() {
			icon.setScale(iconScale + Math.sin(notificationTimer.timerPercent * 2 * Math.PI)*Const.BACKPACK_NOTIFICATIONTIMERINTENSITY);
		}
		
		tab.x = Const.WORLD_WIDTH * 0.9;
	}

	override function activate(? e : hxd.Event) {
		super.activate(e);

		// repopulates the backpack based on what is in the player's inventory.
		removeAllItems();
		for (i in Data.items.all) if (Game.variables.has(i.name)) addItem(i.name);

		notificationTimer.reset();
		notificationTimer.stop();
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

							case Transform(newItem):
								addItem(newItem.name);
								removeItem(item);
								Game.foundItem(newItem.name);
								Game.lostItem(item);
							
							case Remove:
								removeItem(item);
								Game.lostItem(item);
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

	public function removeAllItems() {
		for (i in items.keys()) removeItem(i);
	}

	
	private function createContent() {
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

		contentStack = new game.ui.HStack(content);
		contentStack.padding = Const.BACKPACK_ITEMPADDING;
		contentStack.x = Const.BACKPACK_ITEMPADDING;
		contentStack.y = description.y + description.font.lineHeight + Const.BACKPACK_ITEMPADDING;
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
}