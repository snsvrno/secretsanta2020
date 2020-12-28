package game.ui;

class CycleEnd extends h2d.Object {

	private inline static var LOCATIONS : Int = 0;
	private inline static var ITEMS : Int = 1;

	private var title : game.ui.Text;
	private var itemsStack : game.ui.VStack;

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

		itemsStack = new game.ui.VStack(this);
		itemsStack.x = Const.WORLD_WIDTH / 2;
		itemsStack.y = Const.WORLD_HEIGHT / 2;
		itemsStack.setAlignment(Center, Middle);
		itemsStack.setChildrenAlignment(Left, Middle);

		var continueButton = new game.ui.Button("Continue Journey", this);
		continueButton.x = 10;
		continueButton.y = Const.WORLD_HEIGHT - 10;
		continueButton.setAlignment(Left, Bottom);
		continueButton.onClick = () -> if (onClick != null) onClick();

		makeItems();
		update();
	}

	private function makeItems() {

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
			itemsStack.push(stack);		
		}
	}

	public function update() {
		for (i in items.keys()) switch(i) {
			case LOCATIONS: items.get(i).setText('${Game.variables.visitedLocations.length}');
			case ITEMS: items.get(i).setText('${Game.variables.itemsFound.length}');

			case _:
		}
		itemsStack.alignChildren();
	}
}