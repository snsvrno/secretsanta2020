package game.ui.screens;

import h2d.filter.Group;

class CycleEnd extends h2d.Object {


	private inline static var OVERINTENSITY : Float = 0.35;
	private inline static var SELECTEDINTENSITY : Float = 0.0;
	private inline static var INTENSITY : Float = 0.65;

	private inline static var LOCATIONS : Int = 0;
	private inline static var ITEMS : Int = 1;

	private var title : game.ui.Text;
	private var statusStack : game.ui.VStack;
	private var itemStack : game.ui.HStack;

	public var selectedItems(default, null) : Array<Data.ItemsKind> = [];
	private var maxSelectedItems : Int = 1;
	private var itemsOnOut : Map<Data.ItemsKind, (?e : hxd.Event) -> Void> = new Map();

	public var onClick : Null<() -> Void>;

	/**
	 * Collection of text items that are updatable.
	 */
	private var items : Map<Int, game.ui.Text> = new Map();

	public function new() {
		super();

		title = new game.ui.Text("", Const.MENU_TITLE_FONT, this);
		title.setScale(0.75);
		title.x = Const.WORLD_WIDTH - 10;
		title.y = 10;
		title.setAlignment(Right, Top);
		title.setText("Another Cycle Ends...");

		statusStack = new game.ui.VStack(this);
		statusStack.x = Const.WORLD_WIDTH / 2;
		statusStack.y = Const.WORLD_HEIGHT / 2;
		statusStack.setAlignment(Center, Middle);
		statusStack.setChildrenAlignment(Left, Middle);

		var textStack = new game.ui.HStack(this);
		textStack.setAlignment(Center, Bottom);
		var text1 = new game.ui.Text('Choose at most ', null);
		text1.setHeight(12);
		var text2 = new game.ui.Text('$maxSelectedItems', null);
		text2.setHeight(12);
		text2.setColor(Const.BUBBLE_TEXT_COLOR_BOLD);
		var text3text = if (maxSelectedItems == 1) "item" else "items";
		var text3 = new game.ui.Text(' $text3text to carry over...', null);
		text3.setHeight(12);
		textStack.pushAll([text1, text2, text3]);	
		
		itemStack = new game.ui.HStack(this);
		itemStack.setAlignment(Center, Top);
		itemStack.padding = 10;
		itemStack.x = textStack.x = Const.WORLD_WIDTH / 2;
		itemStack.y = textStack.y = Const.WORLD_HEIGHT - 100;
		textStack.y -= 10;

		var continueButton = new game.ui.Button("Continue Journey", this);
		continueButton.x = 10;
		continueButton.y = Const.WORLD_HEIGHT - 10;
		continueButton.setAlignment(Left, Bottom);
		continueButton.onClick = () -> if (onClick != null) onClick();

		makeStatusItems();
		update();
	}

	private function makeItems() {
		itemStack.clear();

		for (i in Data.items.all) {
			if (Game.variables.has(i.name)) {
				var t = hxd.Res.load(i.icon).toTile();
				var item = new game.ui.Icon(t);
				item.setAlignment(Center, Middle);

				var itemText = new game.ui.Text(i.displayname, null, item);
				itemText.setAlignment(Center, Top);
				// this shouldn't work but it does ... there is something
				// wrong with the Elements..
				itemText.x = item.getWidth() / item.scaleX / 2;
				itemText.y = item.getHeight() / item.scaleY / 2;
				itemText.alpha = 0;

				var outline = new h2d.filter.Outline(2,0xFFFFFFFF);
				var disabledShader = new shader.screen.Darken();
				disabledShader.intensity = INTENSITY;
				var disabledFilter = new h2d.filter.Shader(disabledShader);
				var filters = new h2d.filter.Group();
				filters.add(disabledFilter);
				item.filter = filters;

				var interactive = new h2d.Interactive(t.width, t.height, item);
				// interactive.x = -t.width/2;
				interactive.y = -t.height/2;
				interactive.onOver = function(_) {
					disabledShader.intensity = OVERINTENSITY;
					itemText.alpha = 1;
				}
				// some funky madness so that i can undo the select for multiple items.
				// basically i setup the "on out" function so it cleans up the icon, and
				// then make a map i can access from outer icons if needed.
				var onout = function(?e : hxd.Event) {
					if (selectedItems.contains(i.name)) { 
						disabledShader.intensity = SELECTEDINTENSITY;
					} else {
						disabledShader.intensity = INTENSITY;
						filters.remove(outline);
					}
					itemText.alpha = 0;
				};
				interactive.onOut = onout;
				itemsOnOut.set(i.name, onout);

				interactive.onClick = function(_) {
					if (selectedItems.contains(i.name)) { 
						selectedItems.remove(i.name);
						filters.remove(outline);
					} else {
						filters.add(outline);
						selectedItems.push(i.name);
						while (selectedItems.length > maxSelectedItems) {
							var removed = selectedItems.shift();
							// unhighlights the removed item.
							itemsOnOut.get(removed)();
						}
					}
				}

				itemStack.push(item);
			}
		}

		itemStack.setChildrenAlignment(Middle);
	}

	private function makeStatusItems() {

		var definitions = [
			{ 
				d: "Locations Visited: ",
				k: LOCATIONS,
				e: ' of ${Data.locations.all.length-1}', // -1 because of the `blank` location.
			},
			{ 
				d: "Items Collected: ",
				k: ITEMS,
				e: ' of ${Data.items.all.length}',
			},
		];

		for (def in definitions) {
			var stack = new game.ui.HStack();

			var description = new game.ui.Text(def.d);
			description.setColor(Const.CYCLEOVER_ITEM_COLOR);

			var value = new game.ui.Text("");
			value.setColor(Const.CYCLEOVER_VALUE_COLOR);
			items.set(def.k, value);

			var ending = new game.ui.Text(def.e);
			ending.setColor(Const.CYCLEOVER_ITEM_COLOR);

			stack.pushAll([description, value, ending]);
			statusStack.push(stack);		
		}
	}

	public function update() {
		for (i in items.keys()) switch(i) {
			case LOCATIONS: items.get(i).setText('${Game.variables.visitedLocations.length}');
			case ITEMS: items.get(i).setText('${Game.variables.itemsFound.length}');

			case _:
		}

		makeItems();
		
		statusStack.alignChildren();
	}
}