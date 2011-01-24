package org.understandinguncertainty.QRISKLifetime
{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.understandinguncertainty.QRISKLifetime.interfaces.IGenderRisks;
	import org.understandinguncertainty.QRISKLifetime.support.IntervalTimer;
	import org.understandinguncertainty.QRISKLifetime.vo.QParametersVO;
	import org.understandinguncertainty.QRISKLifetime.vo.QResultVO;
	import org.understandinguncertainty.QRISKLifetime.vo.TimeTableRow;

	[Event(name="complete", type="flash.events.Event")]
	public class FlashScore2011 extends EventDispatcher
	{
		public var outputData:String;
		public var errorData:String;
		public var timeTables:Vector.<Vector.<TimeTableRow>>;
		
		public var result:QResultVO;
		
		public function calculateScore(path:String, p:QParametersVO):void
		{
			outputData = "";
			errorData = "";
			var a_cvd:Number;
			var a_death:Number;
			var gr:IGenderRisks = (p.b_gender == 0) ? new Female() : new Male();
			
			a_cvd = gr.cvd(p);	
			a_death = gr.death(p);		
			
			var lifetimeRisk:LifetimeRisk = new LifetimeRisk();
//			var intervalTimer:IntervalTimer = new IntervalTimer();

			lifetimeRisk.addEventListener(Event.INIT, function(event:Event):void {
				lifetimeRisk.addEventListener(Event.COMPLETE, function(event:Event):void {
					result = lifetimeRisk.result;
					result.nYearRisk *= 100;
					result.lifetimeRisk *= 100;
//					trace("lifetimeRisk: "+intervalTimer.readTime("lifetimeRisk"));
					dispatchEvent(new Event(Event.COMPLETE));
				});
				lifetimeRisk.lifetimeRisk(path, p.age, a_cvd, a_death, p.noOfFollowUpYears);
			});
//			intervalTimer.time("lifetimeRisk");
			lifetimeRisk.load(path);

		}				
	}
}