package game;

private enum Period {
	EarlyMorning;
	Morning;
	EarlyAfternoon;
	Afternoon;
	EarlyEvening;
	Evening;
}

class Clock {

	/**
	 * The number of time slots that each period has, basically means
	 * the number of places the player can move too and interact with
	 * during a period.
	 */
	inline static public var SLOTSPERPERIOD : Int = 2;
	inline static public var PERIODS : Int = 6;

	public var slotsLeft(default, null) : Int = SLOTSPERPERIOD;
	public var period(default, null) : Period = EarlyMorning;

	public function new() { }

	/**
	 * Steps the clock forward the given number of periods
	 * @param number = 1 
	 */
	public function stepPeriods(?number = 1) {
		while(number > 0) {
			nextPeriod();
			number--;
		}
	}

	public function useSlot(?number = 1) {
		slotsLeft -= 1;
		if (slotsLeft < 0) slotsLeft = 0;
	}

	/**
	 * Goes to the next period
	 */
	private function nextPeriod() {
		switch(period) {
			case EarlyMorning: period = Morning;
			case Morning: period = EarlyAfternoon;
			case EarlyAfternoon: period = Afternoon;
			case Afternoon: period = EarlyEvening;
			case EarlyEvening: period = Evening;
			case Evening: period = EarlyMorning;
		}
		slotsLeft = SLOTSPERPERIOD;
	}

	
	public function periodNumber() : Int {
		switch(period) {
			case EarlyMorning: return 1;
			case Morning: return 2;
			case EarlyAfternoon: return 3;
			case Afternoon: return 4;
			case EarlyEvening: return 5;
			case Evening: return 6;
		}
	}
	
	public function slotNumber() : Int return SLOTSPERPERIOD - slotsLeft + 1;

}