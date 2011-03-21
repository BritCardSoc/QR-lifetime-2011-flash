package org.understandinguncertainty.QRISKLifetime
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.understandinguncertainty.QRISKLifetime.support.IntervalTimer;
	import org.understandinguncertainty.QRISKLifetime.vo.BaseHazard;
	import org.understandinguncertainty.QRISKLifetime.vo.LifetimeRiskRow;
	import org.understandinguncertainty.QRISKLifetime.vo.QResultVO;
	import org.understandinguncertainty.QRISKLifetime.vo.TimeTableRow;

	[Event(name="init", type="flash.events.Event")]
	[Event(name="complete", type="flash.events.Event")]
	public class LifetimeRisk extends EventDispatcher
	{
		// Risk results will be placed in this annual table.
		public var annualRiskTable:LifetimeRiskTable;
		
		public function load(path:String):void
		{
			var timeTable:TimeTable = new TimeTable();
			timeTable.addEventListener(Event.COMPLETE, timeTableLoaded);
			timeTable.load(path);
		}

		public function timeTableLoaded(event:Event):void
		{
			dispatchEvent(new Event(Event.INIT));
		}
		
		/**
		 * 
		 * Create new array
		 * & form the product and sum as we go
		 * return the array
		 * NB need to multiply cif by 100 to get percentage
		 * 
		 * Note: see unused/LifetimeRisk-annotated for a copy of the source with ported C code in comments
		 * 
		 * @param timeTable
		 * @param from
		 * @param a_cvd
		 * @param a_death
		 * @return 
		 * 
		 */
		public function produceLifetimeRiskTable(timeTable:TimeTable, 
												 from:int, 
												 a_cvd:Number, 
												 a_death:Number):LifetimeRiskTable
		{
			var timeTableIndex:int = from;
			
			timeTable.init(a_cvd, a_death);
			var baseHazard:BaseHazard = timeTable.getBaseHazardAt(timeTableIndex++);
			

			var lifetimeRiskTable:LifetimeRiskTable = new LifetimeRiskTable();
			annualRiskTable = new LifetimeRiskTable();
			
			lifetimeRiskTable.push(1 - baseHazard.cvd_1 - baseHazard.death_1, 0, 0);
			annualRiskTable.push(1 - baseHazard.cvd_1 - baseHazard.death_1, 0, 0);
						
			var t:int = 0;
			for(var i:int=1; i < timeTable.length - from -1; i++) {
				
				baseHazard = timeTable.getBaseHazardAt(timeTableIndex++);
				
				lifetimeRiskTable.push(1 - baseHazard.cvd_1 - baseHazard.death_1, baseHazard.cvd_1, baseHazard.death_1);
				
				// populate the annual table if we've reached a year boundary
				var t1:int = timeTable.getTAt(i);
				if(t1 > t) {
					t = t1;
					annualRiskTable.rows[t] = lifetimeRiskTable.rows[i];
				}
				
			}
			
			return lifetimeRiskTable;
		}
		
		public var result:QResultVO;
		
		private var intervalTimer:IntervalTimer = new IntervalTimer();

		public function lifetimeRisk(path:String, cage:int, a_cvd:Number, a_death:Number, noOfFollowupYears:Number):void 
		{			

			var sage:int = 30;	// start age
		 	var lage:int = 95;	// last age
			
			var timeTable:TimeTable = new TimeTable();
			
			timeTable.init(a_cvd, a_death);
			
			timeTable.addEventListener(Event.COMPLETE, function(event:Event):void {
				
				// timeTable load is complete
				var startRow:int = timeTable.find_biggest_t_below(cage-sage)+1;
				
				var lifetimeRiskTable:LifetimeRiskTable = produceLifetimeRiskTable(timeTable, startRow, a_cvd, a_death);
				
				var lifetimeRisk:Number = lifetimeRiskTable.lifetimeRisk;
				
				// get n-year risk
				var followupIndex:int = cage-sage+noOfFollowupYears;

				var nYearRisk:Number;
				if (followupIndex >= lage-sage) {
				  	nYearRisk = lifetimeRisk;
				}
				else {
				  	var followupRow:int = timeTable.find_biggest_t_below(followupIndex);
					nYearRisk = lifetimeRiskTable.getRiskAt(followupRow-startRow);	
				}
				
				// set summary result
				result = new QResultVO(nYearRisk, lifetimeRisk);

				dispatchEvent(new Event(Event.COMPLETE));
			});
			
			// either read in, or access a cached copy of the published data file
			timeTable.load(path);
		}
	}
}