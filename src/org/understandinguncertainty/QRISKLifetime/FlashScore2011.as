package org.understandinguncertainty.QRISKLifetime
{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.understandinguncertainty.QRISKLifetime.vo.QResultVO;
	import org.understandinguncertainty.QRISKLifetime.vo.TimeTableRow;

	[Event(name="complete", type="flash.events.Event")]
	public class FlashScore2011 extends EventDispatcher
	{
		public var outputData:String;
		public var errorData:String;
		public var timeTables:Vector.<Vector.<TimeTableRow>>;
		
		public var result:QResultVO;
		
		public function calculateScore(
			path:String,		// path to csv file (must agree with gender)
			b_gender:int,		// 0..1
			b_AF:int,			// 0..1
			b_ra:int,			// 0..1
			b_renal:int, 		// 0..1
			b_treatedhyp:int, 	// 0..1 
			b_type2:int,         // 0..1
			bmi:Number,          // 20..40
			ethrisk:int,         // 1..9
			fh_cvd:int,          // 0..1
			rati:Number,          // 1..12
			sbp:Number,           // 70..210
			smoke_cat:int,        //  0..4
			town:Number,          // -7..11
			age:int,              // ..95
			noOfFollowupYears:int // <95-age
		):void
		{
			outputData = "";
			errorData = "";
			var a_cvd:Number;
			var a_death:Number;
			if(b_gender == 0) {
				// female
				var f:Female = new Female();
				a_cvd = f.cvd(			
					b_AF,
					b_ra,
					b_renal,
					b_treatedhyp,
					b_type2,
					bmi,
					ethrisk,
					fh_cvd,
					rati,
					sbp,
					smoke_cat,
					town);
				a_death = f.death(			
					b_AF,
					b_ra,
					b_renal,
					b_treatedhyp,
					b_type2,
					bmi,
					ethrisk,
					fh_cvd,
					rati,
					sbp,
					smoke_cat,
					town);
				
				var lifetimeRisk:LifetimeRisk = new LifetimeRisk();
				lifetimeRisk.addEventListener(Event.INIT, function(event:Event):void {
					lifetimeRisk.addEventListener(Event.COMPLETE, function(event:Event):void {
						result = lifetimeRisk.result;
						dispatchEvent(new Event(Event.COMPLETE));
					});
					lifetimeRisk.lifetimeRisk(path, age, a_cvd, a_death, noOfFollowupYears);
				});
				lifetimeRisk.load(path);
			}
		}				
	}
}