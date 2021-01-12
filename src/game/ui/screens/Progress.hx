package game.ui.screens;

typedef ProgressItem = { 
	text : String, 
	value : String, 
	?total : String,
	description : String
};

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
			hstack.push(text);

			var textValue = new game.ui.Text(i.value);
			textValue.setScale(Const.PROGRESS_SIZE);
			textValue.setColor(Const.PROGRESS_COLOR_VALUE);
			hstack.push(textValue);

			if (i.total != null) {
				
				var of = new game.ui.Text(" of ");
				of.setScale(Const.PROGRESS_SIZE);
				of.setColor(Const.PROGRESS_COLOR_TEXT);
				hstack.push(of);

				var totalValue = new game.ui.Text(i.total);
				totalValue.setScale(Const.PROGRESS_SIZE);
				totalValue.setColor(Const.PROGRESS_COLOR_VALUE);
				hstack.push(totalValue);
			}

			var textDescription = new game.ui.Text(i.description);
			textDescription.setScale(Const.PROGRESS_DESCRIPTION_SIZE);
			textDescription.setColor(Const.PROGRESS_COLOR_DESCRIPTION);

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
				total: countTotalAchievements(),
				description: "How many achievements achieved.",
			},
			{ 
				text: "Completed Cycles",
				value: '${Game.variables.getLifeValue(Const.PROGRESS_CYCLES)}',
				description: "How many days have passed.",
			},
			{ 
				text: "Conversations",
				value: countConversations(),
				total: countTotalConversations(),
				description: "How many conversations have you experienced.",
			},
			{ 
				text: "Items",
				value: countItems(),
				total: countTotalItems(),
				description: "How many items have you encountered.",
			}
		];

		/*
		var groups = extractConversationGroups();
		for (g in groups.keys()){
			var v = groups.get(g);
			items.push({
				text: 'Conversations with $g',
				value: '${v.met}',
				total: '${v.total}',
				description: "",
			});
		}*/
	}

	private function countItems() : String {
		var count = 0;

		for (i in Data.items.all) {
			if (Game.variables.hasLifetime(i.name)) count++;
		}

		return '$count';
	}

	private function countTotalItems() : String {
		return '${Data.items.all.length}';
	}

	private function countConversations() : String {
		var groups = extractConversationGroups();
		var count = 0;
		for (g in groups.keys()) count += groups.get(g).met;
		return '$count';
	}

	private function countTotalConversations() : String {
		var groups = extractConversationGroups();
		var count = 0;
		for (g in groups.keys()) count += groups.get(g).total;
		return '$count';	
	}

	private function countAchievements() : String {
		var earned = 0;

		for (a in Data.achievements.all) if (a.enabled) {
			if (Game.variables.earnedAchievement(a)) earned++;
			// if (Game.variables.checkLifetime(a.id.toString())) earned++;
		}

		return '$earned';
	}

	private function countTotalAchievements() : String {
		var total = 0;

		for (a in Data.achievements.all) if (a.enabled) {
			total++;
		}

		return '$total';
		
	}

	private function extractConversationGroups() : Map<String,  { total: Int, met : Int }> {
		var groups : Map<String, { total: Int, met : Int }> = new Map();

		for (d in Data.dialogue.all) {
			var group = d.id.toString().split("_")[0];

			var value = groups.get(group);

			if (value != null) value.total += 1;
			else value = { total : 1, met : 0 };

			if (Game.variables.isLiftimeChosenOption(d.id)) value.met += 1;

			groups.set(group, value);
		}

		return groups;
	}

	private function countTotalConversationGroups() : String {
		var count = 0;

		var groups = extractConversationGroups();
		for (a in groups.keys()) count++;

		return '${count}';
	}
}