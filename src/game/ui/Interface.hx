package game.ui;

private enum State {
	MainMenuState;
	GameState;
	MenuState;
	End;
}

class Interface extends h2d.Object {

	private var state : State = MainMenuState;
	private final scene : h2d.Scene;

	private var background : h2d.Graphics;

	private var mainMenu : h2d.Object;

	private var endScreen : game.ui.CycleEnd;

	private var gameMenu : h2d.Object;
	private var gameMenuTitle : game.ui.Text;
	private var gameMenuContent : game.ui.VStack;

	private var gameui : h2d.Object;
	private var locationText : game.ui.Button;
	private var inventory : game.ui.Inventory;

	public function new (?parent : h2d.Scene) {
		super(parent);
		this.scene = parent;

		// we make the different layers
		createMainMenu();
		createGameMenu();
		createGameui();
		endScreen = new game.ui.CycleEnd();
		endScreen.onClick = function() {
			Game.restartCycle();
			setState(GameState);
		}
	
		// the background for the menu.
		background = new h2d.Graphics(this);
		drawBackgroundLayer();

		// the title, that will be used in submenus and stuff
		gameMenuTitle = new game.ui.Text("", Const.MENU_TITLE_FONT, gameMenu);
		gameMenuTitle.setScale(0.75);
		gameMenuTitle.x = Const.WORLD_WIDTH - 10;
		gameMenuTitle.y = 10;
		gameMenuTitle.setAlignment(Right, Top);
	
		var versionText = new game.ui.Text("Version: " + sn.Macros.getVersionNumberFromGit(), Const.MENU_FONT_SMALL, background);
		versionText.x = Const.WORLD_WIDTH - 10;
		versionText.y = Const.WORLD_HEIGHT - 10;
		versionText.setAlignment(Right, Bottom);

		// an interactive used to block events to the game below it.
		var interactive = new h2d.Interactive(Const.WORLD_WIDTH, Const.WORLD_HEIGHT, background);
		
		setState(GameState);
	}

	private function createGameui() {

		gameui = new h2d.Object();

		var menuButton = new game.ui.Button("Menu", Const.MENU_FONT_SMALL, gameui);
		menuButton.x = 10;
		menuButton.y = Const.WORLD_HEIGHT - 10;
		menuButton.onClick = () -> setState(MenuState);
		menuButton.setAlignment(Left, Bottom);
		menuButton.normalColor = Const.MENU_BUTTON_COLOR_GAMEMENU_ONLIGHT;

		locationText = new game.ui.Button("<location>");
		locationText.x = Const.WORLD_WIDTH - 10;
		locationText.y = Const.WORLD_HEIGHT - 10;
		locationText.normalColor = Const.MENU_BUTTON_COLOR_GAMEMENU_ONLIGHT;
		locationText.setAlignment(Right, Bottom);
		locationText.onClick = () -> Game.toMap();

		inventory = new game.ui.Inventory(gameui);
		inventory.x = Const.WORLD_WIDTH - 10;
		inventory.y = Const.WORLD_HEIGHT / 2;
		inventory.setAlignment(Right, Middle);
		inventory.setChildrenAlignment(Right);
	}

	public function addToInventory(item : Data.ItemsKind) inventory.addItem(item);
	public function removeFromInventory(item : Data.ItemsKind) inventory.removeItem(item);

	private function createProgressSection(stack : VStack) {
		gameMenuTitle.setText("Progress");

		var items : Array<{ text : String, value : String, description : String }> = [
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

		stack.clear();
		stack.padding = 5;
		
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

	private function createAchievementsSection(stack : VStack) {
		gameMenuTitle.setText("Achievements");
		
		stack.clear();
		stack.padding = 0;

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

	private function createGameMenu() {
		gameMenu = new h2d.Object();

		gameMenuContent = new VStack(gameMenu);
		gameMenuContent.x = Const.WORLD_WIDTH - 10;
		gameMenuContent.y = Const.WORLD_HEIGHT / 2;
		gameMenuContent.setAlignment(Right, Middle);

		var description = new game.ui.Text("", Const.MENU_FONT_SMALL, gameMenu);
		description.x = 10;
		description.y = Const.WORLD_HEIGHT - 10;
		description.setWrapWidth(Math.floor(Const.WORLD_WIDTH / 2));
		description.setAlignment(Left,Bottom);

		var buttonStack = new game.ui.VStack(gameMenu);

		var con = new game.ui.Button("Continue");
		con.setContainerHook(buttonStack);
		con.description = "";
		con.descriptionObject = description;
		con.onClick = () -> setState(GameState);

		var prog = new game.ui.Button("Progress");
		prog.setContainerHook(buttonStack);
		prog.description = "Check on exploration progress.";
		prog.descriptionObject = description;
		prog.onClick = () -> createProgressSection(gameMenuContent);

		var achi = new game.ui.Button("Achievements");
		achi.setContainerHook(buttonStack);
		achi.description = "Check on story and quest achievements.";
		achi.descriptionObject = description;
		achi.onClick = () -> createAchievementsSection(gameMenuContent);

		var mainmenu = new game.ui.Button("Main Menu");
		mainmenu.setContainerHook(buttonStack);
		mainmenu.description = "To the game main menu.";
		mainmenu.descriptionObject = description;
		mainmenu.onClick = () -> setState(MainMenuState);

		buttonStack.x = 10;
		buttonStack.y = Const.WORLD_HEIGHT / 2;
		buttonStack.setAlignment(Left, Middle);
		buttonStack.setChildrenAlignment(Left, Bottom);

		buttonStack.push(con);
		buttonStack.push(prog);
		buttonStack.push(achi);
		buttonStack.push(mainmenu);

	}

	private function createMainMenu() {
		
		mainMenu = new h2d.Object();

		createTitle();
		createMenu();
	}

	/**
	 * Makes the title stack.
	 */
	private function createTitle() {
		
		var title = new game.ui.Text(Const.GAMETITLE, Const.MENU_TITLE_FONT);
		title.setScale(Const.MENU_TITLE_SIZE);

		var titleLineStack = new game.ui.HStack();
		var text = new game.ui.Text("a game by ");
		var snsv = new game.ui.Snsvrno();
		snsv.setScale(0.5);
		titleLineStack.push(text);
		titleLineStack.push(snsv);
	
		var titleStack = new game.ui.VStack(mainMenu);
		titleStack.x = Const.WORLD_WIDTH - 10;
		titleStack.y = 10;
		titleStack.setAlignment(Right);
		titleStack.setChildrenAlignment(Right);
		titleStack.push(title);
		titleStack.push(titleLineStack);
	}

	/**
	 * Creates the menu.
	 */
	private function createMenu() {

		var description = new game.ui.Text("", Const.MENU_FONT_SMALL, mainMenu);
		description.x = 10;
		description.y = Const.WORLD_HEIGHT - 10;
		description.setWrapWidth(Math.floor(Const.WORLD_WIDTH / 2));
		description.setAlignment(Left,Bottom);

		var buttonStack = new game.ui.VStack(mainMenu);

		var startText = if (Game.variables.loaded) "Continue"; else "Start";
		var start = new game.ui.Button(startText);
		start.setContainerHook(buttonStack);
		start.description = "Start or Continue a game.";
		start.descriptionObject = description;
		start.onClick = () -> setState(GameState);

		var clear = new game.ui.Button("Clear Data");
		clear.setContainerHook(buttonStack);
		clear.description = "Reset all status, start from nothing.";
		clear.descriptionObject = description;
		clear.onClick = function() {
			Game.clearData();
			start.setText("Start");
		}

		var gamemenu = new game.ui.Button("Game Menu");
		gamemenu.setContainerHook(buttonStack);
		gamemenu.description = "Menu";
		gamemenu.descriptionObject = description;
		gamemenu.onClick = () -> setState(MenuState);

		#if !js
		// we aren't going to add quit on web, not sure what it would
		// do there anyway.
		var quit = new game.ui.Button("Quit");
		quit.setContainerHook(buttonStack);
		quit.description = "Quits the game, progress will be saved.";
		quit.descriptionObject = description;
		quit.onClick = Game.quit;
		#end

		buttonStack.x = 10;
		buttonStack.y = Const.WORLD_HEIGHT / 2;
		buttonStack.setAlignment(Left, Middle);
		buttonStack.setChildrenAlignment(Left, Bottom);
		buttonStack.push(start);
		buttonStack.push(clear);
		buttonStack.push(gamemenu);

		#if !js
		buttonStack.push(quit);
		#end
	}

	public function setState(newState) {

		// removes the old elements.
		switch(state) {

			case MainMenuState: 
				background.remove();
				mainMenu.remove();

			case GameState: 
				gameui.remove();

			case MenuState:
				background.remove();
				gameMenu.remove();

			case End:
				background.remove();
				endScreen.remove();

		}

		// adds the new elements.
		switch(newState) {

			case MainMenuState: 
				if (background.parent != this) addChild(background);
				drawBackgroundLayer();
				if (mainMenu.parent != this) addChild(mainMenu);

			case GameState: 
				if (gameui.parent != this) addChild(gameui);

			case MenuState:
				if (background.parent != this) addChild(background);
				drawBackgroundLayer();
				if (gameMenu.parent != this) addChild(gameMenu);
				gameMenuContent.clear();
				gameMenuTitle.setText("Game Menu");

			case End:
				if (background.parent != this) addChild(background);
				drawBackgroundLayer();
				if (endScreen.parent != this) addChild(endScreen);
				endScreen.update();
				inventory.removeAllItems();
		}

		state = newState;
	}

	private function drawBackgroundLayer() {
		background.clear();
		background.beginFill(0x000000, Const.MENU_BACKGROUND_OPACITY);
		background.drawRect(0, 0, Const.WORLD_WIDTH, Const.WORLD_HEIGHT);
		background.endFill();
	}

	public function onScene(locationName : String) {
		if (locationText.parent != gameui) gameui.addChild(locationText);
		locationText.setText("<< " + locationName);

		for (c in gameui.children) 
			if (Std.isOfType(c, game.ui.Button)) 
				cast(c, game.ui.Button).normalColor = Const.MENU_BUTTON_COLOR_GAMEMENU_ONDARK;

	}

	public function onMap() {
		for (c in gameui.children) 
			if (Std.isOfType(c, game.ui.Button)) 
				cast(c, game.ui.Button).normalColor = Const.MENU_BUTTON_COLOR_GAMEMENU_ONLIGHT;

		locationText.remove();
	}

	private function countAchievements() : String {
		var total = Data.achievements.all.length;

		var earned = 0;
		for (a in Data.achievements.all) if (Game.variables.checkLifetime(a.id.toString())) earned++;

		return '$earned of $total';
	}
}