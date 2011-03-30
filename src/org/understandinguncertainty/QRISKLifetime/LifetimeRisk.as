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
		private var annualRiskTable:LifetimeRiskTable;
		
		// Risks with intervention will be placed here
		private var annualRiskTable_int:LifetimeRiskTable;
		
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
		private function produceLifetimeRiskTable(timeTable:TimeTable, 
												 from:int,
												 followupIndex:int,
												 a_cvd:Number, 
												 a_death:Number):QResultVO
		{
			var sage:int = 30;	// start age
			var lage:int = 95;	// last age
			var timeTableIndex:int = from;
			
			timeTable.init(a_cvd, a_death);

			var t0:int = timeTable.getTAt(timeTableIndex);
			

			var lifetimeRiskTable:LifetimeRiskTable = new LifetimeRiskTable();

			annualRiskTable = new LifetimeRiskTable();
			var lastRow:LifetimeRiskRow = new LifetimeRiskRow(1,0,0);
			var newRow:LifetimeRiskRow;
			var nYearRisk:Number;
			
			var t:int = t0-1;
			
			for(var i:int=0; i < timeTable.length - from - 1; i++) {
				
				var baseHazard:BaseHazard = timeTable.getBaseHazardAt(timeTableIndex);
				
				newRow = new LifetimeRiskRow(lastRow.S_1*(1 - baseHazard.cvd_1 - baseHazard.death_1), 
					lastRow.cif_cvd + lastRow.S_1 * baseHazard.cvd_1, 
					lastRow.cif_death + lastRow.S_1 * baseHazard.death_1);
								
				// populate the annual table if we've reached a year boundary
				var t1:int = timeTable.getTAt(timeTableIndex);
				if(t1 > t) {
					t = t1;

					annualRiskTable.rows.push(lastRow);
					lastRow = newRow;
					
					//		annualRiskTable.rows[t-t0] = i > 0 ? lifetimeRiskTable.rows[i-1] : new LifetimeRiskRow(1,0,0);
//					trace("annual[",t,"]=life[",i,"]=",annualRiskTable.getRiskAt(t-t0));
				}
				
				if(timeTableIndex == followupIndex)
					nYearRisk = lastRow.cif_cvd;
				
				timeTableIndex++;
			}
			
			annualRiskTable.rows.push(newRow);
			
			// put the last annual row in - we may not have reached a t boundary in the loop
			//annualRiskTable.rows[t-t0 + 1] = i > 0 ? lifetimeRiskTable.rows[i-1] : new LifetimeRiskRow(1,0,0);			
			
			var lifetimeRisk:Number = lastRow.cif_cvd;
			//var lifetimeRisk:Number = result.lifetimeRisk;
			
/*			if (followupIndex >= lage-sage) {
				nYearRisk = lifetimeRisk;
			}
			else {
				var followupRow:int = timeTable.find_biggest_t_below(followupIndex);
				//					trace("lifeTimeIndex for nYear ", followupIndex, " is: ", followupRow-startRow, " risk=", lifetimeRiskTable.getRiskAt(followupRow-startRow));
				nYearRisk = lifetimeRiskTable.getRiskAt(followupRow-startRow);	
			}
*/			
			// set summary result
			return  new QResultVO(nYearRisk, lifetimeRisk, null, annualRiskTable);
			
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
				
				// get n-year risk
				var followupIndex:int = cage-sage+noOfFollowupYears;

				result = produceLifetimeRiskTable(timeTable, startRow, followupIndex, a_cvd, a_death);
				

				dispatchEvent(new Event(Event.COMPLETE));
			});
			
			// either read in, or access a cached copy of the published data file
			timeTable.load(path);
		}
		
		/*
		*
		* INTERVENTIONS
		*
		*/
		private function produceLifetimeRiskTable_int(timeTable:TimeTable, 
												 from:int, 
												 from_int:int, 
												 a_cvd:Number, 
												 a_death:Number,
												 a_cvd_int:Number, 
												 a_death_int:Number,
												 lifetimeRiskTable:LifetimeRiskTable,
												 lifetimeRiskTable_int:LifetimeRiskTable
												):void
		{
			var timeTableIndex:int = from;
			var timeTableIndex_int:int = from_int;
			

			var t0:int = timeTable.getTAt(timeTableIndex);
			var t0_int:int =  timeTable.getTAt(timeTableIndex_int);
			
			
			annualRiskTable = new LifetimeRiskTable();
			annualRiskTable_int = new LifetimeRiskTable();
			
			timeTable.init(a_cvd, a_death);

			var t:int = t0-1;
			
			// before interventions are applied
			for(var f:int=from; f < from; f++) {			
				
				var i:int = f - from;
				
				var baseHazard:BaseHazard = timeTable.getBaseHazardAt(timeTableIndex);
				
				lifetimeRiskTable.push(1 - baseHazard.cvd_1 - baseHazard.death_1, baseHazard.cvd_1, baseHazard.death_1);
				lifetimeRiskTable_int.rows[i] = lifetimeRiskTable.rows[i];
				
				// populate the annual table if we've reached a year boundary
				var t1:int = timeTable.getTAt(timeTableIndex);
				if(t1 > t) {
					t = t1;
					annualRiskTable.rows[t-t0] = i > 0 ? lifetimeRiskTable.rows[i-1] : new LifetimeRiskRow(1,0,0);
//					trace("annual[",t,"]=life[",i,"]=",annualRiskTable.getRiskAt(t-t0));
				}
				
				timeTableIndex++;
			}
			
			// after interventions are applied
			for(var i:int=0; i < timeTable.length - from - 1; i++) {			
				
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
			
		}

		public function lifetimeRisk_int(path:String, cage:int, cage_int:int, 
										 a_cvd:Number, a_death:Number, 
										 a_cvd_int:Number, a_death_int:Number, 
										 noOfFollowupYears:Number):void 
		{			

			var sage:int = 30;	// start age
		 	var lage:int = 95;	// last age
			
			var timeTable:TimeTable = new TimeTable();
			
			timeTable.init(a_cvd, a_death);
			
			timeTable.addEventListener(Event.COMPLETE, function(event:Event):void {
				
				// timeTable load is complete
				var startRow:int = timeTable.find_biggest_t_below(cage-sage)+1;
				var startRow_int:int = timeTable.find_biggest_t_below(cage_int-sage)+1;
				
				var lifetimeRiskTable:LifetimeRiskTable = new LifetimeRiskTable();
				var lifetimeRiskTable_int:LifetimeRiskTable = new LifetimeRiskTable();
				
				produceLifetimeRiskTable_int(timeTable, 
					startRow, startRow_int, 
					a_cvd, a_death,
					a_cvd_int, a_death_int,
					lifetimeRiskTable,
					lifetimeRiskTable_int
				);
				
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
				result = new QResultVO(nYearRisk, lifetimeRisk, null, annualRiskTable);

				dispatchEvent(new Event(Event.COMPLETE));
			});
			
			// either read in, or access a cached copy of the published data file
			timeTable.load(path);
		}
	}
}