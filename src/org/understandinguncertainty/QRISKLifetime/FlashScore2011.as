package org.understandinguncertainty.QRISKLifetime
{
	
	import org.understandinguncertainty.QRISKLifetime.vo.QResultVO;
	import org.understandinguncertainty.QRISKLifetime.vo.TimeTableRow;

	public class FlashScore2011
	{
		public var outputData:String;
		public var errorData:String;
		public var timeTables:Vector.<Vector.<TimeTableRow>>;
				
		public function calculate(
			b_gender:int,			// 0..1
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
		):QResultVO
		{
			outputData = "";
			errorData = "";
			var result:QResultVO = new QResultVO(1,1);
			return result;
		}
		
				
	}
}