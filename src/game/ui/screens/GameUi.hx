package game.ui.screens;

class GameUi extends h2d.Object {
	
	private var locationText : game.ui.Button;
	private var backpack : game.ui.Backpack;

	public var onMenuClick : Null<() -> Void>;

	public function new() {
		super();
		
		var menuButton = new game.ui.Button("Menu", Const.MENU_FONT_SMALL, this);
		menuButton.x = 10;
		menuButton.y = Const.WORLD_HEIGHT - 10;
		// menuButton.onClick = () -> setState(MenuState);
		menuButton.onClick = () -> if(onMenuClick != null) onMenuClick();
		menuButton.setAlignment(Left, Bottom);
		menuButton.normalColor = Const.MENU_BUTTON_COLOR_GAMEMENU_ONLIGHT;

		locationText = new game.ui.Button("<location>");
		locationText.x = Const.WORLD_WIDTH - 10;
		locationText.y = Const.WORLD_HEIGHT - 10;
		locationText.normalColor = Const.MENU_BUTTON_COLOR_GAMEMENU_ONLIGHT;
		locationText.setAlignment(Right, Bottom);
		locationText.onClick = () -> Game.toMap();

		backpack = new Backpack(this);
	}

	public function onEnd() {
		backpack.removeAllItems();
	}

	public function onScene(locationName : String) {

		if (locationText.parent != this) addChild(locationText);
		locationText.setText("<< " + locationName);

		for (c in children) 
			if (Std.isOfType(c, game.ui.Button)) 
				cast(c, game.ui.Button).normalColor = Const.MENU_BUTTON_COLOR_GAMEMENU_ONDARK;

	}

	public function onMap() {
		for (c in children) 
			if (Std.isOfType(c, game.ui.Button)) 
				cast(c, game.ui.Button).normalColor = Const.MENU_BUTTON_COLOR_GAMEMENU_ONLIGHT;

		locationText.remove();
	}
}