package game.choice;

class Text extends h2d.Object {

	static private final maxWidth : Int = 100;
	static private final cornerRadius : Int  = 4;
	static private final padding : Int = 6;

	static private final overColor : h3d.Vector = new h3d.Vector(252/255,212/255,15/255,1);
	static private final normalColor : h3d.Vector = new h3d.Vector(0.75,0.75,0.75,1);
	static private final alreadyColor : h3d.Vector = new h3d.Vector(0.20,0.20,0.20,1);

	private var text : h2d.Text; 
	private var interactive : h2d.Interactive;

	public function new(dialogue : Data.Dialogue, parent : h2d.Object) {
		super(parent);

		var font = hxd.res.DefaultFont.get();

		var background = new h2d.Graphics(this);
		text = new h2d.Text(font, this);
		text.maxWidth = maxWidth;

		text.text = dialogue.display;
		if (Game.variables.isChosenOption(dialogue.id)) text.color = alreadyColor;
		else text.color = normalColor;

		background.beginFill(0x000000);
		background.drawRoundedRect(-padding, -padding, text.textWidth + 2*padding, text.textHeight + 2*padding, cornerRadius);
		background.endFill();

		interactive = new h2d.Interactive(text.textWidth, text.textHeight, this);
		// adds this local because we need to track the original color because a mouse over
		// could change the used color to normal.
		var lastColor : h3d.Vector;
		interactive.onOver = function(e : hxd.Event) { 
			lastColor = text.color;
			text.color = overColor;
		};
		interactive.onOut = function(e : hxd.Event) text.color = lastColor; 
	}

	public function setHook(hook : (e : hxd.Event) -> Void) interactive.onClick = hook;

	public function setX(x : Float) {
		this.x = x - text.textWidth / 2;
	}

	public function setY(y : Float) {
		this.y = y - text.textHeight	 / 2;
	}
}