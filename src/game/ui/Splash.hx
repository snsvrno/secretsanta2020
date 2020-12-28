package game.ui;

class Splash extends h2d.Object {

	public var onFinish : Null<() -> Void>;

	private var fadeTimer : sn.Timer;

	public function new (parent : h2d.Object) {
		super(parent);

		filter = new h2d.filter.Nothing();
		fadeTimer = new sn.Timer(Const.SPLASH_TIMER_WAIT + Const.SPLASH_TIMER_FADE);
		fadeTimer.updateCallback = function() if (fadeTimer.timer > Const.SPLASH_TIMER_WAIT)
				this.alpha = 1 - (fadeTimer.timer - Const.SPLASH_TIMER_WAIT) / Const.SPLASH_TIMER_FADE;
		fadeTimer.finalCallback = function() {
			this.remove();
			if (onFinish != null) onFinish();
		}
		fadeTimer.start();

		var background = new h2d.Graphics(this);
		background.beginFill(Const.BACKGROUND_COLOR);
		background.drawRect(-Const.WORLD_CORNER_RADIUS_OVERSHOOT, -Const.WORLD_CORNER_RADIUS_OVERSHOOT, Const.WORLD_WIDTH+Const.WORLD_CORNER_RADIUS_OVERSHOOT * 2, Const.WORLD_HEIGHT + Const.WORLD_CORNER_RADIUS_OVERSHOOT * 2);
		background.endFill();

		// used to block anything behind this.
		var dummy = new h2d.Interactive(Const.WORLD_WIDTH, Const.WORLD_HEIGHT, this);
		dummy.cursor = hxd.Cursor.Default;

		///////////
		// TITLE

		var titleStack = new game.ui.VStack(this);
		titleStack.x = Const.WORLD_WIDTH / 2;
		titleStack.y = 20 + Const.WORLD_SCREEN_PADDING;
		titleStack.setAlignment(Center, Top);
		titleStack.setChildrenAlignment(Center);

		var title = new game.ui.Text(Const.GAMETITLE, Const.MENU_TITLE_FONT);
		title.setColor(Const.SPLASH_TEXT_COLOR);

		var subtitle = new game.ui.HStack();
		subtitle.setChildrenAlignment(Middle);

		var gameby = new game.ui.Text("a game by ");
		gameby.setColor(Const.SPLASH_TEXT_COLOR);
		gameby.setScale(0.75);

		var snsvrno = new game.ui.Snsvrno();
		snsvrno.setScale(0.75);
		snsvrno.onOver = () -> fadeTimer.stop();
		snsvrno.onOut = () -> fadeTimer.start();
		
		subtitle.pushAll([gameby, snsvrno]);

		titleStack.pushAll([title, subtitle]);

		///////////
		// TOOL STACK

		var toolStack = new game.ui.VStack(this);
		toolStack.x = Const.WORLD_WIDTH / 2;
		toolStack.y = Const.WORLD_HEIGHT - Const.WORLD_SCREEN_PADDING / 2;
		toolStack.setAlignment(Center, Bottom);
		toolStack.setChildrenAlignment(Center);

		var midStack = new game.ui.HStack();
		midStack.padding = 150;

		var tools = new game.ui.VStack();
		tools.padding = Const.SPLASH_TOOL_LOGO_PADDING;
		tools.setAlignment(Center, Middle);
		tools.setChildrenAlignment(Center);

		var toolstext = new game.ui.Text("made with");
		toolstext.setScale(0.5);
		toolstext.setColor(Const.SPLASH_TEXT_COLOR);
		tools.push(toolstext);
		tools.push(new game.ui.HorizontalLine(150));

		var assets = new game.ui.VStack();
		assets.padding = Const.SPLASH_TOOL_LOGO_PADDING;
		assets.setAlignment(Center, Middle);
		assets.setChildrenAlignment(Center);
		
		var assetstest = new game.ui.Text("using fonts");
		assetstest.setScale(0.5);
		assetstest.setColor(Const.SPLASH_TEXT_COLOR);
		assets.push(assetstest);
		assets.push(new game.ui.HorizontalLine(150));

		midStack.push(tools);
		midStack.push(assets);
		toolStack.push(midStack);

		var logos = [
			{ t: hxd.Res.tools.haxe_logo_white_background.toTile(), l: "https://haxe.org/" },
			{ t: hxd.Res.tools.logo_heaps_color.toTile(), l: "https://heaps.io/" },
		];

		var logoHeight = (Const.WORLD_HEIGHT - (logos.length + 1) * Const.SPLASH_TOOL_LOGO_PADDING) / logos.length;
		for (l in logos) {
			var licon = new game.ui.Icon(l.t);
			licon.setAlignment(Center, Middle);
			licon.setHeight(Math.floor(Math.min(Const.SPLASH_TOOL_LOGO_MAXWIDTH, logoHeight)));


			var interactive = new h2d.Interactive(licon.getWidth() / licon.scaleX, licon.getHeight() / licon.scaleY);
			interactive.x = - licon.getWidth() / licon.scaleX / 2;
			interactive.onOver = function(e : hxd.Event) {
				fadeTimer.stop();
				licon.alpha = Const.SPLASH_OVER_LINK_ALPHA;
			}
			interactive.onOut = function(e : hxd.Event) {
				fadeTimer.start();
				licon.alpha = 1;
			}
			interactive.onClick = (e: hxd.Event) -> hxd.System.openURL(l.l);
			licon.addChild(interactive);

			#if debug
			var g = new h2d.Graphics(licon);
			g.beginFill(0xFF0000, 0.25);
			g.drawRect(interactive.x,interactive.y,interactive.width, interactive.height);
			g.endFill();
			#end

			tools.push(licon);
		}
		
		var fonts = [
			{ font: hxd.Res.fonts.wolf24.toFont(), t: "Wolfganger", a: "Nalgames", l: "https://nalgames.com/" },
			{ font: hxd.Res.fonts.sket64.toFont(), t: "Sketches", a: "Fani Rizky", l: "https://www.dafont.com/fani-rizky.d6677" },
			{ font: hxd.Res.fonts.edi24.toFont(), t: "Edson Comics", a: "edy2012", l: "https://www.dafont.com/edson-comics.d4391" },
			{ font: hxd.Res.fonts.sye64.toFont(), t: "Syemox", a: "Faqih Fawaji", l: "https://www.dafont.com/faqih-fawaji.d7431" },
		];

		for (a in fonts) {
			var text = new game.ui.Text(a.t, a.font);
			text.setColor(Const.SPLASH_TEXT_COLOR);
			text.setHeight(Const.SPLASH_TOOL_FONT_MAXHEIGHT);

			var interactive = new h2d.Interactive(text.getWidth() / text.scaleX, text.getHeight() / text.scaleY);
			interactive.x = - text.getWidth() / text.scaleX / 2;
			interactive.onOver = function(e : hxd.Event) {
				fadeTimer.stop();
				text.alpha = Const.SPLASH_OVER_LINK_ALPHA;
			}
			interactive.onOut = function(e : hxd.Event) {
				fadeTimer.start();
				text.alpha = 1;
			}
			interactive.onClick = (e: hxd.Event) -> hxd.System.openURL(a.l);
			text.addChild(interactive);

			assets.push(text);
		}

		midStack.setAlignment(Center, Bottom);
		midStack.setChildrenAlignment(Middle);

		toolStack.setAlignment(Center, Bottom);
		toolStack.setChildrenAlignment(Center);
	}
}