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
	
	import org.understandinguncertainty.QRLifetime.interfaces.IGenderRisks;
	import org.understandinguncertainty.QRLifetime.support.IntervalTimer;
	import org.understandinguncertainty.QRLifetime.vo.QParametersVO;
	import org.understandinguncertainty.QRLifetime.vo.QResultVO;
	import org.understandinguncertainty.QRLifetime.vo.TimeTableRow;

	[Event(name="complete", type="flash.events.Event")]
	public class FlashScore2011 extends EventDispatcher
	{
		public var outputData:String;
		public var errorData:String;
		public var lifetimeRisk:LifetimeRisk = new LifetimeRisk();
		
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
			
			var listener1:Function = function(event:Event):void {
				var listener2:Function = function(event:Event):void {
					result = lifetimeRisk.result;
					result.nYearRisk *= 100;
					result.lifetimeRisk *= 100;
					dispatchEvent(new Event(Event.COMPLETE));
					lifetimeRisk.removeEventListener(Event.COMPLETE, listener2);
				}
				lifetimeRisk.addEventListener(Event.COMPLETE, listener2);
				lifetimeRisk.lifetimeRisk(path, p.age, a_cvd, a_death, p.noOfFollowUpYears);
				lifetimeRisk.removeEventListener(Event.INIT, listener1);
			}
			lifetimeRisk.addEventListener(Event.INIT, listener1);
			lifetimeRisk.load(path);
		}
		
		/**
		 * 
		 * @param path 
		 * 		Path to lifetable data
		 * @param p
		 * 		QParameters without intervention
		 * @param p_int
		 * 		QParameters with intervention. NB The age field is used to indicate the start of the intervention
		 * 		and so p_int.age >= p.age.
		 * 
		 */
		public function calculateScoreWithInterventions(path:String, 
														p:QParametersVO, 
														p_int:QParametersVO):void
		{
			outputData = "";
			errorData = "";
			var a_cvd:Number;
			var a_death:Number;
			var a_cvd_int:Number;
			var a_death_int:Number;
			
			var gr:IGenderRisks = (p.b_gender == 0) ? new Female() : new Male();
			a_cvd = gr.cvd(p);	
			a_death = gr.death(p);		
			a_cvd_int = gr.cvd(p_int);	
			a_death_int = gr.death(p_int);		
			
			var listener1:Function = function(event:Event):void {
				var listener2:Function = function(event:Event):void {
					result = lifetimeRisk.result;
					result.nYearRisk *= 100;
					result.lifetimeRisk *= 100;
					dispatchEvent(new Event(Event.COMPLETE));
					lifetimeRisk.removeEventListener(Event.COMPLETE, listener2);
				}
				lifetimeRisk.addEventListener(Event.COMPLETE, listener2);
				lifetimeRisk.lifetimeRisk_int(path, p.age, p_int.age, a_cvd, a_death, a_cvd_int, a_death_int, p.noOfFollowUpYears);
				lifetimeRisk.removeEventListener(Event.INIT, listener1);
			}
			lifetimeRisk.addEventListener(Event.INIT, listener1);
			lifetimeRisk.load(path);			
		}
		
		/**
		 * 
		 * @param path 
		 * 		Path to lifetable data
		 * @param p
		 * 		QParameters without intervention
		 * @param p_int
		 * 		QParameters with intervention. NB The age field is used to indicate the start of the intervention
		 * 		and so p_int.age >= p.age.
		 * 
		 */
		public function djsCalculateScoreWithInterventions(path:String, 
														p:QParametersVO, 
														p_int:QParametersVO,
														cholDiff:Number,
														cholDiff_int:Number):void
		{
			outputData = "";
			errorData = "";
			var a_cvd:Number;
			var a_death:Number;
			var a_cvd_int:Number;
			var a_death_int:Number;
			
			// trace("djs: p.age="+p.age+" p.age_int="+p_int.age);
			
			
			// get baseline cvd and death risks for without intervention parameters p
			var gr:IGenderRisks = (p.b_gender == 0) ? new Female() : new Male();
			a_cvd = gr.cvd(p);	
			a_death = gr.death(p);
			
			// with intervention starts at same hazard
			a_cvd_int = a_cvd;
			a_death_int = a_death;
			
			// adjust cvd for new cholesterol (cholDiff  is totalCholesterol - hdlCholesterol in mmol/L)
			a_cvd_int += (cholDiff - cholDiff_int)*Math.log(0.82);
			
			// adjust cvd for new sbp
			a_cvd_int += (p.sbp - p_int.sbp)*Math.log(0.966);
			
			// adjust cvd for new smoking category
			a_cvd_int += (gr.getSmokeCVDAt(p_int.smoke_cat) - gr.getSmokeCVDAt(p.smoke_cat));
			
			// adjust death for new smoking category
			a_death_int +=  (gr.getSmokeDeathAt(p_int.smoke_cat) - gr.getSmokeDeathAt(p.smoke_cat));

			// Could do with promises here due to messy asynchronous data table reads
			var listener1:Function = function(event:Event):void {
				var listener2:Function = function(event:Event):void {
					result = lifetimeRisk.result;
					result.nYearRisk *= 100;
					result.lifetimeRisk *= 100;
					dispatchEvent(new Event(Event.COMPLETE));
					lifetimeRisk.removeEventListener(Event.COMPLETE, listener2);
				}
				lifetimeRisk.addEventListener(Event.COMPLETE, listener2);
				lifetimeRisk.lifetimeRisk_int(path, p.age, p_int.age, a_cvd, a_death, a_cvd_int, a_death_int, p.noOfFollowUpYears);
				lifetimeRisk.removeEventListener(Event.INIT, listener1);
			}
			lifetimeRisk.addEventListener(Event.INIT, listener1);
			lifetimeRisk.load(path);			
		}
	}
}