package game.ui.screens;

class Achievements extends h2d.Object {

	static private var area = { 
		x : Const.WORLD_WIDTH/2, 
		y : Const.WORLD_HEIGHT/5, 
		w : Const.WORLD_WIDTH - 10 - Const.WORLD_WIDTH/2, 
		h : Const.WORLD_HEIGHT - 10 - 2 * Const.WORLD_HEIGHT/5 
	};

	private var items : Array<h2d.Object> = [];

	#if debug
	private var bg : h2d.Graphics;
	#end

	public function new() {
		super();

		#if debug
		bg = new h2d.Graphics(this);
		#end
	}

	override function onAdd() {
		super.onAdd();

		update();
	}

	private function update() {

		#if debug
		bg.clear();
		bg.lineStyle(2,0xFF0000);
		bg.drawRect(area.x, area.y, area.w, area.h);
		#end

		// cleans up the items.
		while(items.length > 0) items.pop().remove();

		// sorts the achievements alphabetically.
		var achievements = Data.achievements.all.toArrayCopy();
		achievements.sort((a,b) -> if (a.title > b.title) return 1 else return -1);

		var background = hxd.Res.achievements.bg.toTile();
		var scale = Math.min(Const.ACHIEVEMENTS_ICON_SIZE / background.width, Const.ACHIEVEMENTS_ICON_SIZE / background.height);
		var overScale = Math.min(Const.ACHIEVEMENTS_ICON_SIZE_OVER / background.width, Const.ACHIEVEMENTS_ICON_SIZE_OVER / background.height);
		
		var x = area.x;
		var y = area.y;
		
		for (a in achievements) {

			// only show the ones that are enabled in the code.
			if (a.enabled == false) continue;

			///////////////////////////////////////////////
			// makes the icon.

			var empty = new h2d.Object(this);

			var backgroundIcon = new game.ui.Icon(background, empty);
			backgroundIcon.setAlignment(Center, Middle);
			var achievementIcon = new game.ui.Icon(hxd.Res.load(a.icon).toTile(), empty);
			achievementIcon.setAlignment(Center, Middle);

			////////////////////////////////////////////
			// creating the information about this achievement.
			var popup = new h2d.Object();
			var title = new game.ui.Text(a.title,Const.ACHIEVEMENTS_TITLE_FONT,popup);
			title.setAlignment(Left, Bottom);
			title.setColor(Const.ACHIEVEMENTS_TITLE_COLOR);
			title.filter = new h2d.filter.Outline();
			var description = new game.ui.Text(a.description, Const.ACHIEVEMENTS_DESCRIPTION_FONT, popup);
			description.setAlignment(Left, Top);
			description.setColor(Const.ACHIEVEMENTS_DESCRIPTION_COLOR);
			description.filter = new h2d.filter.Outline();

			////////////////////////////////////////////
			// setting up the shaders and stuff.
			var satShader = new shader.screen.Saturation();
			satShader.intensity = 1;

			var darkShaderIntensity = if (Game.variables.earnedAchievement(a)) 0.
				else Const.ACHIEVEMENTS_UNACHIEVED_INTENSITY;
			var darkShader = new shader.screen.Darken();
			darkShader.intensity = darkShaderIntensity;
			darkShader.color = new hxsl.Types.Vec(0,0,0,1);

			var filterGroup = new h2d.filter.Group();
			filterGroup.add(new h2d.filter.Shader(satShader));
			filterGroup.add(new h2d.filter.Shader(darkShader));

			empty.filter = filterGroup;

			////////////////////////////////////////////
			// the timer

			var timer = new sn.Timer(Const.ACHIEVEMENTS_ANIMATION_LENGTH, true);
			timer.updateCallback = function() {
				satShader.intensity = 1 - timer.timerPercent;
				darkShader.intensity = (0 - darkShaderIntensity) * timer.timerPercent + darkShaderIntensity;
				empty.setScale((overScale - scale) * timer.timerPercent + scale);
			}
			timer.stop();

			////////////////////////////////////////////
			// the interactive to connect everything together.

			var interactive = new h2d.Interactive(backgroundIcon.getWidth(), backgroundIcon.getHeight(), empty);
			interactive.x = -backgroundIcon.getWidth() / 2;
			interactive.y = - backgroundIcon.getHeight() / 2;

			interactive.onOver = function(e : hxd.Event) {
				empty.setScale(overScale);
				timer.reset();
				timer.start();
				addChild(popup);
			};

			interactive.onOut = function(e : hxd.Event) {
				empty.setScale(scale);
				timer.reverse();
				removeChild(popup);
			};

			/////////////////////////////////////////////////
			// determines placement.

			if (x + backgroundIcon.getWidth() * scale + Const.ACHIEVEMENTS_ICON_PADDING > (area.w + area.x)) {
				x = area.x;
				y += backgroundIcon.getHeight() * scale + Const.ACHIEVEMENTS_ICON_PADDING;
			}

			empty.x = x + backgroundIcon.getWidth() * scale / 2;
			empty.y = y + backgroundIcon.getHeight() * scale / 2;
			
			popup.y = empty.y;
			if (empty.x < Const.WORLD_WIDTH / 2) {
				popup.x = empty.x + backgroundIcon.getWidth() * overScale / 2 + Const.ACHIEVEMENTS_ICON_PADDING;
			} else {
				title.setAlignment(Right, Bottom);
				description.setAlignment(Right, Top);
				popup.x = empty.x - backgroundIcon.getWidth() * overScale / 2 - Const.ACHIEVEMENTS_ICON_PADDING;
			}
	
			x += backgroundIcon.getWidth() * scale + Const.ACHIEVEMENTS_ICON_PADDING;

			empty.setScale(scale);
			items.push(empty);
		}
	}
}