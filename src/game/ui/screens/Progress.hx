package game.ui.screens;

typedef ProgressItem = { text : String, value : String, description : String };

class Progress extends h2d.Object {
	
	private var items : Array<ProgressItem> = [];
	private var stack : game.ui.VStack;

	public function new() {
		super();
		
		stack = new game.ui.VStack(this);
		stack.x = Const.WORLD_WIDTH - 10;
		stack.y = Const.WORLD_HEIGHT / 2;
		stack.setAlignment(Right, Middle);
		stack.padding = 5;
	}

	override function onAdd() {
		super.onAdd();

		updateItems();
		remakeItems();
	}

	private function remakeItems() {
		stack.clear();

		for (i in items) {

			var hstack = new game.ui.HStack();
			hstack.setChildrenAlignment(Middle);

			var text = new game.ui.Text(i.text + ": ");
			text.setScale(Const.PROGRESS_SIZE);
			text.setColor(Const.PROGRESS_COLOR_TEXT);

			var textValue = new game.ui.Text(i.value);
			textValue.setScale(Const.PROGRESS_SIZE);
			textValue.setColor(Const.PROGRESS_COLOR_VALUE);

			var textDescription = new game.ui.Text(i.description);
			textDescription.setScale(Const.PROGRESS_DESCRIPTION_SIZE);
			textDescription.setColor(Const.PROGRESS_COLOR_DESCRIPTION);

			hstack.push(text);
			hstack.push(textValue);
			stack.push(hstack);
			stack.push(textDescription);

		}

		stack.setChildrenAlignment(Right);
	}

	private function updateItems() {
		items = [
			{
				text: "Achievements",
				value: countAchievements(),
				description: "",
			},
			{ 
				text: "Completed Cycles",
				value: '${Game.variables.getValue(Const.PROGRESS_CYCLES)}',
				description: "How many days have passed.",
			},
		];
	}

	private function countAchievements() : String {
		var total = 0;
		var earned = 0;

		for (a in Data.achievements.all) if (a.enabled) {
			total++;
			if (Game.variables.checkLifetime(a.id.toString())) earned++;
		}

		return '$earned of $total';
	}
}