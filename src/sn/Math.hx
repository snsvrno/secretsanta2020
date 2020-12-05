/*
 * Copyright (c) 2020 snsvrno
 * 
 * Some useful math functions
 */
 
 package sn;

 class Math {
 
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
		 if (value < lower) { return lower; }
		 else if (value > upper) { return upper; }
		 else { return value; }
	 }
 }