/*
This file forms part of the library which provides the JBS3Risk Risk Model.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk

It contains code derived from http://qrisk.org/lifetime/QRISK-lifetime-2011-opensource.v1.0.tgz released by ClinRisk Ltd.

*/
package org.understandinguncertainty.QRLifetime
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.understandinguncertainty.QRLifetime.support.IntervalTimer;
	import org.understandinguncertainty.QRLifetime.vo.BaseHazard;
	import org.understandinguncertainty.QRLifetime.vo.LifetimeRiskRow;
	import org.understandinguncertainty.QRLifetime.vo.QResultVO;
	import org.understandinguncertainty.QRLifetime.vo.TimeTableRow;

	[Event(name="init", type="flash.events.Event")]
	[Event(name="complete", type="flash.events.Event")]
	public class LifetimeRisk extends EventDispatcher
	{
		// summary result
		public var result:QResultVO;
		
		private var timeTable:TimeTable;
		
		public function load(path:String):void
		{
			timeTable = new TimeTable();
			timeTable.addEventListener(Event.COMPLETE, timeTableLoaded);
			timeTable.load(path);
		}

		public function timeTableLoaded(event:Event):void
		{
			timeTable.removeEventListener(Event.COMPLETE, timeTableLoaded);
			dispatchEvent(new Event(Event.INIT));
		}
		
		/**
		 * 
		 * Create new array
		 * & form the product and sum as we go
		 * return the array
		 * NB need to multiply cif by 100 to get percentage
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
												 followupYear:int,
												 a_cvd:Number, 
												 a_death:Number):QResultVO
		{
			var sage:int = 30;	// start age
			var lage:int = 95;	// last age
			var timeTableIndex:int = from;
			
			timeTable.init(a_cvd, a_death);

			var t0:int = timeTable.getTAt(timeTableIndex);
			
			var annualRiskTable:LifetimeRiskTable = new LifetimeRiskTable();
			var lastRow:LifetimeRiskRow;
			var newRow:LifetimeRiskRow;
			var nYearRisk:Number = 0;
			
			var t:int = t0-1;
			
			for(var i:int=0; i < timeTable.length - from - 1; i++) {
				
				var baseHazard:BaseHazard = timeTable.getBaseHazardAt(timeTableIndex);
				
				if(i==0) {

					// Note: this is original QRISK code which fails when the timeTable bin size is large since 
					// we cannot then ignore the death and cvd in the first bin.
					//
					//	lastRow = new LifetimeRiskRow(1 - baseHazard.cvd_1 - baseHazard.death_1, 0, 0);
					//
					lastRow = new LifetimeRiskRow(
						1 - baseHazard.cvd_1 - baseHazard.death_1, 
						baseHazard.cvd_1, 
						baseHazard.death_1,
						1 - baseHazard.cvd_1,
						baseHazard.cvd_1
					);
				}
				else {
					newRow = new LifetimeRiskRow(
						lastRow.S_1*(1 - baseHazard.cvd_1 - baseHazard.death_1), 
						lastRow.cif_cvd + lastRow.S_1 * baseHazard.cvd_1, 
						lastRow.cif_death + lastRow.S_1 * baseHazard.death_1,
						lastRow.S_noDeath*(1 - baseHazard.cvd_1),
						lastRow.cvd_noDeath + lastRow.S_noDeath * baseHazard.cvd_1
					);
					
					lastRow = newRow;
				}
								
				// populate the annual table if we've reached a year boundary
				var t1:int = timeTable.getTAt(timeTableIndex);
//				var t2:Number = timeTable.getTAt(timeTableIndex);
				if(t1 > t) {
					t = t1;
					annualRiskTable.rows.push(lastRow);
				}
				
				if(t == followupYear-1) {
					nYearRisk = lastRow.cif_cvd;
				}
				
				timeTableIndex++;
			}
			
			annualRiskTable.rows.push(lastRow);
									
			// set summary result
			return  new QResultVO(nYearRisk, lastRow.cif_cvd, null, annualRiskTable);
			
		}
		
		private var intervalTimer:IntervalTimer = new IntervalTimer();
		public function lifetimeRisk(path:String, cage:int, a_cvd:Number, a_death:Number, noOfFollowupYears:Number):void 
		{			

			var sage:int = 30;	// start age
		 	var lage:int = 95;	// last age
			
			var timeTable:TimeTable = new TimeTable();
			
			var listener:Function = function (event:Event):void {
				
				// timeTable load is complete
				var startRow:int = timeTable.find_biggest_t_below(cage-sage);
				
				// get n-year risk
				var followupYear:int = cage-sage+noOfFollowupYears;
				
				result = produceLifetimeRiskTable(timeTable, startRow, followupYear, a_cvd, a_death);
				timeTable.removeEventListener(Event.COMPLETE, listener);
				
				dispatchEvent(new Event(Event.COMPLETE));
			}
			
			timeTable.init(a_cvd, a_death);
			
			timeTable.addEventListener(Event.COMPLETE, listener);
			
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
													  followupYear:int,
													  a_cvd:Number, 
													  a_death:Number,
													  a_cvd_int:Number, 
													  a_death_int:Number,
													  lifetimeRiskTable:LifetimeRiskTable,
													  lifetimeRiskTable_int:LifetimeRiskTable
		):QResultVO
		{
			var timeTableIndex:int = from;
			var timeTableIndex_int:int = from_int;
			
			
			var t0:int = timeTable.getTAt(timeTableIndex);
			var t0_int:int =  timeTable.getTAt(timeTableIndex_int);
			
			// trace("from="+from+" from_int="+from_int+" t0="+t0+" t0_int="+t0_int);
					
			var annualRiskTable:LifetimeRiskTable = new LifetimeRiskTable();
			var annualRiskTable_int:LifetimeRiskTable = new LifetimeRiskTable();
			
			var lastRow:LifetimeRiskRow;
			var lastRow_int:LifetimeRiskRow;
			
			var newRow:LifetimeRiskRow;
			var newRow_int:LifetimeRiskRow;
			
			var nYearRisk:Number = 0;
			
			timeTable.init(a_cvd, a_death);
			
			var t:int = t0-1;
		
			
			// before interventions are applied
			for(var f:int=from; f < from_int; f++) {			
				
				var i:int = f - from;
				
				var baseHazard:BaseHazard = timeTable.getBaseHazardAt(timeTableIndex);
								
				if(i==0) {
					lastRow = new LifetimeRiskRow(
						1 - baseHazard.cvd_1 - baseHazard.death_1, 
						baseHazard.cvd_1, 
						baseHazard.death_1, 
						1 - baseHazard.cvd_1, 
						baseHazard.cvd_1 
					);
				}
				else {
					newRow = new LifetimeRiskRow(
						lastRow.S_1*(1 - baseHazard.cvd_1 - baseHazard.death_1), 
						lastRow.cif_cvd + lastRow.S_1 * baseHazard.cvd_1, 
						lastRow.cif_death + lastRow.S_1 * baseHazard.death_1, 
						lastRow.S_noDeath*(1 - baseHazard.cvd_1),
						lastRow.cvd_noDeath + lastRow.S_noDeath*baseHazard.cvd_1);
					
					lastRow = newRow;
				}
				
				// populate the annual table if we've reached a year boundary
				var t1:int = timeTable.getTAt(timeTableIndex);
				if(t1 > t) {
					t = t1;
					annualRiskTable.rows.push(lastRow);
					annualRiskTable_int.rows.push(lastRow);
				}
				
				if(t == followupYear-1)
					nYearRisk = lastRow.cif_cvd;
				
				timeTableIndex++;
			}
			
			lastRow_int = lastRow;
			
			// after interventions are applied 
			for(i=f-from; i < timeTable.length - from - 1; f++, i++) {			
				
				timeTable.init(a_cvd, a_death);
				baseHazard = timeTable.getBaseHazardAt(timeTableIndex);
				
				timeTable.init(a_cvd_int, a_death_int);
				var baseHazard_int:BaseHazard = timeTable.getBaseHazardAt(timeTableIndex);
				
				if(i==0) {
					lastRow = new LifetimeRiskRow(
						1 - baseHazard.cvd_1 - baseHazard.death_1, 
						baseHazard.cvd_1, 
						baseHazard.death_1,
						1 - baseHazard.cvd_1,
						baseHazard.cvd_1
					);
					lastRow_int = new LifetimeRiskRow(
						1 - baseHazard_int.cvd_1 - baseHazard_int.death_1, 
						baseHazard_int.cvd_1, 
						baseHazard_int.death_1,
						1 - baseHazard_int.cvd_1,
						baseHazard_int.cvd_1
					);
				}
				else {
					newRow = new LifetimeRiskRow(
						lastRow.S_1*(1 - baseHazard.cvd_1 - baseHazard.death_1), 
						lastRow.cif_cvd + lastRow.S_1 * baseHazard.cvd_1, 
						lastRow.cif_death + lastRow.S_1 * baseHazard.death_1,
						lastRow.S_noDeath*(1 - baseHazard.cvd_1),
						lastRow.cvd_noDeath + lastRow.S_noDeath*baseHazard.cvd_1
					);
					newRow_int = new LifetimeRiskRow(
						lastRow_int.S_1*(1 - baseHazard_int.cvd_1 - baseHazard_int.death_1), 
						lastRow_int.cif_cvd + lastRow_int.S_1 * baseHazard_int.cvd_1, 
						lastRow_int.cif_death + lastRow_int.S_1 * baseHazard_int.death_1,
						lastRow_int.S_noDeath*(1 - baseHazard_int.cvd_1),
						lastRow_int.cvd_noDeath + lastRow_int.S_noDeath*baseHazard_int.cvd_1
					);
										
					lastRow = newRow;
					lastRow_int = newRow_int;
				}
				
				// populate the annual table if we've reached a year boundary
				t1 = timeTable.getTAt(timeTableIndex);
				if(t1 > t) {
					t = t1;
					annualRiskTable.rows.push(lastRow);
					annualRiskTable_int.rows.push(lastRow_int);
				}
				
				if(t == followupYear-1)
					nYearRisk = lastRow.cif_cvd;
				
				timeTableIndex++;
			}
			
			annualRiskTable.rows.push(lastRow);
			annualRiskTable_int.rows.push(lastRow_int);
			
			// set summary result
			return  new QResultVO(nYearRisk, lastRow.cif_cvd, null, annualRiskTable, annualRiskTable_int);
			
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
			
			var listener:Function = function(event:Event):void {
				
				// timeTable load is complete
				var startRow:int = timeTable.find_biggest_t_below(cage-sage);
				var startRow_int:int = timeTable.find_biggest_t_below(cage_int-sage);
				
				var lifetimeRiskTable:LifetimeRiskTable = new LifetimeRiskTable();
				var lifetimeRiskTable_int:LifetimeRiskTable = new LifetimeRiskTable();
				
				// get n-year risk
				var followupYear:int = cage-sage+noOfFollowupYears;
				
				result = produceLifetimeRiskTable_int(timeTable, 
					startRow, startRow_int,
					followupYear,
					a_cvd, a_death,
					a_cvd_int, a_death_int,
					lifetimeRiskTable,
					lifetimeRiskTable_int
				);
				
				timeTable.removeEventListener(Event.COMPLETE, listener);
				dispatchEvent(new Event(Event.COMPLETE));
			}
			
			timeTable.addEventListener(Event.COMPLETE, listener);
			
			// either read in, or access a cached copy of the published data file
			timeTable.load(path);
		}
		
	}
}