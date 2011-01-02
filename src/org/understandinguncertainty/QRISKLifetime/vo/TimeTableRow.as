package org.understandinguncertainty.QRISKLifetime.vo
{
	public class TimeTableRow
	{
		public var t:Number;
		public var q_dth:Number;
		public var q_cvd:Number;
		
		public function TimeTableRow(t:Number, baseHazard_death:Number, baseHazard_cvd:Number)
		{
			this.t = t;
			q_dth = baseHazard_death;
			q_cvd = baseHazard_cvd;
		}
	}
}