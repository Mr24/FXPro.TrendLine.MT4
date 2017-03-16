//+------------------------------------------------------------------+
//|                                VerysVeryInc.MetaTrader4.MACD.mq4 |
//|                  Copyright(c) 2016, VerysVery Inc. & Yoshio.Mr24 |
//|                             https://github.com/Mr24/MetaTrader4/ |
//|                                                 Since:2016.09.24 |
//|                                Released under the Apache license |
//|                       https://opensource.org/licenses/Apache-2.0 |
//|                                                            &     |
//+------------------------------------------------------------------+
//|                                                  Custom MACD.mq4 |
//|                   Copyright 2005-2014, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "Copyright(c) 2016 -, VerysVery Inc. && Yoshio.Mr24"
#property link      "https://github.com/VerysVery/MetaTrader4/"
#property description "VsV.MT4.VsVMACD - Ver.0.0.1 Update:2017.03.16"
#property strict


//--- MACD : Initial Setup ---//
#property indicator_separate_window

#property indicator_buffers 2
#property indicator_color1 Silver
#property indicator_width1 2
#property indicator_color2 Red


//--- MACD : indicator parameters
extern int FastEMA   = 12;
extern int SlowEMA   = 26;
extern int SignalSMA = 9;

//--- MACD : Indicator buffer
double BufMACD[];
double BufSignal[];


//+------------------------------------------------------------------+
//| Custom indicator initialization function (Ver.0.0.1)             |
//+------------------------------------------------------------------+
int OnInit(void)
{
//--- MACD.Initial.Setup ---//
//--- 2 additional buffer used for counting.
  IndicatorBuffers(2);
  IndicatorDigits( Digits+1 );
  SetIndexBuffer( 0, BufMACD );
  SetIndexBuffer( 1, BufSignal );

//*--- MACD.Drawing Settings
  SetIndexStyle( 0, DRAW_HISTOGRAM );
  SetIndexStyle( 1, DRAW_LINE, STYLE_DOT );
//*--- MACD.Name for DataWindow & Indicator SubWindow Label
  IndicatorShortName( "MACD(" + IntegerToString(FastEMA) + ","
                              + IntegerToString(SlowEMA) + ","
                              + IntegerToString(SignalSMA) + ")");
  SetIndexLabel( 0, "MACD" );
  SetIndexLabel( 1, "SigSMA" );

//*--- MACD.Check for Input Parameters
  if(FastEMA<=1 || SlowEMA<=1 || SignalSMA<=1 || FastEMA>=SlowEMA)
  {
    Print( "Wrong Input Parameters" );
    return(INIT_FAILED);
  }

//---
  SetIndexDrawBegin(1,SignalSMA);

//--- initialization done
   return(INIT_SUCCEEDED);
}
//***//


//+------------------------------------------------------------------+
//| MACD : Moving Averages Convergence / Divergence (Ver.0.0.1)      |
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

//--- MACD.Calculate.Setup ---//
  int limit=Bars-IndicatorCounted();
  // int limit = Bars - prev_calculated;
  // if(limit == 0) limit = 1;

  for(int i=limit-1; i>=0; i-- )
  {
      BufMACD[i]=iMACD( NULL, 0, FastEMA, SlowEMA, SignalSMA, PRICE_CLOSE, MODE_MAIN, i );
      BufSignal[i]=iMACD( NULL, 0, FastEMA, SlowEMA, SignalSMA, PRICE_CLOSE, MODE_SIGNAL, i );  
  }

//---- OnCalculate done. Return new prev_calculated.
  return(rates_total);
}

//+------------------------------------------------------------------+