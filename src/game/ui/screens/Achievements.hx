package game.ui.screens;

class Achievements extends h2d.Object {

	private var stack : game.ui.VStack;

	public function new() {
		super();
		
		stack = new game.ui.VStack(this);
		stack.x = Const.WORLD_WIDTH - 10;
		stack.y = Const.WORLD_HEIGHT / 2;
		stack.setAlignment(Right, Middle);
		stack.padding = 0;
	}

	override function onAdd() {
		super.onAdd();

		update();
	}

	private function update() {
		stack.clear();

		// sorts the achievements alphabetically.
		var achievements = Data.achievements.all.toArrayCopy();
		achievements.sort((a,b) -> if (a.title > b.title) return 1 else return -1);

		for (a in achievements) {

			var achievementColor = if (Game.variables.checkLifetime(a.id.toString())) {
				Const.ACHIEVEMENTS_ACHIEVED;
			} else {
				Const.ACHIEVEMENTS_DISABLED;
			}

			var text = new game.ui.Text(a.title);
			text.setColor(achievementColor);
			text.setScale(Const.ACHIEVEMENTS_SIZE);
			stack.push(text);

			var description = new game.ui.Text(a.description);
			description.setColor(Const.ACHIEVEMENTS_DISABLED);
			description.setScale(Const.ACHIEVEMENTS_DESCRIPTION_SIZE);
			stack.push(description);

			var spacer = new game.ui.Text("");
			spacer.setScale(0.15);
			stack.push(spacer);
		}
		
		stack.setChildrenAlignment(Right);
	}
}