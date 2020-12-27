package game.ui;

import h3d.scene.Object;

private enum State {
	MainMenuState;
	GameState;
	MenuState;
}

class Interface extends h2d.Object {

	private var state : State = MainMenuState;
	private final scene : h2d.Scene;

	private var background : h2d.Graphics;

	private var mainMenu : h2d.Object;

	private var gameMenu : h2d.Object;

	private var gameui : h2d.Object;
	private var locationText : game.ui.Button;

	public function new (?parent : h2d.Scene) {
		super(parent);
		this.scene = parent;

		// we make the different layers
		createMainMenu();
		createGameMenu();
		createGameui();
	
		// the background for the menu.
		background = new h2d.Graphics(this);
		background.beginFill(0x000000, Const.MENU_BACKGROUND_OPACITY);
		background.drawRect(0, 0, Const.WORLD_WIDTH, Const.WORLD_HEIGHT);
		background.endFill();
	
		var versionText = new game.ui.Text("Version: " + sn.Macros.getVersionNumberFromGit(), Const.MENU_FONT_SMALL, background);
		versionText.x = Const.WORLD_WIDTH - 10;
		versionText.y = Const.WORLD_HEIGHT - 10;
		versionText.setAlignment(Right, Bottom);

		// an interactive used to block events to the game below it.
		var interactive = new h2d.Interactive(Const.WORLD_WIDTH, Const.WORLD_HEIGHT, background);
		
		setState(MainMenuState);
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
	}

	private function createGameMenu() {
		gameMenu = new h2d.Object();
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
		var snsv = new game.ui.Text("snsvrno");
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

		var start = new game.ui.Button("Start");
		start.setContainerHook(buttonStack);
		start.description = "Start or Continue a game.";
		start.descriptionObject = description;
		start.onClick = () -> setState(GameState);

		var clear = new game.ui.Button("Clear Data");
		clear.setContainerHook(buttonStack);
		clear.description = "Reset all status, start from nothing.";
		clear.descriptionObject = description;

		buttonStack.x = 10;
		buttonStack.y = Const.WORLD_HEIGHT / 2;
		buttonStack.setAlignment(Left, Middle);
		buttonStack.setChildrenAlignment(Left, Bottom);
		buttonStack.push(start);
		buttonStack.push(clear);
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
		}

		// adds the new elements.
		switch(newState) {

			case MainMenuState: 
				if (background.parent != this) addChild(background);
				if (mainMenu.parent != this) addChild(mainMenu);

			case GameState: 
				if (gameui.parent != this) addChild(gameui);

			case MenuState:
				if (background.parent != this) addChild(background);
				if (gameMenu.parent != this) addChild(gameMenu);
		}

		state = newState;
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
}