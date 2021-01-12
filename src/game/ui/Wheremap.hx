package game.ui;

import hxd.Event;

class Wheremap extends Pulltab {

	var grid : h2d.Object;

	public function new(?parent : h2d.Object) {
		var tabicon = hxd.Res.items.classnotes.toTile();
		super(tabicon, parent);

		tab.x = Const.WORLD_WIDTH * 0.80;
		contentHeight = Const.WORLD_HEIGHT * 0.65;
		grid = new h2d.Object(content);
	}

	override function activate(?e:Event) {
		super.activate(e);
		grid.removeChildren();

		content.lineStyle(1,0xFFFF00);

		var locations = Data.locations.all.toArrayCopy();
		locations.sort((l1, l2) -> if(l1.id.toString() < l2.id.toString()) return -1 else return 1);

		var ySep = (contentHeight - Const.LOCATIONTAB_ITEMPADDING * 2) / (locations.length + 2);

		var xpos = 0.;
		for (i in 0 ... locations.length) {

			content.moveTo(Const.LOCATIONTAB_ITEMPADDING, ySep * (i + 2));
			content.lineTo(Const.WORLD_WIDTH - 2 * Const.LOCATIONTAB_ITEMPADDING, ySep * (i + 2));

			var text = new game.ui.Text(locations[i].name, Const.LOCATIONTAB_FONT, grid);
			text.x = Const.LOCATIONTAB_ITEMPADDING;
			text.y = (i + 2) * ySep;
			text.setAlignment(Left, Top);
			text.setScale(Const.LOCATIONTAB_FONT_SIZE);
			
			if (xpos < text.getWidth() + 2 * Const.LOCATIONTAB_ITEMPADDING)
				xpos = text.getWidth() + 2 * Const.LOCATIONTAB_ITEMPADDING;
		}

		content.moveTo(xpos, Const.LOCATIONTAB_ITEMPADDING);
		content.lineTo(xpos, contentHeight - 2 * Const.LOCATIONTAB_ITEMPADDING);

		var periods = [
			"Early\nMorning", "Late\nMorning",
			"Early\nAfternoon", "Late\nAfternoon",
			"Early\nEvening", "Late\nEvening"
		];

		for (i in 0 ... periods.length) {
			var text = new game.ui.Text(periods[i], Const.LOCATIONTAB_FONT, grid);
			text.x = xpos + Const.LOCATIONTAB_ITEMPADDING;
			text.y = Const.LOCATIONTAB_ITEMPADDING;
			text.setAlignment(Left, Top);
			text.setScale(Const.LOCATIONTAB_FONT_SIZE);

			xpos += 2 * Const.LOCATIONTAB_ITEMPADDING + text.getWidth();
			
			content.moveTo(xpos, Const.LOCATIONTAB_ITEMPADDING);
			content.lineTo(xpos, contentHeight - 2 * Const.LOCATIONTAB_ITEMPADDING);
		}

	}
}