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

			var t0:int = timeTable.getTAt(timeTableIndex);
			

			var lifetimeRiskTable:LifetimeRiskTable = new LifetimeRiskTable();
			annualRiskTable = new LifetimeRiskTable();
			
			var t:int = t0-1;
			
			for(var i:int=0; i < timeTable.length - from - 1; i++) {			// why -1 ????
				
				var baseHazard:BaseHazard = timeTable.getBaseHazardAt(timeTableIndex);
				
				lifetimeRiskTable.push(1 - baseHazard.cvd_1 - baseHazard.death_1, baseHazard.cvd_1, baseHazard.death_1);
				
				// populate the annual table if we've reached a year boundary
				var t1:int = timeTable.getTAt(timeTableIndex);
				if(t1 > t) {
					t = t1;
					annualRiskTable.rows[t-t0] = i > 0 ? lifetimeRiskTable.rows[i-1] : new LifetimeRiskRow(1,0,0);
//					trace("annual[",t,"]=life[",i,"]=",annualRiskTable.getRiskAt(t-t0));
				}
				
				timeTableIndex++;
			}
			
			// put the last annual row in - we may not have reached a t boundary in the loop
			annualRiskTable.rows[t-t0 + 1] = i > 0 ? lifetimeRiskTable.rows[i-1] : new LifetimeRiskRow(1,0,0);			
			
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
//					trace("lifeTimeIndex for nYear ", followupIndex, " is: ", followupRow-startRow, " risk=", lifetimeRiskTable.getRiskAt(followupRow-startRow));
					nYearRisk = lifetimeRiskTable.getRiskAt(followupRow-startRow);	
				}
				
/*				trace("annual table when nyearRisk=",nYearRisk," lifetime=",lifetimeRisk);
				for(var i:int = 0; i < annualRiskTable.rows.length; i++) {
					trace(i, ": ", annualRiskTable.rows[i].cif_cvd);
				}
*/				
				// set summary result
				result = new QResultVO(nYearRisk, lifetimeRisk);

				dispatchEvent(new Event(Event.COMPLETE));
			});
			
			// either read in, or access a cached copy of the published data file
			timeTable.load(path);
		}
	}
}