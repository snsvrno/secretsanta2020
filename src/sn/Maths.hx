/*
 * Copyright (c) 2020 snsvrno
 * 
 * Some useful math functions
 */
 
 package sn;

typedef Point = { x : Float, y : Float };
typedef Circle = { x : Float, y : Float, r : Float };

class Maths {
 
	 /**
	  * Clamps the float between the two given values. If no values are given the it
	  * will default to clamp between `0.0` and `1.0`
	  * 
	  * @param value 
	  * @param lower 
	  * @param upper 
	  * @return Float
	  */
	public static function clampf(value : Float, lower : Float = 0.0, upper : Float = 0.1) : Float {
		if (value < lower) return lower;
		if (value > upper) return upper;
		return value;
	}

	public static function clamp(value : Int, lower : Null<Int>, upper : Null<Int>) : Int {
		if (lower != null && value < lower) return lower;
		if (upper != null && value > upper) return upper;
		return value;
	}

	public static function distance(p1 : Point, p2 : Point) : Float {
		return Math.sqrt(Math.pow(p1.x-p2.x,2)+Math.pow(p1.y-p2.y,2));
	}

	public static function circlesIntersection(c1 : Circle, c2 : Circle) : Null<Point> {
		var d = distance(c1, c2);
		if (d > c1.r + c2.r) return null;

		var a = (Math.pow(c1.r, 2) - Math.pow(c2.r, 2) + Math.pow(d, 2)) / (2 * d);
		var h = Math.sqrt(Math.pow(c1.r, 2)-Math.pow(a, 2));

		var p3 : Point = { 
			x: c1.x + a/d * (c2.x - c1.x),
			y: c1.y + a/d * (c2.y - c1.y),
		};

		return {
			x: p3.x + h/d * (c2.y - c1.y),
			y: p3.y - h/d * (c2.x - c2.x),
		};
	}

}