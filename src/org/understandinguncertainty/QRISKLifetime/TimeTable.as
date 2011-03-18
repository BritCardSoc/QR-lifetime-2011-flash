package org.understandinguncertainty.QRISKLifetime
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	
	import org.understandinguncertainty.QRISKLifetime.vo.BaseHazard;
	import org.understandinguncertainty.QRISKLifetime.vo.TimeTableRow;

	[Event(name="complete", type="flash.events.Event")]
	public class TimeTable extends EventDispatcher
	{
		public static var rows:Vector.<TimeTableRow>;
		private var exp_a_cvd:Number;
		private var exp_a_death:Number;
		
		public static var paths:Vector.<String> = new Vector.<String>();
		public static var cachedRows:Vector.<Vector.<TimeTableRow>> = new Vector.<Vector.<TimeTableRow>>();
				
		public function load(path:String):void
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
//					rows = new Vector.<TimeTableRow>;
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
		
		public function find_biggest_t_below(number:int):int {
			for (var i:int = 0; i< rows.length; i++) {
				if (rows[i].t >= number) {
					return i-1;
				}
			}
			return -1;
		}
		
		public function getTAt(index:int):Number
		{
			return rows[index].t;
		}
	}
}