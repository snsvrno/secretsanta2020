package game.ui;

class Snsvrno extends game.ui.Element {

	static private var snsvrnoColors : Array<Int> = [ 0xff3ab0, 0xf0f3bd, 0x1a5e63 ];

	private var colorIndex : Int = 0;
	private var animator : sn.Timer;

	private var main : game.ui.Text;
	private var shadow : game.ui.Text;

	public var onOver : Null<() -> Void>;
	public var onOut : Null<() -> Void>;

	public var shadowOffset : { x : Int, y : Int } = { x : 2, y : 2 };

	override public function getHeight() : Float return (main.getHeight() + shadowOffset.y) * scaleY;
	override public function getWidth() : Float return (main.getWidth() + shadowOffset.x) * scaleX;


	public function new() {
		super();

		shadow = new game.ui.Text("snsvrno", Const.TEXT_FONT_SNSVRNO, this);
		main = new game.ui.Text("snsvrno", Const.TEXT_FONT_SNSVRNO, this);

		animator = new sn.Timer(Const.SPLASH_SNSVRNO_SWITCHTIME, true);

		shadow.setAlignment(Left, Middle);
		shadow.x = shadowOffset.x;
		shadow.y = shadowOffset.y;

		animator.infinite = true;
		animator.finalCallback = nextColor;

		var interactive = new h2d.Interactive(main.getWidth(), main.getHeight(), main);
		interactive.y = - main.getHeight() / 2;
		interactive.onOver = (e: hxd.Event) -> if (onOver != null) onOver();
		interactive.onOut = (e: hxd.Event) -> if (onOut != null) onOut();
		interactive.onClick = (e: hxd.Event) -> hxd.System.openURL(Const.SPLASH_SNSVRNO_WEBSITE);
	}

	private function nextColor() {
		main.setColor(snsvrnoColors[colorIndex]);

		if (colorIndex++ >= snsvrnoColors.length) colorIndex = 0;

		shadow.setColor(snsvrnoColors[colorIndex]);
	}

	override public function setAlignment(?horizontal : game.ui.alignment.Horizontal, ?vertical : game.ui.alignment.Vertical) {
		main.setAlignment(horizontal, vertical);
		shadow.setAlignment(horizontal, vertical);
	}

}