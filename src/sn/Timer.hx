package sn;

import h3d.scene.Object;

enum TimerState {
	/**
	 * The timer is counting down,
	 */
	Play;
	/**
	 * The timer isn't finished, but isn't counting
	 * anymore.
	 */
	Pause;
	/**
	 * The timer has reached the end of the countdown.
	 */
	End;
}

class Timer {

	////////////////////////////////////////////////////////////////////////////////////////
	// PRIVATE STATIC MEMBERS

	private static var que : Array<Timer> = [];

	////////////////////////////////////////////////////////////////////////////////////////
	// PUBLIC STATIC FUNCTIONS

	/**
	 * Should be called only once. will update the entire timer que
	 * every time called.
	 */
	public static function update(dt : Float) {		
		var i = que.length;
		while (i >= 1) {
			if (que[i-1].instanceUpdate(dt) == End && que[i-1].reusable == false) {
				que.remove(que[i-1]);
			}
			i--;
		}
	}

	////////////////////////////////////////////////////////////////////////////////////////
	// PRIVATE INSTANCE MEMBERS

	/**
	 * The overall time limit for the timer.
	 */
	private var timeLimit : Float;

	/**
	 * Can the timer be reused once it is finished, basically prevents the timer
	 * static function from removing it from the que.
	 */
	private var reusable : Bool;

	/**
	 * The timer status / state.
	 */
	private var status : TimerState = Play;

	////////////////////////////////////////////////////////////////////////////////////////
	// PUBLIC INSTANCE MEMBERS

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
	 * The actual timer value.
	 */
	 public var timer(default, null) : Float = 0.0;

	////////////////////////////////////////////////////////////////////////////////////////
	// PRIVATE INSTANCE FUNCTIONS

	/**
	 * Update, should be called at a regular frequency passing the 
	 * dt of call. The timer will not update unless this is used.
	 * 
	 * @param dt 
	 * @return Bool
	 */
	 private function instanceUpdate(dt : Float) : TimerState {
		if (status != Play) return status;

		timer += dt;

		if (timeLimit <= timer) {
			timer = timeLimit;
			if (finalCallback != null) finalCallback();
			status = End;
		} else {
			if (updateCallback != null) updateCallback();
		}

		return status;
	}

	////////////////////////////////////////////////////////////////////////////////////////
	// PUBLIC INSTANCE FUNCTIONS

	public function new(limit : Float, ?reusable = false) {
		timeLimit = limit;
		this.reusable = reusable;

		que.push(this);
	}

	/**
	 * Stops the timer.
	 */
	public function stop() {
		// first checks if the timer is done, don't want to push it into 
		// a pause state of its finished.
		if (status != End) status = Pause;	
	}

	/**
	 * Starts the timer.
	 */
	public function start() {
		// first checks if the timer is done, don't want to push it into 
		// a start state of its finished.
		if (status != End) status = Play;	
	}

	/**
	 * Resets the timer to zero.
	 */
	public function reset() {
		status = Play;
		timer = 0;
	}

}