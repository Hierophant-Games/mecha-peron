package game 
{
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class Constants 
	{
		public static const GRAVITY:Number = 100;
		
		// Peron
		public static const PERON_SPEED_X:Number = 30;
		public static const PERON_MAX_HEALTH:Number = 100;		
		public static const LASER_PLANE_DAMAGE:Number = 3;
		public static const LASER_SOLDIER_DAMAGE:Number = 1;
		public static const LASER_MAX_CHARGE:Number = 5000;
		public static const LASER_CHARGE_STEP:Number = 10; // how much charge the laser consumes and reloads each frame
		public static const LASER_RECHARGE_DELAY:Number = 1.5; // seconds
		
		// Plane
		public static const PLANE_SPEED_X:Number = -80;
		public static const PLANE_MAX_HEALTH:Number = 100;
		public static const PLANE_BOMB_DAMAGE:Number = 5;
		public static const PLANE_WARNING_X_THRESHOLD:Number = 200; // distance from the right edge of the screen onwards in which the warning signs will appear
		
		// Cannon
		public static const CANNON_ATTACK_DELAY:Number = 3.0; // how much seconds waits since it´s visible to release bomb
		public static const CANNON_BOMB_DAMAGE:Number = 10;
		public static const CANNON_BOMB_SPEED:Number = 60;	
		
		// Soldier
		public static const SOLDIER_BULLET_SPEED_X:Number = -50;
		public static const SOLDIER_BULLET_DAMAGE:Number = 1;
	}
}
