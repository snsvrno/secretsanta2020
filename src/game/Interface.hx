package game;

import haxe.display.Display.Package;
import game.choice.Text;

class Interface extends h2d.Object {

	static private var overColor : h3d.Vector = new h3d.Vector(1,1,0,1);
	static private var normalColor : h3d.Vector = new h3d.Vector(1,1,1,1);

	private var locationName : h2d.Text;
	private var backButton : h2d.Text;
	private var menuButton : h2d.Text;
	private var menu : h2d.Object;
	private var menuBackground : h2d.Graphics;
	private var clock : game.ui.Clock;

	public function new(parent : h2d.Object) {
		super(parent);

		locationName = new h2d.Text(hxd.res.DefaultFont.get(), this);
		locationName.dropShadow = { dx : 1., dy : 1., color : 0x000000, alpha : 0.85 };
		locationName.setScale(3);
		locationName.color = normalColor;

		// BACK BUTTON ////////////////////////////////////////////////////////////////////

		backButton = new h2d.Text(hxd.res.DefaultFont.get(), this);
		backButton.text = " <<";
		backButton.color = normalColor;
		backButton.dropShadow = locationName.dropShadow;
		backButton.setScale(locationName.scaleX);
		
		var backButtonInteractive = new h2d.Interactive(backButton.textWidth, backButton.textHeight, backButton);
		backButtonInteractive.onOver = (e : hxd.Event) -> buttonOver(backButton);
		backButtonInteractive.onOut = (e : hxd.Event) -> buttonOut(backButton);
		backButtonInteractive.onClick = function (e : hxd.Event) Game.toMap();
		
		// MENU BUTTON ////////////////////////////////////////////////////////////////////

		menuButton = new h2d.Text(hxd.res.DefaultFont.get(), this);
		menuButton.text = "MENU";
		menuButton.setScale(2);
		menuButton.x = Const.WORLD_CORNER_RADIUS;
		menuButton.y = Const.WORLD_HEIGHT - menuButton.textHeight * menuButton.scaleY;

		var menuButtonInteractive = new h2d.Interactive(menuButton.textWidth, menuButton.textHeight, menuButton);
		menuButtonInteractive.onOver = (e : hxd.Event) -> buttonOver(menuButton);
		menuButtonInteractive.onOut = (e : hxd.Event) -> buttonOut(menuButton);
		menuButtonInteractive.onClick = (e : hxd.Event) -> toggleMenu();
		
		// CLOCK ///////////////////////////////////////////////////////////////////////////

		clock = new game.ui.Clock(this);
		clock.x = Const.WORLD_WIDTH - Const.WORLD_CORNER_RADIUS - clock.width;

		// MENU ///////////////////////////////////////////////////////////////////////////

		menu = new h2d.Object();
		
		menuBackground = new h2d.Graphics(menu);
		drawMenuBackground();

		var text1 = new h2d.Text(hxd.res.DefaultFont.get(), menu);
		text1.text = "TESTING";

		var backgroudInteractive = new h2d.Interactive(Const.WORLD_WIDTH, Const.WORLD_HEIGHT, menu);
		backgroudInteractive.onClick = (e : hxd.Event) -> if (e.button == 1) toggleMenu();
		backgroudInteractive.enableRightButton = true;

	}

	public function setLocationName(name : String) {
		locationName.text = name;
		locationName.x = Const.WORLD_WIDTH - Const.WORLD_CORNER_RADIUS / 2 - locationName.textWidth * locationName.scaleX;
		locationName.y = Const.WORLD_HEIGHT - 2 - locationName.textHeight * locationName.scaleY;
	
		adjustBackButton();
	}

	private function adjustBackButton() {
		backButton.x = locationName.x - backButton.textWidth * backButton.scaleX;
		backButton.y = locationName.y + 3;
	}

	private function buttonOver(t : h2d.Text) t.color = overColor;
	private function buttonOut(t : h2d.Text) t.color = normalColor;

	private function toggleMenu() {
		if (menu.parent != null) removeChild(menu);
		else { 
			addChild(menu);
			drawMenuBackground();
		}
	}

	private function drawMenuBackground() {
		menuBackground.clear();
		menuBackground.beginFill(0x000000, 0.85);
		menuBackground.drawRect(0, 0, Const.WORLD_WIDTH, Const.WORLD_HEIGHT);
		menuBackground.endFill();
	}

	public function onMap() {
		backButton.remove();
		locationName.remove();
	}

	public function onScene() {
		if (backButton.parent != this) addChild(backButton);
		if (locationName.parent != this) addChild(locationName);
	}

	public function updateClock(clock : game.Clock) {
		this.clock.drawState(clock);
	}

}