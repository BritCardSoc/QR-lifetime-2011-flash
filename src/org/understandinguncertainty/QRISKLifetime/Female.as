package org.understandinguncertainty.QRISKLifetime
{
	public class Female
	{
		public function Female()
		{
		}
				
		private const ethriskCVD:Array = [
			0,
			0,
			0.3519781359171325100000000,
			0.7125701233074622800000000,
			0.4744736904914790800000000,
			0.1277734031153024400000000,
			0.0276815264451465880000000,
			-0.3676643548251001300000000,
			-0.2636321488403285400000000,
			-0.0064333267101571784000000
		];
		
		private const smokeCVD:Array = [
			0,
			0.1609363217948046300000000,
			0.3282477751045009300000000,
			0.4541679502935254700000000,
			0.6076275665698729300000000
		];
		
		public function cvd(
			b_AF:int,
			b_ra:int,
			b_renal:int,
			b_treatedhyp:int,
			b_type2:int,
			bmi:Number,
			ethrisk:int,
			fh_cvd:int,
			rati:Number,
			sbp:Number,
			smoke_cat:int,
			town:Number
		):Number
		{
			/* Applying the fractional polynomial transforms */
			/* (which includes scaling)                      */
			var bmi_1:Number = Math.sqrt(bmi/10);
			
			/* Centring the continuous variables */
			bmi_1 -= 1.605074524879456;
			rati -= 3.705839872360230;
			sbp -= 129.823593139648440;
			town -= -0.301369071006775;
			
			/* Start of Sum */
			var a:Number = 0;
			
			/* The conditional sums */
			a += ethriskCVD[ethrisk];
			a += smokeCVD[smoke_cat];
			
			/* Sum from continuous values */
			a += bmi_1 * 0.2813726290228962300000000;
			a += rati * 0.1551217926855477100000000;
			a += sbp * 0.0062458135965802464000000;
			a += town * 0.0239763590547845720000000;
			
			/* Sum from boolean values */
			a += b_AF * 0.6363540037072725800000000;
			a += b_ra * 0.3607328778130438100000000;
			a += b_renal * 0.5144859684018359100000000;
			a += b_treatedhyp * 0.2825312388249602800000000;
			a += b_type2 * 0.5114309272510256800000000;
			a += fh_cvd * 0.5135507323965317100000000;
			
			/* Sum from interaction terms */
			
			/* Calculate the score itself */
			return a;
		}
		
		private const ethriskDeath:Array = [
			0,
			0,
			-0.7691412217114335100000000,
			-0.4813884489809012200000000,
			-0.6649693187337454300000000,
			-0.9806514018090445300000000,
			-0.7665687475367323200000000,
			-0.3079908452168220200000000,
			-1.1084520766868413000000000,
			-0.9729355194482460800000000
		];
		
		private const smokeDeath:Array = [
			0,
			0.2343310901409800500000000,
			0.5870690502658261200000000,
			0.7964460203072020200000000,
			1.0533145224303277000000000
		];
		
		public function death(
			b_AF:int,
			b_ra:int,
			b_renal:int,
			b_treatedhyp:int,
			b_type2:int,
			bmi:Number,
			ethrisk:int,
			fh_cvd:int,
			rati:Number,
			sbp:Number,
			smoke_cat:int,
			town:Number
		):Number
		{
			
			/* Applying the fractional polynomial transforms */
			/* (which includes scaling)                      */
			var bmi_1:Number = Math.sqrt(bmi/10);
			
			/* Centring the continuous variables */
			
			bmi_1 -= 1.605074524879456;
			rati -= 3.705839872360230;
			sbp -= 129.823593139648440;
			town -= -0.301369071006775;
			
			/* Start of Sum */
			var a:Number = 0;
			
			/* The conditional sums */
			a += ethriskDeath[ethrisk];
			a += smokeDeath[smoke_cat];
			
			/* Sum from continuous values */
			
			a += bmi_1 * -0.1081416642130314200000000;
			a += rati * 0.0273178320909109660000000;
			a += sbp * -0.0008337937584279265700000;
			a += town * 0.0366304184773099120000000;
			
			/* Sum from boolean values */
			a += b_AF * 0.5484061247122409300000000;
			a += b_ra * 0.4667078978482423500000000;
			a += b_renal * 1.0288138959180866000000000;
			a += b_treatedhyp * -0.0500562994738190240000000;
			a += b_type2 * 0.6543819525425483800000000;
			a += fh_cvd * -0.4629154246984292800000000;
			
			/* Sum from interaction terms */
			//trace("female.death = "+a);
			
			/* Calculate the score itself */
			return a;
		}

	}
}