//+------------------------------------------------------------------+
//|                           VerysVeryInc.MetaTrader4.TrendLine.mq4 |
//|                  Copyright(c) 2016, VerysVery Inc. & Yoshio.Mr24 |
//|                             https://github.com/Mr24/MetaTrader4/ |
//|                                                 Since:2016.09.24 |
//|                                Released under the Apache license |
//|                       https://opensource.org/licenses/Apache-2.0 |
//|                                                            &     |
//+------------------------------------------------------------------+
//|                                       Ind-WSO+WRO+Trend Line.mq4 |
//|                    Copyright © 2004, http://www.expert-mt4.nm.ru |
//|                                      http://www.expert-mt4.nm.ru |
//| Индикатор был разработан на основе индикатора Widners Oscilator. |
//|          Мною была разработана торговая стратегия, основанная на |
//|        показаниях Ind-WSO+WRO+Trend Line индикатора. Подробности |
//|                          вы можете узнать в форуме на моем сайте |
//|                          http://www.expert-mt4.nm.ru/forum.dhtml |
//+------------------------------------------------------------------+
#property copyright "Copyright(c) 2016 -, VerysVery Inc. && Yoshio.Mr24"
#property link      "https://github.com/VerysVery/MetaTrader4/"
#property description "VsV.MT4.VsVTL - Ver.0.1.0 Update:2017.02.18"
#property strict


//--- Auto_TrendLine : Initial Setup ---//
#property indicator_chart_window


//--- Auto_TrendLine : input parameters
extern int TLPeriod=9;  // TrendLine Period
extern int Limit=350;   // TrendLine Limit


//--- Auto_TrendLine : Widners Osilator
int cnt, TLCurBar=0;


//+------------------------------------------------------------------+
//| Custom indicator initialization function (Ver.0.1.0)             |
//+------------------------------------------------------------------+
int OnInit(void)
{
//--- Auto_TrendLine.Initial.Setup ---//
//--- Output in Char
  for( cnt=0; cnt<=5; cnt++)
  {
    //*--- HLine.Support.Setup
    ObjectCreate( "WSO:" + string(cnt), OBJ_HLINE, 0, 0, 0 );
    ObjectSet( "WSO:" + string(cnt), OBJPROP_COLOR, Red );
    //*--- Trend.Down.Setup
    if(cnt<5)
    {
      ObjectCreate( "Trend.Down:" + string(cnt), OBJ_TREND, 0, 0, 0, 0, 0 );
      ObjectSet( "Trend.Down:" + string(cnt), OBJPROP_COLOR, Red );
    }

    //*--- HLine.Resistant.Setup
    ObjectCreate( "WRO:" + string(cnt), OBJ_HLINE, 0, 0, 0 );
    ObjectSet( "WRO:" + string(cnt), OBJPROP_COLOR, Blue );
    //*--- Trend.Up.Setup
    if(cnt<5)
    {
      ObjectCreate( "Trend.Up:" + string(cnt), OBJ_TREND, 0, 0, 0, 0, 0 );
      ObjectSet( "Trend.Up:" + string(cnt), OBJPROP_COLOR, Blue );
    }

    //--- Default.Trend.Setup
    ObjectSet( "Trend.Down:0", OBJPROP_COLOR, Maroon );
    ObjectSet( "Trend.Up:0", OBJPROP_COLOR, Green );
  }

//--- initialization done
   return(INIT_SUCCEEDED);
}

//***//


//+------------------------------------------------------------------+
//| Custom Deindicator initialization function (Ver.0.1.0)           |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
//--- ToDo & Code Here
  for(cnt=0; cnt<=5; cnt++)
  {
    ObjectDelete( "Trend.Up:" + string(cnt) );
    ObjectDelete( "Trend.Down:" + string(cnt) );
    ObjectDelete( "WSO:" + string(cnt) );
    ObjectDelete( "WRO:" + string(cnt) );
  }
}

//***//


//+------------------------------------------------------------------+
//| Auto_TrendLine (Ver.1.0.0)                                       |
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
//--- Auto_TrendLine.Calculate.Setup ---//
//--- ToDo & Code Here
  //*--- Support Initial
  double  s1=0.00, s2=0.00, s3=0.00, s4=0.00, s5=0.00, s6=0.00;
  int     st1=0, st2=0, st3=0, st4=0, st5=0, st6=0;
  //*--- Resistance Initial
  double  r1=0.00, r2=0.00, r3=0.00, r4=0.00, r5=0.00, r6=0.00;
  int     rt1=0, rt2=0, rt3=0, rt4=0, rt5=0, rt6=0;

//--- Line Support & Resistance
  if(Bars<Limit) Limit = Bars - TLPeriod;

  for( TLCurBar=Limit; TLCurBar>0; TLCurBar--)
  {
    //--- Line Support.Setup
    if(low[TLCurBar+(TLPeriod-1)/2] == low[Lowest(NULL, 0, MODE_LOW,TLPeriod, TLCurBar)])
    {
      s6=s5; s5=s4; s4=s3; s3=s2; s2=s1; s1=low[TLCurBar+(TLPeriod-1)/2];
      st6=st5; st5=st4; st4=st3; st3=st2; st2=st1; st1=TLCurBar+(TLPeriod-1)/2;
    }
    //--- Line Resistance.Setup
    if(high[TLCurBar+(TLPeriod-1)/2] == high[Highest(NULL, 0, MODE_HIGH, TLPeriod, TLCurBar)])
    {
      r6=r5; r5=r4; r4=r3; r3=r2; r2=r1; r1=high[TLCurBar+(TLPeriod-1)/2];
      rt6=rt5; rt5=rt4; rt4=rt3; rt3=rt2; rt2=rt1; rt1=TLCurBar+(TLPeriod-1)/2;
    }
  }

//--- Move Object in Chart
  //*--- WSO & Trend.Down Setup
  ObjectMove( "WSO:0", 0, Time[st1], s1 );
  ObjectMove( "Trend.Down:0", 1, Time[st1], s1 );
  ObjectMove( "Trend.Down:0", 0, Time[st2], s2 );

  ObjectMove( "WSO:1", 0, Time[st2], s2 );
  ObjectMove( "Trend.Down:1", 1, Time[st2], s2 );
  ObjectMove( "Trend.Down:1", 0, Time[st3], s3 );

  ObjectMove( "WSO:2", 0, Time[st3], s3 );
  ObjectMove( "Trend.Down:2", 1, Time[st3], s3 );
  ObjectMove( "Trend.Down:2", 0, Time[st4], s4 );

  ObjectMove( "WSO:3", 0, Time[st4], s4 );
  ObjectMove( "Trend.Down:3", 1, Time[st4], s4 );
  ObjectMove( "Trend.Down:3", 0, Time[st5], s5 );

  ObjectMove( "WSO:4", 0, Time[st5], s5 );
  ObjectMove( "Trend.Down:4", 1, Time[st5], s5 );
  ObjectMove( "Trend.Down:4", 0, Time[st6], s6 );
  ObjectMove( "WSO:5", 0, Time[st6], s6 );

  //*-- WRO & Trend.Up Setup
  ObjectMove( "WRO:0", 0, Time[rt1], r1 );
  ObjectMove( "Trend.Up:0", 1, Time[rt1], r1 );
  ObjectMove( "Trend.Up:0", 0, Time[rt2], r2 );

  ObjectMove( "WRO:1", 0, Time[rt2], r2 );
  ObjectMove( "Trend.Up:1", 1, Time[rt2], r2 );
  ObjectMove( "Trend.Up:1", 0, Time[rt3], r3 );

  ObjectMove( "WRO:2", 0, Time[rt3], r3 );
  ObjectMove( "Trend.Up:2", 1, Time[rt3], r3 );
  ObjectMove( "Trend.Up:2", 0, Time[rt4], r4 );

  ObjectMove( "WRO:3", 0, Time[rt4], r4 );
  ObjectMove( "Trend.Up:3", 1, Time[rt4], r4 );
  ObjectMove( "Trend.Up:3", 0, Time[rt5], r5 );

  ObjectMove( "WRO:4", 0, Time[rt5], r5 );
  ObjectMove( "Trend.Up4", 1, Time[rt5], r5 );
  ObjectMove( "Trend.Up4", 0, Time[rt6], r6 );
  ObjectMove( "WRO:5", 0, Time[rt6], r6 );

//---- OnCalculate done. Return new prev_calculated.
  return(rates_total);
}

//+------------------------------------------------------------------+