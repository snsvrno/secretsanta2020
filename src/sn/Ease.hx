/*
 * Copyright (c) 2020 snsvrno
 * 
 * Some easing functions.
 * 
 * This is a good reference. 
 * https://easings.net/
 * 
 * 
 */

package sn;

class Ease {
	
	/**
	 * A helper function, used in all easing functions.
	 * 
	 * @param x the scale factor, between 0 - 1 
	 * @param a the starting value
	 * @param b the ending value
	 * 
	 * @return Float
	 */
	private static function base(x : Float, a : Float, b : Float) : Float {
		return a + (b-a) * x;
	}

	/**
	 * Linear easing function, will return the linear position between two points
	 * 
	 * @param l length 
	 * @param t current time tick
	 * @param a first position
	 * @param b second position
	 * 
	 * @return Float
	 */
	public static function linear(l : Float, t : Float, a : Float, b : Float) : Float  {
		return base(t/l, a, b);
	}

	/**
	 * An in and out circle function, translation of the funciton found [here](https://easings.net/#easeInOutCirc)
	 * 
	 * @param l length 
	 * @param t current time tick
	 * @param a first position
	 * @param b second position
	 * 
	 * @return Float
	 */
	public static function inOutCirc(l : Float, t : Float, a : Float, b : Float) : Float {
		var x = if (t/l < 0.5) {
			(1 - std.Math.sqrt(1 - std.Math.pow(2 * t/l, 2))) / 2;
		} else {
			(std.Math.sqrt(1 - std.Math.pow(-2 * t/l + 2, 2)) + 1) / 2;
		}

		return base(x, a, b);
	}

	/**
	 * An out circle function, translation of the funciton found [here](https://easings.net/#easeOutCirc)
	 * 
	 * @param l length 
	 * @param t current time tick
	 * @param a first position
	 * @param b second position
	 * 
	 * @return Float
	 */
	public static function outCirc(l : Float, t : Float, a : Float, b : Float) : Float {
		var x = std.Math.sqrt(1 - std.Math.pow(t/l - 1, 2));

		return base(x, a, b);
	}
	
}
