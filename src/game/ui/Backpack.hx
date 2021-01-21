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

		drawerSpeed = Const.BACKPACK_DRAWERSPEED;

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
			var choices : Array<game.ui.Button> = [];
			var additionalInteractiveHeight = 0.;
			if (data.actions != null) {
				var hoffset = 0.;
				for (a in data.actions) {
					var choice = new game.ui.Button(a.text);
					// so we don't flicker and fight between the interactives
					// of the item and this text.
					choice.propogateEvents = true;
					choice.setAlignment(Center, Middle);
					choice.x = itemIcon.getWidth();
					choice.y = itemIcon.getHeight() + hoffset;
					hoffset += choice.getHeight();

					choice.onOver = () -> description.text = a.description;
					choice.onOut = () -> description.text = data.description;
					choice.onClick = function() {
						for (action in a.action) {
							switch(action.action) {
								case ExtraAction:
									Game.addSlot();

								case Transform(newItem):
									addItem(newItem.name);
									removeItem(item);
									Game.variables.gets(newItem.name);
									Game.variables.loses(item);
								
								case Remove:
									removeItem(item);
									Game.variables.loses(item);
								
								case Popup(text):
									Game.popup(text);
							}
						}
					}

					choices.push(choice);					
				}
				additionalInteractiveHeight = hoffset;
			}

			var iteminteractive = new h2d.Interactive(
				tile.width, 
				// the additional offset is from the choice items added.
				tile.height + additionalInteractiveHeight,
				itemIcon);
			iteminteractive.y = -tile.height/2;
			iteminteractive.onOver = function(e : hxd.Event) {
				itemOver(itemIcon, data.displayname, data.description);
				for (c in choices) itemIcon.addChild(c);
			}
			iteminteractive.onOut = function(e:hxd.Event){ 
				itemOut(itemIcon);
				for (c in choices) c.remove();
			}
			iteminteractive.propagateEvents = true;

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