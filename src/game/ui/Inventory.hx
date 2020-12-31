package game.ui;

class Inventory extends game.ui.VStack {

	var items : Map<Data.ItemsKind, game.ui.HStack> = new Map();

	public function new(parent : h2d.Object) {
		super(parent);
	}

	public function addItem(item : Data.ItemsKind) {
		var data = Data.items.get(item);
		var tile = hxd.Res.load(data.icon).toTile();
		
		var icon = new game.ui.Icon(tile);
		icon.setAlignment(Center, Middle);

		var interactive = new h2d.Interactive(icon.getWidth() / icon.scaleX, icon.getHeight() / icon.scaleY, icon);
		interactive.y = -interactive.height/2;

		var descriptionStack = new game.ui.VStack();
		descriptionStack.padding = 10;
		var title = new game.ui.Text(data.displayname);
		title.setScale(Const.ICON_TITLE_SIZE);
		var description = new game.ui.Text("placeholder");
		description.setScale(Const.ICON_DESCRIPTION_SIZE);

		descriptionStack.setChildrenAlignment(Right, Middle);
		descriptionStack.pushAll([title, description]);

		var iconStack = new game.ui.HStack();
		iconStack.push(icon);
		iconStack.setAlignment(Right, Middle);
		iconStack.setChildrenAlignment(Middle);

		interactive.onOver = function(e : hxd.Event) {
			description.setText(evaluateVariables(data.description));
			iconStack.push(descriptionStack, 0);
			iconStack.setAlignment();
		};
		interactive.onOut = function(e : hxd.Event) {
			iconStack.removeObject(descriptionStack);
		};

		push(iconStack);
		items.set(item, iconStack);
	}

	public function removeItem(item : Data.ItemsKind) { 
		var obj = items.get(item);
		removeObject(obj);
		items.remove(item);
	}

	public function removeAllItems() {
		for (i in items.keys()) removeItem(i);
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