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
#property description "VsV.MT4.VsVHL - Ver.0.0.4 Update:2017.02.20"
#property strict


//--- HLBand : Initial Setup ---//
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 White
#property indicator_width1 2
#property indicator_color2 Blue
#property indicator_color3 Red

//--- HLBand : indicator parameters
input int BandPeriod = 20;     // Bands Period
input int PriceField  = 0;      // 0:High/Low 1:Close/Close

//--- HLBand : Indicator buffer
double BufMed[];
double BufHigh[];
double BufLow[];


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(void)
{
//--- HLBand.Initial.Setup ---//
//--- 3 additional buffer used for counting.
  IndicatorBuffers(3);

//*--- Middle line
    SetIndexStyle(0,DRAW_LINE);
    SetIndexBuffer(0,BufMed);
    SetIndexLabel(0,"HL.Med("+string(BandPeriod)+")");
//*--- Hight band
    SetIndexStyle(1,DRAW_LINE);
    SetIndexBuffer(1,BufHigh);
    SetIndexLabel(1,"HL.Hight("+string(BandPeriod)+")");
//*--- Low band
    SetIndexStyle(2,DRAW_LINE);
    SetIndexBuffer(2,BufLow);
    SetIndexLabel(2,"HL.Low("+string(BandPeriod)+")");

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

//--- initialization done
   return(INIT_SUCCEEDED);
}
//***//


//+------------------------------------------------------------------+
//| HL Bands (Ver.0.0.1)                                             |
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
    if(PriceField==0)
    {
      BufHigh[i]=High[iHighest(NULL, 0, MODE_HIGH, BandPeriod, i)];
      BufLow[i] =Low[iLowest(NULL, 0, MODE_LOW, BandPeriod, i)];
    }
    else{
      BufHigh[i]=Close[iHighest(NULL, 0, MODE_CLOSE, BandPeriod, i)];
      BufLow[i] =Close[iLowest(NULL, 0, MODE_CLOSE, BandPeriod, i)];
    }
    BufMed[i]=(BufHigh[i]+BufLow[i])/2;
  }

//---- OnCalculate done. Return new prev_calculated.
    return(rates_total);
}

//+------------------------------------------------------------------+