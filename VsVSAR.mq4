//+------------------------------------------------------------------+
//|                           VerysVeryInc.MetaTrader4.TrendLine.mq4 |
//|                  Copyright(c) 2016, VerysVery Inc. & Yoshio.Mr24 |
//|                             https://github.com/Mr24/MetaTrader4/ |
//|                                                 Since:2016.09.24 |
//|                                Released under the Apache license |
//|                       https://opensource.org/licenses/Apache-2.0 |
//|                                                            &     |
//+------------------------------------------------------------------+
//|                                                        Bands.mq4 |
//|                   Copyright 2005-2014, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "Copyright(c) 2016 -, VerysVery Inc. && Yoshio.Mr24"
#property link      "https://github.com/VerysVery/MetaTrader4/"
#property description "VsV.MT4.VsSAR - Ver.0.0.1 Update:2017.02.16"
#property strict


//--- SAR_Band : Initial Setup ---//
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_type1 DRAW_ARROW
#property indicator_color1 White
// #property indicator_width1 2

//--- SAR_Band : indicator parameters
input double SAR_Step = 0.02;
input double SAR_Max  = 0.2;


//--- SAR_Band : Indicator buffer
double BufSAR[];


//+------------------------------------------------------------------+
//| Custom indicator initialization function (Ver.0.0.1)             |
//+------------------------------------------------------------------+
int OnInit(void)
{
//--- SAR_Band.Initial.Setup ---//
//--- 1 additional buffer used for counting.
  IndicatorBuffers(1);

//*--- SAR line
   	SetIndexStyle(0,DRAW_ARROW);
   	SetIndexBuffer(0,BufSAR);
   	SetIndexLabel(0,"SAR("+DoubleToStr(SAR_Step,2)+","+DoubleToStr(SAR_Max,1)+")");
    SetIndexArrow(0,159);

/*
//--- check for input parameter
   	if(BandPeriod<=0)
   	{
    	Print("Wrong input parameter Band Period=",BandPeriod);
      	return(INIT_FAILED);
    }
//---
   	SetIndexDrawBegin(0,BandPeriod);
   	SetIndexDrawBegin(1,BandPeriod);
   	SetIndexDrawBegin(2,BandPeriod);
*/

//--- initialization done
   return(INIT_SUCCEEDED);
}
//***//


//+------------------------------------------------------------------+
//| SAR Bands (Ver.0.0.1)                                            |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{

//--- HLBand.Calculate.Setup ---//
  int limit=Bars-IndicatorCounted();

  for(int i=limit-1; i>=0; i--)
  {
    BufSAR[i]=iSAR(NULL, 0, SAR_Step, SAR_Max, i);
  }

//---- OnCalculate done. Return new prev_calculated.
  return(rates_total);
}

//+------------------------------------------------------------------+