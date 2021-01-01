package game;

class Conditions {

	static public function check(condition : Data.Condition) : Bool {
		switch (condition) {
			case Forwarder(condition, action): return true;
			case InsertChoices(condition, action, cont): return true;

			case Exists(name): return Game.variables.check(name);
			case NotExists(name):return !Game.variables.check(name);
			case And(c1, c2): return check(c1) && check(c2);
			case Or(c1, c2): return check(c1) || check(c2);
			case Have(item): return Game.variables.has(item.name);
			case NotHave(item): return !Game.variables.has(item.name);

			case AtLeast(period): return Game.currentPeriod() >= period;

			case Value(name, value): return Game.variables.value(name) == value;
			case ValueAtLeast(name, value): return Game.variables.value(name) >= value;
			case ValueLessThan(name, value): return Game.variables.value(name) < value;

			case Talked(character): return Game.variables.hasMet(character.id);
			case NotTalked(character): return !Game.variables.hasMet(character.id);

			case Location(location): return Game.currentScene() == location.name;
			case NotLocation(location): return Game.currentScene() != location.name;

			case Period(period): return Game.currentPeriod() == period;
			case PeriodGTE(period): return Game.currentPeriod() >= period;
			case PeriodLTE(period): return Game.currentPeriod() <= period;

			case null: return true;
		}
	}
}