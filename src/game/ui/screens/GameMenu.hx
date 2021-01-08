package game.ui.screens;

class GameMenu extends h2d.Object {

	private var gameMenuTitle : game.ui.Text;

	private var achievementsPage : game.ui.screens.Achievements;
	private var progressPage : game.ui.screens.Progress;

	public var onExit : Null<() -> Void>;
	public var onMenuClick : Null<() -> Void>;

	public function new() {
		super();

		achievementsPage = new game.ui.screens.Achievements();
		progressPage = new game.ui.screens.Progress();

		// the title, that will be used in submenus and stuff
		gameMenuTitle = new game.ui.Text("", Const.MENU_TITLE_FONT, this);
		gameMenuTitle.setScale(0.75);
		gameMenuTitle.x = Const.WORLD_WIDTH - 10;
		gameMenuTitle.y = 10;
		gameMenuTitle.setAlignment(Right, Top);

		var description = new game.ui.Text("", Const.MENU_FONT_SMALL, this);
		description.x = 10;
		description.y = Const.WORLD_HEIGHT - 10;
		description.setWrapWidth(Math.floor(Const.WORLD_WIDTH / 2));
		description.setAlignment(Left,Bottom);

		var buttonStack = new game.ui.VStack(this);

		var con = new game.ui.Button("Continue");
		con.setContainerHook(buttonStack);
		con.description = "";
		con.descriptionObject = description;
		con.onClick = function() {
			if (onExit != null) onExit();
			removeChild(achievementsPage);
			removeChild(progressPage);
		}

		var prog = new game.ui.Button("Progress");
		prog.setContainerHook(buttonStack);
		prog.description = "Check on exploration progress.";
		prog.descriptionObject = description;
		prog.onClick = function() {
			if (achievementsPage.parent == this) achievementsPage.remove();
			addChild(progressPage);
			gameMenuTitle.setText("Progress");
		}

		var achi = new game.ui.Button("Achievements");
		achi.setContainerHook(buttonStack);
		achi.description = "Check on story and quest achievements.";
		achi.descriptionObject = description;
		achi.onClick = function() {
			if (progressPage.parent == this) progressPage.remove();
			addChild(achievementsPage);
			gameMenuTitle.setText("Achievements");
		}

		var mainmenu = new game.ui.Button("Main Menu");
		mainmenu.setContainerHook(buttonStack);
		mainmenu.description = "To the game main menu.";
		mainmenu.descriptionObject = description;
		mainmenu.onClick = function() {
			if(onMenuClick != null) onMenuClick();
			removeChild(achievementsPage);
			removeChild(progressPage);
		}
		//mainmenu.onClick = () -> setState(MainMenuState);

		buttonStack.x = 10;
		buttonStack.y = Const.WORLD_HEIGHT / 2;
		buttonStack.setAlignment(Left, Middle);
		buttonStack.setChildrenAlignment(Left, Bottom);

		buttonStack.push(con);
		buttonStack.push(prog);
		buttonStack.push(achi);
		buttonStack.push(mainmenu);
	}

	override function onAdd() {
		super.onAdd();

		gameMenuTitle.setText("Game Menu");
	}
}