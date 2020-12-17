package game;

class Conditions {

	static public function check(condition : Data.Condition) : Bool {
		switch (condition) {
			case Forwarder(condition, action): return true;

			case Exists(name): return Game.variables.check(name);
			case NotExists(name):return !Game.variables.check(name);
			case And(c1, c2): return check(c1) && check(c2);
			case Or(c1, c2): return check(c1) || check(c2);
			case Have(item): return Game.variables.has(item.name);
			case NotHave(item): return !Game.variables.has(item.name);

			case null: return true;
		}
	}
}