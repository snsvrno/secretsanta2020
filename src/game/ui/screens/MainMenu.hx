package game.ui.screens;

class MainMenu extends h2d.Object {

	public var onStartClick : Null<() -> Void>;
	public var onMenuClick : Null<() -> Void>;

	public function new() {
		super();
		
		////////////////////////////
		// the title

		var title = new game.ui.Text(Const.GAMETITLE, Const.MENU_TITLE_FONT);
		title.setScale(Const.MENU_TITLE_SIZE);
		if (title.getWidth() > Const.WORLD_WIDTH) title.setWidth(Const.WORLD_WIDTH - 2 * 20);

		var titleLineStack = new game.ui.HStack();
		var text = new game.ui.Text("a game by ");
		var snsv = new game.ui.Snsvrno();
		snsv.setScale(0.5);
		text.setHeight(Math.floor(snsv.getHeight() * 0.25));
		titleLineStack.push(text);
		titleLineStack.push(snsv);
		titleLineStack.setChildrenAlignment(Middle);
	
		var titleStack = new game.ui.VStack(this);
		titleStack.x = Const.WORLD_WIDTH - 10;
		titleStack.y = 10;
		titleStack.setAlignment(Right);
		titleStack.setChildrenAlignment(Right);
		titleStack.push(title);
		titleStack.push(titleLineStack);
		
		////////////////////////////
		// the menu

		var description = new game.ui.Text("", Const.MENU_FONT_SMALL, this);
		description.x = 10;
		description.y = Const.WORLD_HEIGHT - 10;
		description.setWrapWidth(Math.floor(Const.WORLD_WIDTH / 2));
		description.setAlignment(Left,Bottom);

		var buttonStack = new game.ui.VStack(this);

		var startText = if (Game.variables.loaded) "Continue"; else "Start";
		var start = new game.ui.Button(startText);
		start.setContainerHook(buttonStack);
		start.description = "Start or Continue a game.";
		start.descriptionObject = description;
		//start.onClick = () -> setState(GameState);
		start.onClick = () -> if(onStartClick != null) onStartClick();

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
		//gamemenu.onClick = () -> setState(MenuState);
		gamemenu.onClick = () -> if(onMenuClick != null) onMenuClick();

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
}