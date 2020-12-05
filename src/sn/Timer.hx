package sn;

class Timer {

	private static var que : Array<Timer> = [];
	/**
	 * Should be called only once. will update the entire timer que
	 * every time called.
	 */
	public static function update(dt : Float) {		
		var i = que.length;
		while (i >= 1) {
			if (que[i-1].instanceUpdate(dt)) {
				que.remove(que[i-1]);
			}
			i--;
		}
	}

	/**
	 * The overall time limit for the timer.
	 */
	private var timeLimit : Float;

	/**
	 * The value of the timer from 0.0 to 1.0;
	 */
	public var timerPercent(get, null) : Float;
	private function get_timerPercent() : Float return timer/timeLimit;

	/**
	 * The callback that is run when the timer
	 * runs out.
	 */
	public var finalCallback : () -> Void;

	/**
	 * The callback that is called every update.
	 */
	public var updateCallback : () -> Void;

	/**
	 * Whether the time is enabled (true) or disabled (false)
	 */
	public var timerStatus : Bool = true;

	/**
	 * The actual timer value.
	 */
	public var timer(default, null) : Float = 0.0;

	public function new(limit : Float) {
		timeLimit = limit;

		que.push(this);
	}

	/**
	 * Update, should be called at a regular frequency passing the 
	 * dt of call. The timer will not update unless this is used.
	 * 
	 * @param dt 
	 * @return Bool
	 */
	private function instanceUpdate(dt : Float) : Bool {
		timer += dt;

		if (timeLimit <= timer) {
			timer = timeLimit;
			if (finalCallback != null) { 
				finalCallback();
			}
			timerStatus = false;
			return true;
		} else {
			if (updateCallback != null) {
				updateCallback();
			}
		}

		return false;
	}
}