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
#property description "VsV.MT4.VsVFX_SAR - Ver.0.0.2 Update:2017.05.29"
#property strict


//--- SAR_Band : Initial Setup ---//
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_type1 DRAW_ARROW
#property indicator_color1 White


//--- SAR_Band : Indicator Parameters
input double SAR_Step = 0.02;
input double SAR_Max  = 0.2;

//--- SAR_Band : Indicator Buffer
double BufSAR[];

//--- SAR_Band : Up & Down TrendLine Buffer
double BufLow01[];
double BufHigh01[];


//+------------------------------------------------------------------+
//| Custom indicator initialization function (Ver.0.0.1)             |
//+------------------------------------------------------------------+
int OnInit(void)
{
//--- SAR_Band.Initial.Setup ---//
//--- 3 additional buffer used for counting.
  // IndicatorBuffers(1);
  IndicatorBuffers(3);

//*--- SAR line
  SetIndexStyle(0,DRAW_ARROW);
  SetIndexBuffer(0,BufSAR);
  SetIndexLabel(0,"SAR("+DoubleToStr(SAR_Step,2)+","+DoubleToStr(SAR_Max,1)+")");
  SetIndexArrow(0,159);

//*--- Low[i+1] Buffer
  SetIndexBuffer( 1, BufLow01 );
  ArraySetAsSeries( BufLow01, true );
//*--- High[i+1] Buffer
  SetIndexBuffer( 2, BufHigh01 );
  ArraySetAsSeries( BufHigh01, true );


//--- initialization done
   return(INIT_SUCCEEDED);
}
//***//


//+------------------------------------------------------------------+
//| SAR Bands (Ver.0.0.1) -> (Ver.0.0.2)                             |
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

//--- SAR_Band.Calculate.Setup ---//
  int limit=Bars-IndicatorCounted();

  for(int i=limit-1; i>=0; i--)
  {
    BufSAR[i]=iSAR(NULL, 0, SAR_Step, SAR_Max, i);
    BufLow01[i]=low[i];
    BufHigh01[i]=high[i];
  }

//---- OnCalculate done. Return rates_total.
  return(rates_total);
}

//+------------------------------------------------------------------+