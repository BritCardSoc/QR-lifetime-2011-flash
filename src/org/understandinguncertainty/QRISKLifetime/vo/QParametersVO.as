package org.understandinguncertainty.QRISKLifetime.vo
{
	public class QParametersVO
	{
		public var b_gender:int;
		public var b_AF:int;
		public var b_ra:int;
		public var b_renal:int;
		public var b_treatedhyp:int;
		public var b_type2:int;
		public var bmi:Number;
		public var ethRisk:int;
		public var fh_cvd:int;
		public var rati:Number;
		public var sbp:Number;
		public var smoke_cat:int;
		public var town:Number;
		public var age:int;
		public var noOfFollowUpYears:int;
		
		/**
		 * 
		 * @param b_gender		0..1
		 * @param b_AF			0..1
		 * @param b_ra			0..1
		 * @param b_renal		0..1
		 * @param b_treatedhyp	0..1
		 * @param b_type2		0..1
		 * @param bmi			20..40
		 * @param ethRisk		1..9
		 * @param fh_cvd		0..1
		 * @param rati			1..12
		 * @param sbp			70..210
		 * @param smoke_cat		0..4
		 * @param town			-7..11
		 * @param age			30..84
		 * @param noOfFollowUpYears	<95-age
		 * 
		 */
		public function QParametersVO(
			b_gender:int,
			b_AF:int,
			b_ra:int,
			b_renal:int,
			b_treatedhyp:int,
			b_type2:int,
			bmi:Number,
			ethRisk:int,
			fh_cvd:int,
			rati:Number,
			sbp:Number,
			smoke_cat:int,
			town:Number,
			age:int,
			noOfFollowUpYears:int
			):void
		{
			if(b_gender < 0 || b_gender > 1)
				throw new Error("gender must be 0 (female) or 1 (male)");
			if(b_AF < 0 || b_AF > 1)
				throw new Error("atrial fibrillation must be 0 or 1");
			if(b_ra < 0 || b_ra > 1)
				throw new Error("rheumatoid arthritis must be 0 or 1");
			if(b_renal < 0 || b_renal > 1)
				throw new Error("chronic kidney disease must be 0 or 1");
			if(b_treatedhyp < 0 || b_treatedhyp > 1)
				throw new Error("treated hypertension must be 0 or 1");
			if(b_type2 < 0 || b_type2 > 1)
				throw new Error("type 2 diabetes must be 0 or 1");
			if(bmi < 20 || bmi > 40)
				throw new Error("body mass index must be in range 20 to 40");
			if(ethRisk < 1 || ethRisk > 9)
				throw new Error("ethnic risk category must be in range 1 to 9");
			if(fh_cvd < 0 || fh_cvd > 1)
				throw new Error("family history of CVD must be 0 or 1");
			if(rati < 1 || rati > 12)
				throw new Error("cholesterol ratio must be in range 1 to 12");
			if(sbp < 70 || sbp > 210)
				throw new Error("systolic blood pressure must be in range 70 to 210");
			if(smoke_cat < 0 || smoke_cat > 4)
				throw new Error("smoking category must be in range 0 to 4");
			if(town < -7 || town > 11)
				throw new Error("townsend score must be in range -7 to 11");
			if(age < 30 || age > 84)
				throw new Error("age must be between 30 and 84");
			if(noOfFollowUpYears < 0 || noOfFollowUpYears + age > 95)
				throw new Error("age must be between 0 and (95-age)");
			
			this.b_gender = b_gender;
			this.b_AF = b_AF;
			this.b_ra = b_ra;
			this.b_renal = b_renal;
			this.b_treatedhyp = b_treatedhyp;
			this.b_type2 = b_type2;
			this.bmi = bmi;
			this.ethRisk = ethRisk;
			this.fh_cvd = fh_cvd;
			this.rati = rati;
			this.sbp = sbp;
			this.smoke_cat = smoke_cat;
			this.town = town;
			this.age = age;
			this.noOfFollowUpYears = noOfFollowUpYears;
		}
		
		public function clone():QParametersVO
		{
			return new QParametersVO(
				b_gender,
				b_AF,
				b_ra,
				b_renal,
				b_treatedhyp,
				b_type2,
				bmi,
				ethRisk,
				fh_cvd,
				rati,
				sbp,
				smoke_cat,
				town,
				age,
				noOfFollowUpYears
			);
		}
		
		public function toString():String 
		{
			var s:String = "";
			s += b_gender.toString();
			s += b_AF.toString();
			s += b_ra.toString();
			s += b_renal.toString();
			s += b_treatedhyp.toString();
			s += b_type2.toString() + ",";
			s += bmi.toPrecision(4) + ",";
			s += ethRisk..toString() + ",";
			s += fh_cvd.toString() + ",";
			s += rati.toPrecision(6) + ",";
			s += sbp..toPrecision(6) + ",";
			s += smoke_cat.toString() + ",";
			s += town.toPrecision(6) + ",";
			s += age.toString() + ",";
			s += noOfFollowUpYears.toString();
			return s;		
		}
	}
}