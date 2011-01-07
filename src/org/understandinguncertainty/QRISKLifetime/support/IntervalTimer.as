package org.understandinguncertainty.QRISKLifetime.support
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class IntervalTimer
	{
		private var timers:Object = {};
		private const resolution:int = 100; // in ms
		
		public function time(name:String):void
		{
			if(timers[name])
				throw new Error("timer "+name + " running when started");
			
			timers[name] = (new Date()).getTime();
		}
		
		public function readTime(name:String):Number
		{
			var timer:Number = timers[name] as Number;
			if(timers[name] == null)
				throw new Error("timer "+name + " does not exist");
			
			var time:Number = new Date().getTime() - timer;
			timers[name] = null;
			return time;
		}
		
	}
}