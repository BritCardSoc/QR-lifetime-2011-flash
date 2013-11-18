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
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	
	import mx.messaging.channels.StreamingAMFChannel;
	
	import org.understandinguncertainty.QRLifetime.vo.BaseHazard;
	import org.understandinguncertainty.QRLifetime.vo.TimeTableRow;

	[Event(name="complete", type="flash.events.Event")]
	public class TimeTable extends EventDispatcher
	{
		
		public const BINSIZE:Number = 0.02;
		public const SLOW:Boolean = false;
		
		public static var rows:Vector.<TimeTableRow>;
		private var exp_a_cvd:Number;
		private var exp_a_death:Number;
		
		public static var paths:Vector.<String> = new Vector.<String>();
		public static var loading:Boolean = false;
		public static var cachedRows:Vector.<Vector.<TimeTableRow>> = new Vector.<Vector.<TimeTableRow>>();
		
		public function load(path:String):void {
			if(SLOW)
				slowLoad(path);
			else
				quickLoad(path);
		}
		
		public function slowLoad(path:String):void
		{
			var pathIndex:int = paths.indexOf(path);
			if(pathIndex >= 0) {
				rows = cachedRows[pathIndex];
				dispatchEvent(new Event(Event.COMPLETE));
				return;
			}
			else {
				paths.push(path);
				pathIndex = paths.length - 1;
				rows = cachedRows[pathIndex] = new Vector.<TimeTableRow>();
			}
			var dataLoader:DataLoader = new DataLoader();
			dataLoader.load(path, function(event:Event):void {
				if(event.type == Event.COMPLETE) {
					var urlLoader:URLLoader = event.target as URLLoader;
					var data:String = urlLoader.data;
					var lines:Array = data.split(/\r?\n/);

					var index:int = 0;
					for(var i:int=0; i < lines.length; i++) {
						var line:String = lines[i] as String;
						if(line.match(/\s*#/))
							continue;
						var fields:Array = line.split(/\s*,\s*/);
						var n:Number = fields[0];
						if(!(n == n)) continue; // efficient test for NaN
						rows[index++] = new TimeTableRow(fields[1], fields[2], fields[3]);
					}
					
					// dispatch completion event 
					dispatchEvent(new Event(Event.COMPLETE));
				}
				else if(event.type == IOErrorEvent.IO_ERROR) {
					throw new Error((event as IOErrorEvent).text);
				}
				else {
					throw new Error(event.toString());
				}
				// ignore other event types (we aren't listening for them anyway)
			});
		}
		
		//
		// same as load, but we bin data in time (using BINSIZE years) rather than on every datapoint
		//
		public function quickLoad(path:String):void
		{
			if(loading)
				return;
			
			var pathIndex:int = paths.indexOf(path);
			if(pathIndex >= 0) {
				rows = cachedRows[pathIndex];
				dispatchEvent(new Event(Event.COMPLETE));
				return;
			}
			else {
				// It isn't, start loading
				loading = true;
				paths.push(path);
				pathIndex = paths.length - 1;
				rows = cachedRows[pathIndex] = new Vector.<TimeTableRow>();
			}
			var dataLoader:DataLoader = new DataLoader();
			dataLoader.load(path, function(event:Event):void {
				if(event.type == Event.COMPLETE) {
					var urlLoader:URLLoader = event.target as URLLoader;
					var data:String = urlLoader.data;
					var lines:Array = data.split(/\r?\n/);
					
					var nextBinToFill:int = 0;
					var sum_cvd:Number = 0;
					var sum_death:Number = 0;
					var bin0:Number = 0;
					
					for(var i:int=0; i < lines.length; i++) {
						var line:String = lines[i] as String;
						if(line.match(/\s*#/))
							continue;

						var fields:Array = line.split(/\s*,\s*/);
						var sex:Number = fields[0];
						if(!(sex == sex)) continue; // efficient test for NaN
						
						var t:Number = Number(fields[1]);
						if(!(t == t)) continue;
						
						var tBin:int = tIndex(t);
						
						// fill in any gaps with null rows
						for(var j:int = nextBinToFill; j < tBin; j++) {
							rows[j] = new TimeTableRow(indexT(j)+BINSIZE, 0, 0);
//							trace("["+j+"] "+rows[j]); 
						}
						nextBinToFill = tBin + 1;

						// now fill in tBin
						var death:Number = Number(fields[2]);
						var cvd:Number = Number(fields[3]);
						if(!(death==death) || !(cvd == cvd)) continue;
							
						var row:TimeTableRow = (tBin < rows.length) ? rows[tBin] : null;
						if(row == null) {
							row = new TimeTableRow(indexT(tBin)+BINSIZE, 0, 0);
							rows[tBin] = row;
						}
						row.prod_cvd *= (1 - cvd);
						row.prod_dth *= (1 - death);
						
//						row.q_cvd += cvd;
//						row.q_dth += death;
						row.q_cvd = 1 - row.prod_cvd;
						row.q_dth = 1 - row.prod_dth;
						
						
//						trace("["+tBin+"] "+row); 
					}

					loading = false;
					
						
					// dispatch completion event 
					dispatchEvent(new Event(Event.COMPLETE));
					
					checkSums(path);
				}
				else if(event.type == IOErrorEvent.IO_ERROR) {
					throw new Error((event as IOErrorEvent).text);
				}
				else {
					throw new Error(event.toString());
				}
				// ignore other event types. We aren't listening for them anyway.
			});
		}
		
		
		public function init(a_cvd:Number, a_death:Number):void
		{
			exp_a_cvd = Math.exp(a_cvd);
			exp_a_death = Math.exp(a_death);
		}
				
		public function getBaseHazardAt(index:int):BaseHazard
		{
			var row:TimeTableRow = rows[index];
			return new BaseHazard(row.q_cvd * exp_a_cvd, row.q_dth * exp_a_death);
		}
		
		public function get length():int
		{
			return rows == null ? 0 : rows.length;	
		}
		
		
		public function find_biggest_t_below(number:int):int 
		{
			var index:int = 0;
			for (var i:int = 0; i< rows.length; i++) {
				if (rows[i].t >= number) {
					index = i;
					break;
				}
			}
			return index;
		}
		
		private function tIndex(t:Number):int {
			return Math.floor(t / BINSIZE);
		}
		
		private function indexT(index:int):Number {
			return BINSIZE * index;
		}
		
		public function getTAt(index:int):Number
		{
			return rows[index].t;
		}
		
		public function checkSums(path:String):void
		{
			var t:Number = 0;
			var sum_cvd:Number = 0;
			var sum_dth:Number = 0;
			for(var i:int = 0; i < rows.length; i++) {
				t = rows[i].t;
				sum_cvd += rows[i].q_cvd;
				sum_dth += rows[i].q_dth;
			}
//			trace(path);
//			trace("rows.length = " + rows.length, "t=",t,"sum_cvd=",sum_cvd,"sum_dth=",sum_dth);
			
		}
				
		override public function toString():String {
			var s:String = "";
			for(var i:int = 0; i < rows.length; i++) {
				var r:TimeTableRow = rows[i];
				s += r.t + "," + r.q_cvd + "," + r.q_dth;
			}
			return s;
		}
	}
}