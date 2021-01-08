package game.ui;

import game.ui.screens.MainMenu;

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

	// the different menu screens
	private var mainMenu : game.ui.screens.MainMenu;
	private var endScreen : game.ui.screens.CycleEnd;
	private var gameMenu : game.ui.screens.GameMenu;
	private var gameui : game.ui.screens.GameUi;

	public function new (?parent : h2d.Scene) {
		super(parent);
		this.scene = parent;

		mainMenu = new game.ui.screens.MainMenu();
		mainMenu.onStartClick = () -> setState(GameState);
		mainMenu.onMenuClick = () -> setState(MenuState); 

		gameMenu = new game.ui.screens.GameMenu();
		gameMenu.onExit = () -> setState(GameState);
		gameMenu.onMenuClick = () -> setState(MainMenuState);

		gameui = new game.ui.screens.GameUi();
		gameui.onMenuClick = () -> setState(MenuState);
		
		endScreen = new game.ui.screens.CycleEnd();
		endScreen.onClick = function() {
			Game.restartCycle();
			setState(GameState);
		}
	
		// the background for the menu.
		background = new h2d.Graphics(this);
		drawBackgroundLayer();
	
		var versionText = new game.ui.Text("Version: " + sn.Macros.getVersionNumberFromGit(), Const.MENU_FONT_SMALL, background);
		versionText.x = Const.WORLD_WIDTH - 10;
		versionText.y = Const.WORLD_HEIGHT - 10;
		versionText.setAlignment(Right, Bottom);

		// an interactive used to block events to the game below it.
		var interactive = new h2d.Interactive(Const.WORLD_WIDTH, Const.WORLD_HEIGHT, background);
		
		setState(GameState);
	}
	
	public function addToInventory(item : Data.ItemsKind) gameui.addToInventory(item);
	public function removeFromInventory(item : Data.ItemsKind) gameui.removeFromInventory(item);

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

			case End:
				if (background.parent != this) addChild(background);
				drawBackgroundLayer();
				if (endScreen.parent != this) addChild(endScreen);
				endScreen.update();
				gameui.onEnd();
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
		gameui.onScene(locationName);
	}

	public function onMap() {
		gameui.onMap();
	}
}