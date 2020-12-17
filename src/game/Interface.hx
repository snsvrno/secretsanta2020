package game;

class Interface extends h2d.Object {

	static private var overColor : h3d.Vector = new h3d.Vector(1,1,0,1);
	static private var normalColor : h3d.Vector = new h3d.Vector(1,1,1,1);

	private var locationName : h2d.Text;
	private var backButton : h2d.Text;

	public function new(parent : h2d.Object) {
		super(parent);

		locationName = new h2d.Text(hxd.res.DefaultFont.get(), this);
		locationName.dropShadow = { dx : 1., dy : 1., color : 0x000000, alpha : 0.85 };
		locationName.setScale(3);
		locationName.color = normalColor;

		backButton = new h2d.Text(hxd.res.DefaultFont.get(), this);
		backButton.text = " <<";
		backButton.color = normalColor;
		backButton.dropShadow = locationName.dropShadow;
		backButton.setScale(locationName.scaleX);

		var backButtonInteractive = new h2d.Interactive(backButton.textWidth, backButton.textHeight, backButton);
		backButtonInteractive.onOver = function(e : hxd.Event) backButton.color = overColor;
		backButtonInteractive.onOut = function(e : hxd.Event) backButton.color = normalColor;
		backButtonInteractive.onClick = function (e : hxd.Event) Game.toMap();

	}

	public function setLocationName(name : String) {
		locationName.text = name;
		locationName.x = Const.WORLDWIDTH - Const.SOFTCORNERRADIUS / 2 - locationName.textWidth * locationName.scaleX;
		locationName.y = Const.WORLDHEIGHT - 2 - locationName.textHeight * locationName.scaleY;
	
		adjustBackButton();
	}

	private function adjustBackButton() {
		backButton.x = locationName.x - backButton.textWidth * backButton.scaleX;
		backButton.y = locationName.y + 3;
	}

	public function onMap() {
		backButton.remove();
		locationName.remove();
	}

	public function onScene() {
		if (backButton.parent != this) addChild(backButton);
		if (locationName.parent != this) addChild(locationName);
	}

}