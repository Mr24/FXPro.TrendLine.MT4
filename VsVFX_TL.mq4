//+------------------------------------------------------------------+
//|                        VerysVeryInc.MetaTrader4.FX.TrendLine.mq4 |
//|                  Copyright(c) 2016, VerysVery Inc. & Yoshio.Mr24 |
//|                             https://github.com/Mr24/MetaTrader4/ |
//|                                                 Since:2016.09.24 |
//|                                Released under the Apache license |
//|                       https://opensource.org/licenses/Apache-2.0 |
//|                                                            &     |
//+------------------------------------------------------------------+
//|                                                ExportLevels2.mq4 |
//|                      Copyright © 2006, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|                            https://www.mql5.com/ja/articles/1440 |
//+------------------------------------------------------------------+
//|                                       Ind-WSO+WRO+Trend Line.mq4 |
//|                    Copyright © 2004, http://www.expert-mt4.nm.ru |
//| Индикатор был разработан на основе индикатора Widners Oscilator. |
//|          Мною была разработана торговая стратегия, основанная на |
//|        показаниях Ind-WSO+WRO+Trend Line индикатора. Подробности |
//|                          вы можете узнать в форуме на моем сайте |
//|                          http://www.expert-mt4.nm.ru/forum.dhtml |
//+------------------------------------------------------------------+
#property copyright "Copyright(c) 2016 -, VerysVery Inc. && Yoshio.Mr24"
#property link      "https://github.com/VerysVery/MetaTrader4/"
#property description "VsV.MT4.VsVFX_TL - Ver.0.11.5.0  Update:2017.12.28"
#property strict


//--- FX.Indicator : Setup ---//
//*--- VsVFX_BL.0.11.2.2 : Base.TrendeLine : 1x Base.TrendLine
//*--- (OLD) 1. Base.TrendeLine(BL) : 3 TrendLine

//*--- VsVFX_SAR.0.0.2 & VsVFX_TL.0.11.3.3 : TL.Up&Down.TrendCheck : Up+1.Down-1
//*--- VsVFX_TL.0.11.3.14. TrendLine(TL) : Next.Point = SAR & MACD & Sto & RSI
//*--- VsVFX_TL.0.11.3.26. TrendLine(TL) : TL & Base.TL : TL * HL * SAR & MACD * Sto & RSI
//*--- VsVFX_TL.0.11.3.69. TrendLine(TL) : TL & Base.TL : 3x Base.TL
//*--- (Modify) 2-3. TrendLine(TL) : TL & Base.TL : 3x Base.TL & TL * HL
//*--- (OLD) 2. TrendLIne(TL) : TL Cross * HL TrendLine
//*--- (OLD) 2-1. TrendLine(TL) : TL & Base.TL : 3x Base.TL & TL
//*--- (OLD) 2-2. TrendLine(TL) : TL Cross * HL TrendLine

//*--- 3-1. EntryPoint & ExitPoint : TL Cross * HL TrendLine
//*--- 3-2. EntryPoint & Exitpoint : Tick * HL
//*--- 3-3. EntryPoint & Exitpoint : RSI & Sto & MACD
//*--- 3-4. EntryPoint & ExitPoint : SAR & BB & MA
//*--- (OLD) 3-1. EntryPoint & Exitpoint : RSI & Sto & HL
//*--- (OLD) 3-2. EntryPoint & ExitPoint : SAR & BB & MA

//--- FX.EA.Includes ---//
#include <VsVEA_UJ_Sig.mqh>


//--- FX.Indicator : Initial Setup ---//
#property indicator_chart_window


//--- 1. Base.TrendLine : Indicator Setup ---//
int cnt;
extern int bBTL, BaseTL;

//--- 1. Base.TrendLine : Indicator Buffer ---//
// (0.11.3.0) double BufLow[];
// (0.11.3.0) double BufLowPos[];
// (0.11.3.0) double BufHigh[];
// (0.11.3.0) double BufHighPos[];
/// int st0[];
// (0.11.3.0) double s0[], sTime0[];
// (0.11.3.0) double r0[], rTime0[];

//--- 2-1. TrendLine : TL.Up&Down.TrendCheck
// (0.11.3.32) extern int SupportTime, ResistanceTime;
extern double sTime0, sPrice0;
extern double rTime0, rPrice0;

double sTime00, sPrice00;
double rTime00, rPrice00;

double rTime01[], rPrice01[], rTime02[], rPrice02[];
double sTime01[], sPrice01[], sTime02[], sPrice02[];

extern double vSAR, vSAR01;
extern double vLow, vLow01;
extern double vHigh, vHigh01;
extern double tLots;    // TrendCheckLots

//--- 2-2. TrendLine : Next.Point
//--- MACD & MACD.Center ---//
extern double vMACD, vMACD01, vMACD02;
extern double vMACDSig, vMACDSig01, vMACDSig02;
extern double mdCheck;    // MACD & Signal.Up&Down.Check
extern double mdCheckC00; // MACD & Signal & C-0.Up&Down.Check
//--- Stochastic & Sto.Center ---//
extern double vSto, vSto01;
extern double vStoSig, vStoSig01;
extern double stoCheck;   // Sto & Signal.Up.Down.Check
// extern double stoCheckC00; // Sto & Singnal & C-50.Up&Down.Check
extern double stoCheckC50;  // Sto & Singnal & C-50.Up&Down.Check
extern double stoPos;   // Sto & Signal & C-50.CurrentPosition
//--- RSI & RSI.Center ---//
extern double vRSI, vRSI01;
extern double rsiCheck;   // RSI Up.Down.Check
extern double rsiCheckC50;  // RSI & C-50.Up&Down.Check
extern double rsiPos;   // RSI & C-50 & 30.70.Over & 40.60.Range.CurrentPosition

//--- 2-3. TrendLine(TL) : TL & Base.TL : 3x Base.TL & TL * HL
//--- Trend Buffer ---//
// (0.11.3.27) double BufTLUp[];
// (0.11.3.27) double BufTLDown[];
//--- Entry & Exit ---//
extern int nxCheck;
// (0.11.3.27) extern int EnCheck, ExCheck;
// (0.11.3.26) double BufEnTime[], BufEnPrice[];
// double BufHigh01[],BufLow01[];
// double BufHighPos01[], BufHighPos02[];
// (0.11.3.27) double BufExTime01[], BufExPrice01[];
// (0.11.3.27) double BufExTime02[], BufExPrice02[];

// extern double nxUpTime, nxUpPrice;
// extern double nxDwTime, nxDwPrice;
// (0.11.3.27) 
extern double EnUpTime01, EnUpPrice01, EnUpTime02, EnUpPrice02;
// (0.11.3.27) 
extern double ExUpTime01, ExUpPrice01, ExUpTime02, ExUpPrice02;
// (0.11.3.27) 
extern double EnDwTime01, EnDwPrice01, EnDwTime02, EnDwPrice02;
// (0.11.3.27) 
extern double ExDwTime01, ExDwPrice01, ExDwTime02, ExDwPrice02;

//--- HL ---//
extern double HLMid, HLMid01;

//--- Base.TL x 3 ---//
extern double High01, HighPos01;
extern double Low01, LowPos01;
extern double High02, HighPos02;
extern double Low02, LowPos02;
extern double High03, HighPos03;
extern double Low03, LowPos03;

extern double SxPos01, RxPos01;

extern double xPos01, xPos02;
extern int rPos01, sPos01;
extern int rPos02, sPos02;
extern int rPos03, sPos03;

extern bool EnUpStory, EnDwStory;
extern bool ExUpStory, ExDwStory;

extern int rs0, rr0;  // rates_total(sTime0, rTime0)
extern int rs1, rr1;  // rates_total(sTime01, rTime01)
extern int rs2, rr2;  // rates_total(sTime02, rTime02)


//+------------------------------------------------------------------+
//| Custom indicator initialization function (Ver.0.11.3.1)          |
//+------------------------------------------------------------------+
int OnInit(void)
{
//--- 2-3. TrendLine(TL) : TL & Base.TL : 3x Base.TL & TL * HL
  //--- 8 addtional Buffer used for Conting.
  IndicatorBuffers( 8 );

  //*--- Trend.Up Buffer
  // (0.11.3.26) SetIndexBuffer( 0, BufTLUp );
  // (0.11.3.26) ArraySetAsSeries( BufTLUp, true );
  //*-- Trend.Down Buffer
  // (0.11.3.26) SetIndexBuffer( 1, BufTLDown );
  // (0.11.3.26) ArraySetAsSeries( BufTLDown, true );

  //*--- Entry Time Buffer
  // (0.11.3.26) SetIndexBuffer( 2, BufEnTime );
  // (0.11.3.26) ArraySetAsSeries( BufEnTime, true );
  //*--- Entry Price Buffer
  // (0.11.3.26) SetIndexBuffer( 3, BufEnPrice );
  // (0.11.3.26) ArraySetAsSeries( BufEnPrice, true );

  //*--- High Buffer
  // SetIndexBuffer( 0, BufHigh01 );
  // ArraySetAsSeries( BufHigh01, true );
  // SetIndexBuffer( 1, BufHighPos01 );
  // ArraySetAsSeries( BufHighPos01, true );

  SetIndexBuffer( 0, rTime01 );
  ArraySetAsSeries( rTime01, true );
  SetIndexBuffer( 1, rPrice01 );
  ArraySetAsSeries( rPrice01, true );

  SetIndexBuffer( 2, sTime01 );
  ArraySetAsSeries( sTime01, true );
  SetIndexBuffer( 3, sPrice01 );
  ArraySetAsSeries( sPrice01, true );

  SetIndexBuffer( 4, rTime02 );
  ArraySetAsSeries( rTime02, true );
  SetIndexBuffer( 5, rPrice02 );
  ArraySetAsSeries( rPrice02, true );

  SetIndexBuffer( 6, sTime02 );
  ArraySetAsSeries( sTime02, true );
  SetIndexBuffer( 7, sPrice02 );
  ArraySetAsSeries( sPrice02, true );

  //*--- Exit Time Buffer
  // (Test:0.11.3.27) SetIndexBuffer( 1, BufExTime01 );
  // (Test:0.11.3.27) ArraySetAsSeries( BufExTime01, true );
  // (Test:0.11.3.27) SetIndexBuffer( 2, BufExTime02 );
  // (Test:0.11.3.27) ArraySetAsSeries( BufExTime02, true );


  // (0.11.3.26) SetIndexBuffer( 4, BufExTime );
  // (0.11.3.26) ArraySetAsSeries( BufExTime, true );
  //*--- Exit Price Buffer
  // (0.11.3.26) SetIndexBuffer( 5, BufExPrice );
  // (0.11.3.26) ArraySetAsSeries( BufExPrice, true );


//--- 1. Base.TrendLine.Initial.Setup ---//
  //--- 2 Additional Buffer used for Conting.
  /* (0.11.3.0)
  IndicatorBuffers( 8 );

  //*--- Lowest Buffer
  SetIndexBuffer( 0, BufLow );
  ArraySetAsSeries( BufLow, true );
  //*--- Lowest Position Buffer
  SetIndexBuffer( 1, BufLowPos );
  ArraySetAsSeries( BufLowPos, true );

  //*--- Highest Buffer
  SetIndexBuffer( 2, BufHigh );
  ArraySetAsSeries( BufHigh, true );
  //*--- Highest Position Buffer
  SetIndexBuffer( 3, BufHighPos );
  ArraySetAsSeries( BufHighPos, true );

  //*--- Support.Data ---//
  // SetIndexBuffer( 4, st0 );
  // ArraySetAsSeries( st0, true );
  SetIndexBuffer( 4, s0 );
  ArraySetAsSeries( s0, true );
  SetIndexBuffer( 5, sTime0 );
  ArraySetAsSeries( sTime0, true );

  //*--- Resistance.Data ---//
  SetIndexBuffer( 6, r0 );
  ArraySetAsSeries( r0, true );
  SetIndexBuffer( 7, rTime0 );
  ArraySetAsSeries( rTime0, true );
  */

  //--- Output in Char
  for( cnt=0; cnt<=2; cnt++ )
  {
    //*--- 1. Base.TrendLine : Support.Setup
    ObjectCreate( "BaseSup:" + string(cnt), OBJ_HLINE, 0, 0, 0 );
    ObjectSet( "BaseSup:" + string(cnt), OBJPROP_COLOR, Goldenrod );
    ObjectSet( "BaseSup:0", OBJPROP_COLOR, White );

    //*--- 2-3. TrendLine(TL) : Trend.Up.Setup
    if(cnt<2)
    {
      ObjectCreate( "Trend.Up:" + string(cnt), OBJ_TREND, 0, 0, 0, 0, 0 );
      ObjectSet( "Trend.Up:" + string(cnt), OBJPROP_COLOR, Blue );
      ObjectSet( "Trend.Up:" + string(cnt), OBJPROP_STYLE, STYLE_DOT );

      ObjectCreate( "EnPos:" + string(cnt), OBJ_ARROW_BUY, 0, 0, 0 );
      ObjectSet( "EnPos:" + string(cnt), OBJPROP_COLOR, Blue );
      ObjectSet( "EnPos:" + string(cnt), OBJPROP_WIDTH, 2 );

      // (Ver.0.11.3.21)
      // ObjectCreate( "EnPos:" + string(cnt), OBJ_ARROW_CHECK, 0, 0, 0 );
      // ObjectSet( "EnPos:" + string(cnt), OBJPROP_COLOR, Goldenrod );
    }


    //*--- 1. Base.TrendLine : Resistance.Setup
    ObjectCreate( "BaseRes:" + string(cnt), OBJ_HLINE, 0, 0, 0 );
    ObjectSet( "BaseRes:" + string(cnt), OBJPROP_COLOR, Goldenrod ); 
    ObjectSet( "BaseRes:" + string(cnt), OBJPROP_STYLE, STYLE_DOT );
    ObjectSet( "BaseRes:0", OBJPROP_COLOR, White ); 
    // bjectSet( "BaseRes:0", OBJPROP_STYLE, STYLE_DOT );  

    //*--- 2-3. TrendLine(TL) : Trend.Down.Setup
    if(cnt<2)
    {
      ObjectCreate( "Trend.Down:" + string(cnt), OBJ_TREND, 0, 0, 0, 0, 0 );
      ObjectSet( "Trend.Down:" + string(cnt), OBJPROP_COLOR, Red );
      ObjectSet( "Trend.Down:" + string(cnt), OBJPROP_STYLE, STYLE_DOT );

      ObjectCreate( "ExPos:" + string(cnt), OBJ_ARROW_SELL, 0, 0, 0 );
      ObjectSet( "ExPos:" + string(cnt), OBJPROP_COLOR, Red );
      ObjectSet( "ExPos:" + string(cnt), OBJPROP_WIDTH, 2 );

      // (Ver.0.11.3.21)
      // ObjectCreate( "ExPos:" + string(cnt), OBJ_ARROW_STOP, 0, 0, 0 );
    }

    //--- Default.Trend.Setup
    //*--- 2-3. TrendLine(TL) : New.TrendLine
    ObjectSet( "Trend.Up:0", OBJPROP_COLOR, Blue );
    ObjectSet( "Trend.Up:0", OBJPROP_STYLE, STYLE_SOLID );
    ObjectSet( "Trend.Down:0", OBJPROP_COLOR, Red );
    ObjectSet( "Trend.Down:0", OBJPROP_STYLE, STYLE_SOLID );
  }


//--- initialization done
  return(INIT_SUCCEEDED);

}

//***//


//+------------------------------------------------------------------+
//| Custom Deindicator initialization function (Ver.0.11.0)          |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
//--- 1. Base.TrendLine : ToDo & Code Here
  for( cnt=0; cnt<=2; cnt++ ){
    ObjectDelete( "BaseSup:" + string(cnt) );
    ObjectDelete( "BaseRes:" + string(cnt) );

    //*--- 2-3. TrendLine(TL) : TL & Base.TL : 3x Base.TL & TL * HL
    ObjectDelete( "Trend.Up:" + string(cnt) );
    ObjectDelete( "Trend.Down:" + string(cnt) );
  }

}

//***//

//+------------------------------------------------------------------+
//| FX.TrendLine.Entry Signal for Open Order (Ver.0.11.3.30)         |
//+------------------------------------------------------------------+
void Entry_Sig00( // const double tLot,
              // const double HLMid_01,
              // const double mdCheck_00,
              // const double mdCheck_C00,
              int Base_TL,
              const int RA,
              const double srTime
              )
{
  switch( Base_TL )
  {
    // case 1: // (UpTL) B.Sup:0, UpTL=0, DwTL=0, nxCheck=0
    case 98: // (UpTL) B.Sup:0, UpTL=0, DwTL=0, nxCheck=0
      // if( tLot==1 && Ask>=HLMid_01 && mdCheck_00==1 && mdCheck_C00==1 )
      if( EnUpStory )
      {
        EnUpTime01 = (int)TimeCurrent();
        EnUpPrice01 = Ask;

        nxCheck = 91;
        // BaseTL = 91;
        bBTL = 98;

        rs0 = RA - (int)srTime;
      }
    break;

    // case -1:  // (DwTL) B.Res:0, UpTL=0, DwTL=0, nxCheck=0
    case 99:  // (DwTL) B.Res:0, UpTL=0, DwTL=0, nxCheck=0
      // if( tLot==-1 && Bid<=HLMid_01 && mdCheck_00==-1 && mdCheck_C00==-1 )
      if( EnDwStory )
      {
        EnDwTime01 = (int)TimeCurrent();
        EnDwPrice01 = Bid;

        nxCheck = 93;
        // BaseTL = 93;
        bBTL = 99;

        rr0 = RA - (int)srTime;
      }
    break;
  }
}


//+------------------------------------------------------------------+
//| FX.TrendLine.Entry Signal for Open Order (Ver.0.11.3.30)         |
//+------------------------------------------------------------------+
void Entry_Sig( // const double tLot,
              // const double HLMid_01,
              // const double mdCheck_00,
              // const double mdCheck_C00,
              int Base_TL,
              )
{
  switch( Base_TL )
  {
    case 92:  // (DwTL) B.Res:1, UpTL=1, DwTL=0, nxCheck=92
      // if( tLot==-1 && Bid<=HLMid_01 && mdCheck_00==-1 && mdCheck_C00==-1 )
      if( EnDwStory )
      {
        EnDwTime01 = (int)TimeCurrent();
        EnDwPrice01 = Bid;

        nxCheck = 23;
        // BaseTL = 93;
        // bBTL = 99;
      }
    break;

    case 94: // (UpTL) B.Sup:0, UpTL=0, DwTL=0, nxCheck=0
      // if( tLot==1 && Ask>=HLMid_01 && mdCheck_00==1 && mdCheck_C00==1 )
      if( EnUpStory )
      {
        EnUpTime01 = (int)TimeCurrent();
        EnUpPrice01 = Ask;

        nxCheck = 11;
        // BaseTL = 91;
        // bBTL = 98;
      }
    break;

    case 30: // (UpTL) B.Sup:1, UpTL=1, DwTL=1, nxCheck=24
      // if( tLot==1 && Ask>=HLMid_01 && mdCheck_00==1 && mdCheck_C00==1 )
      if( EnUpStory )
      {
        EnUpTime02 = (int)TimeCurrent();
        EnUpPrice02 = Ask;

        /* (0.11.3.58.OK)
        EnUpTime02 = EnUpTime01;    EnUpTime01 = (int)TimeCurrent();
        EnUpPrice02 = EnUpPrice01;  EnUpPrice01 = Ask;
        ExUpTime01 = 0;
        ExUpPrice01 = 0;
        */

        nxCheck = 31;
        // BaseTL = 91;
        // bBTL = 98;
      }
    break;

    case 40:  // (DwTL) B.Res:1, UpTL=1, DwTL=1, nxCheck=12
      // if( tLot==-1 && Bid<=HLMid_01 && mdCheck_00==-1 && mdCheck_C00==-1 )
      if( EnDwStory )
      {
        EnDwTime02 = (int)TimeCurrent();
        EnDwPrice02 = Bid;

        /* (0.11.3.59.OK)
        EnDwTime02 = EnDwTime01;    EnDwTime01 = (int)TimeCurrent();
        EnDwPrice02 = EnDwPrice01;  EnDwPrice01 = Bid;
        ExDwTime01 = 0;
        ExDwPrice01 = 0;
        */

        nxCheck = 43;
        // BaseTL = 93;
        // bBTL = 99;
      }
    break;

    case 50: // (UpTL) B.Sup:2, UpTL=2, DwTL=2, nxCheck=44
      // if( tLot==1 && Ask>=HLMid_01 && mdCheck_00==1 && mdCheck_C00==1 )
      if( EnUpStory )
      {
        if( EnUpPrice02 == 0 )
        {
          EnUpTime02 = (int)TimeCurrent();
          EnUpPrice02 = Ask;
        }
        else if( EnUpPrice02 > 0 )
        {
          EnUpTime01 = EnUpTime02;
          EnUpPrice01 = EnUpPrice02;

          EnUpTime02 = (int)TimeCurrent();
          EnUpPrice02 = Ask;
        }
        // (0.11.3.64.OK) EnUpTime02 = (int)TimeCurrent();
        // (0.11.3.64.OK) EnUpPrice02 = Ask;

        nxCheck = 51;
        // BaseTL = 91;
        // bBTL = 98;
      }
    break;

    case 60:  // (DwTL) B.Res:2, UpTL=2, DwTL=1, nxCheck=32
      // if( tLot==-1 && Bid<=HLMid_01 && mdCheck_00==-1 && mdCheck_C00==-1 )
      if( EnDwStory )
      {
        if( EnDwPrice02 == 0)
        {
          EnDwTime02 = (int)TimeCurrent();
          EnDwPrice02 = Bid;
        }
        else if( EnDwPrice02 > 0)
        {
          EnDwTime01 = EnDwTime02;
          EnDwPrice01 = EnDwPrice02;

          EnDwTime02 = (int)TimeCurrent();
          EnDwPrice02 = Bid;
        }

        // (0.11.3.63.OK) EnDwTime02 = (int)TimeCurrent();
        // (0.11.3.63.OK) EnDwPrice02 = Bid;

        nxCheck = 63;
        // BaseTL = 93;
        // bBTL = 99;
      }
    break;
  }
}


//+------------------------------------------------------------------+
//| FX.TrendLine.Exit Signal for Open Order (Ver.0.11.3.30)          |
//+------------------------------------------------------------------+
void Exit_Sig( // const double tLot,
              // const double HLMid_01,
              // const double sto_Pos,
              // const double rsi_Pos,
              int nx_Check,
              const double srTime)
{
  switch( nx_Check )
  {
    case 91: // (UpTL) B.Sup:0, UpTL=1, DwTL=0, nxCheck=1
      // if( tLot == -1 && Bid <= HLMid_01 && sto_Pos < 0 && rsi_Pos == -50 )
      if( ExUpStory )
      {
        ExUpTime01 = (int)TimeCurrent();
        ExUpPrice01 = Bid;

        nxCheck = 92;
        // BaseTL = 92;
        SxPos01 = srTime;
      }
    break;

    case 93: // (DwTL) B.Res:0, UpTL=0, DwTL=1, nxCheck=3
      // if( tLot == 1 && Ask >= HLMid_01 && sto_Pos > 0 && rsi_Pos == 50 )
      if( ExDwStory )
      {
        ExDwTime01 = (int)TimeCurrent();
        ExDwPrice01 = Ask;

        nxCheck = 94;
        // BaseTL = 94;
        RxPos01 = srTime;
      }
    break;

    case 11: // (UpTL) B.Sup:0, UpTL=1, DwTL=1, nxCheck=92
      // if( tLot == -1 && Bid <= HLMid_01 && sto_Pos < 0 && rsi_Pos == -50 )
      if( ExUpStory )
      {
        ExUpTime01 = (int)TimeCurrent();
        ExUpPrice01 = Bid;

        nxCheck = 12;
        // BaseTL = 92;
        SxPos01 = srTime;
      }
    break;

    case 23: // (DwTL) B.Res:0, UpTL=1, DwTL=1, nxCheck=92
      // if( tLot == 1 && Ask >= HLMid_01 && sto_Pos > 0 && rsi_Pos == 50 )
      if( ExDwStory )
      {
        ExDwTime01 = (int)TimeCurrent();
        ExDwPrice01 = Ask;

        nxCheck = 24;
        // BaseTL = 94;
        RxPos01 = srTime;
      }
    break;

    case 31: // (UpTL) B.Sup:1, UpTL=2, DwTL=1, nxCheck=30
      // if( tLot == -1 && Bid <= HLMid_01 && sto_Pos < 0 && rsi_Pos == -50 )
      if( ExUpStory )
      {
        ExUpTime02 = (int)TimeCurrent();
        ExUpPrice02 = Bid;

        /* (0.11.3.58.OK)
        ExUpTime02 = ExUpTime01;    ExUpTime01 = (int)TimeCurrent();
        ExUpPrice02 = ExUpPrice01;  ExUpPrice01 = Bid;
        */

        nxCheck = 32;
        // BaseTL = 92;
        SxPos01 = srTime;
      }
    break;

    case 43: // (DwTL) B.Res:1, UpTL=1, DwTL=2, nxCheck=40
      // if( tLot == -1 && Bid <= HLMid_01 && sto_Pos < 0 && rsi_Pos == -50 )
      if( ExDwStory )
      {
        ExDwTime02 = (int)TimeCurrent();
        ExDwPrice02 = Ask;

        /* (0.11.3.59.OK)
        ExDwTime02 = ExDwTime01;    ExDwTime01 = (int)TimeCurrent();
        ExDwPrice02 = ExDwPrice01;  ExDwPrice01 = Ask;
        */

        nxCheck = 44;
        // BaseTL = 92;
        RxPos01 = srTime;
      }
    break;

    case 51: // (UpTL) B.Sup:2, UpTL=2, DwTL=1, nxCheck=50
      // if( tLot == -1 && Bid <= HLMid_01 && sto_Pos < 0 && rsi_Pos == -50 )
      if( ExUpStory )
      {
        if( ExUpPrice02 == 0 )
        {
          ExUpTime02 = (int)TimeCurrent();
          ExUpPrice02 = Bid;
        }
        else if( ExUpPrice02 > 0 )
        {
          ExUpTime01 = ExUpTime02;
          ExUpPrice01 = ExUpPrice02;

          ExUpTime02 = (int)TimeCurrent();
          ExUpPrice02 = Bid;
        }

        // (0.11.3.64.OK) ExUpTime02 = (int)TimeCurrent();
        // (0.11.3.64.OK) ExUpPrice02 = Bid;

        /* (0.11.3.58.OK)
        ExUpTime02 = ExUpTime01;    ExUpTime01 = (int)TimeCurrent();
        ExUpPrice02 = ExUpPrice01;  ExUpPrice01 = Bid;
        */

        nxCheck = 52;
        // BaseTL = 92;
        SxPos01 = srTime;
      }
    break;

    case 63: // (DwTL) B.Res:2, UpTL=2, DwTL=2, nxCheck=60
      // if( tLot == -1 && Bid <= HLMid_01 && sto_Pos < 0 && rsi_Pos == -50 )
      if( ExDwStory )
      {
        if( ExDwPrice02 == 0 )
        {
          ExDwTime02 = (int)TimeCurrent();
          ExDwPrice02 = Ask;
        }
        else if( ExDwPrice02 > 0 )
        {
          ExDwTime01 = ExDwTime02;
          ExDwPrice01 = ExDwPrice02;

          ExDwTime02 = (int)TimeCurrent();
          ExDwPrice02 = Ask;
        }

        /* (0.11.3.63.OK)
        ExDwTime02 = (int)TimeCurrent();
        ExDwPrice02 = Ask;
        */

        /* (0.11.3.59.OK)
        ExDwTime02 = ExDwTime01;    ExDwTime01 = (int)TimeCurrent();
        ExDwPrice02 = ExDwPrice01;  ExDwPrice01 = Ask;
        */

        nxCheck = 64;
        // BaseTL = 92;
        RxPos01 = srTime;
      }
    break;
  }
}


//+------------------------------------------------------------------+
//| FX.TrendLine.Base.TrendLine:01 & 02 Setup (Ver.0.11.3.32)        |
//+------------------------------------------------------------------+
void Base_TrendLine(const int nx_Check,
                    const double SRxPos,
                    const double srTime,
                    const int RA,
                    const double &high[],
                    const double &low[]
                    )
{
  switch( nx_Check )
  {
    case 92:  // rTime01.Setup
      // xPos01 = srTime - SRxPos;
      // xPos02 = xPos01; xPos01 = srTime - SRxPos;
      xPos01 = srTime - SRxPos;

      HighPos01 = ArrayMaximum( high, ((int)srTime-(int)xPos01)/2, (int)xPos01 );
      rPos01 = (int)HighPos01;
      High01 = high[rPos01];

      rTime01[0] = HighPos01;
      rPrice01[0] = High01;

      rr1 = RA - rPos01;

      // nxCheck = 20;
    break;

    case 94:  // sTime01.Setup
      // xPos01 = srTime - SRxPos;
      // xPos02 = xPos01; xPos01 = srTime - SRxPos;
      xPos01 = srTime - SRxPos;

      LowPos01 = ArrayMinimum( low, ((int)srTime-(int)xPos01)/2, (int)xPos01 );
      sPos01 = (int)LowPos01;
      Low01 = low[sPos01];

      sTime01[0] = LowPos01;
      sPrice01[0] = Low01;

      rs1 = RA - sPos01;

      // nxCheck = 10;
    break;

    case 32:  // rTime02.Setup
      // xPos01 = srTime - SRxPos;
      // xPos02 = xPos01; xPos01 = srTime - SRxPos;
      xPos01 = srTime - SRxPos;

      HighPos02 = ArrayMaximum( high, ((int)srTime-(int)xPos01)/2, (int)xPos01 );
      rPos02 = (int)HighPos02;
      High02 = high[rPos02];

      rTime02[0] = HighPos02;
      rPrice02[0] = High02;

      rr2 = RA - rPos02;

      // nxCheck = 20;
    break;

    case 44:  // sTime02.Setup
      // xPos01 = srTime - SRxPos;
      // xPos02 = xPos01; xPos01 = srTime - SRxPos;
      xPos01 = srTime - SRxPos;

      LowPos02 = ArrayMinimum( low, ((int)srTime-(int)xPos01)/2, (int)xPos01 );
      sPos02 = (int)LowPos02;
      Low02 = low[sPos02];

      sTime02[0] = LowPos02;
      sPrice02[0] = Low02;

      rs2 = RA - sPos02;

      // nxCheck = 10;
    break;

    case 52:  // rTime02.Setup
      // xPos01 = srTime - SRxPos;
      // xPos02 = xPos01; xPos01 = srTime - SRxPos;
      xPos01 = srTime - SRxPos;

      if( rPrice02[0] == 0 )
      {
        HighPos02 = ArrayMaximum( high, ((int)srTime-(int)xPos01)/2, (int)xPos01 );
        rPos02 = (int)HighPos02;
        High02 = high[rPos02];

        rTime02[0] = HighPos02;
        rPrice02[0] = High02;

        rr2 = RA - rPos02;
      }
      else if( rPrice02[0] > 0 )
      {
        HighPos03 = ArrayMaximum( high, ((int)srTime-(int)xPos01), (int)xPos01 );
        // (0.11.3.67.OK) HighPos03 = ArrayMaximum( high, ((int)srTime-(int)xPos01)/2, (int)xPos01 );
        rPos03 = (int)HighPos03;
        High03 = high[rPos03];

        if( HighPos03 != rTime02[0] )
        {
          rTime01[0] = rTime02[0];
          rPrice01[0] = rPrice02[0];

          rr1 = rr2;
          High01 = High02;

          rTime02[0] = HighPos03;
          rPrice02[0] = High03;

          rr2 = RA - rPos03;
          High02 = High03;
        }
        else if( HighPos03 == rTime02[0] )
        {
          /*
          rTime01[0] = rTime02[0];
          rPrice01[0] = rPrice02[0];
          */

          rTime02[0] = HighPos03;
          rPrice02[0] = High03;

          rr2 = RA - rPos03;
          High02 = High03;
        }
      }

      /* (0.11.3.64.OK)
      HighPos02 = ArrayMaximum( high, ((int)srTime-(int)xPos01)/2, (int)xPos01 );
      rPos02 = (int)HighPos02;
      High02 = high[rPos02];

      rTime02[0] = HighPos02;
      rPrice02[0] = High02;

      rr2 = RA - rPos02;
      */

      // nxCheck = 20;
    break;

    case 64:  // sTime02.Setup
      // xPos01 = srTime - SRxPos;
      // xPos02 = xPos01; xPos01 = srTime - SRxPos;
      xPos01 = srTime - SRxPos;

      if( sPrice02[0] == 0 )
      {
        LowPos02 = ArrayMinimum( low, ((int)srTime-(int)xPos01)/2, (int)xPos01 );
        sPos02 = (int)LowPos02;
        Low02 = low[sPos02];

        sTime02[0] = LowPos02;
        sPrice02[0] = Low02;

        rs2 = RA - sPos02;
      }
      else if( sPrice02[0] > 0)
      {
        LowPos03 = ArrayMinimum( low, ((int)srTime-(int)xPos01), (int)xPos01 );
        // (0.11.3.67.OK) LowPos03 = ArrayMinimum( low, ((int)srTime-(int)xPos01)/2, (int)xPos01 );
        sPos03 = (int)LowPos03;
        Low03 = low[sPos03];

        if( LowPos03 != sTime02[0] )
        {
          sTime01[0] = sTime02[0];
          sPrice01[0] = sPrice02[0];

          rs1 = rs2;
          Low01 = Low02;

          sTime02[0] = LowPos03;
          sPrice02[0] = Low03;

          rs2 = RA - sPos03;
          Low02 = Low03;
        }
        else if( LowPos03 == sTime02[0] )
        {
          sTime02[0] = LowPos03;
          sPrice02[0] = Low03;

          rs2 = RA - sPos03;
          Low02 = Low03;
        }
      }

      /* (0.11.3.63.OK)
      LowPos02 = ArrayMinimum( low, ((int)srTime-(int)xPos01)/2, (int)xPos01 );
      sPos02 = (int)LowPos02;
      Low02 = low[sPos02];

      sTime02[0] = LowPos02;
      sPrice02[0] = Low02;

      rs2 = RA - sPos02;
      */

      // nxCheck = 10;
    break;
  }
}


//+------------------------------------------------------------------+
//| FX.TrendLine (Ver.0.11.3.10) vSAR + vMACD + vSto + vRSI          |
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
//--- 1. Base.TrendLine : Caluculate.Setup ---//
  //---* ToDo & Code Here
  //---* Support.Initial
  /// int     st0=0,    st1=0,    st2=0, sPos;
  // (0.11.3.0) int st0=0, sPos;
  /// double  s0=0.00,  s1=0.00,  s2=0.00;
  /// double  sTime0;

  //---* Resistance.Initial
  /// int     rt0=0,    rt1=0,    rt2=0, rPos;
  // (0.11.3.0) int rt0=0, rPos;
  /// double  r0=0.00,  r1=0.00,  r2=0.00;
  ///  double  rTime0;
  // int rt01=0, rPos01;

  // (0.11.3.15) -> (0.11.3.27)
  ArraySetAsSeries( low, true );
  // (0.11.3.15) -> (0.11.3.27)
  ArraySetAsSeries( high, true );

  //---* Support & Resistance : Calculate ---//
  /* (0.11.3.0)
  for( int i=MaxLimit-1; i>=0; i-- )
  {
    //---* Support Calculate ---//
    BufLowPos[i] = ArrayMinimum( low, (MaxLimit-1)/2, i );
    sPos = (int)BufLowPos[i];
    BufLow[i]=low[sPos];

    //---* Resistance Calculate ---//
    BufHighPos[i] = ArrayMaximum( high, (MaxLimit-1)/2, i );
    rPos = (int)BufHighPos[i];
    BufHigh[i]=high[rPos];
  }
  */

  //---* Support & Resistance : Data
  VsVFX_BL_Sig( sTime0, sPrice0, rTime0, rPrice0 );

  //---* Support & Resistance : Moved Draw
  //---* Support.Minimum Moved Draw
  ObjectMove( "BaseSup:0", 0, time[(int)sTime0], sPrice0 );

  Print( "B.Sup:0=" + TimeToStr( time[(int)sTime0], TIME_DATE ) + "." 
      + TimeToStr( time[(int)sTime0], TIME_MINUTES ) 
      + "/" + DoubleToStr( sPrice0, Digits )
      // + "/" + string(sTime0) 
      + "/" + DoubleToStr( sTime0, 0 )
  );

  //---* Resistance.Maximum Moved Draw
  ObjectMove( "BaseRes:0", 0, time[(int)rTime0], rPrice0 );

  Print( "B.Res:0=" + TimeToStr( time[(int)rTime0], TIME_DATE ) + "." 
      + TimeToStr( time[(int)rTime0], TIME_MINUTES ) 
      + "/" + DoubleToStr( rPrice0, Digits ) 
      // + "/" + string(rTime0) 
      + "/" + DoubleToStr( rTime0, 0 )
  );

//--- 2. TrendLine : Caluculate.Setup ---//
  //---* 2-1. Trend Check : iSAR & iMACD & iSto & iRSI
  // for( int i=MaxLimit-1; i>=0; i-- )
  int limit=Bars-IndicatorCounted();
  // tLots = 0.0;
  mdCheckC00  = 0.0;
  // stoCheckC00 = 0.0;
  stoCheckC50 = 0.0;
  rsiCheckC50 = 0.0;

  for( int i=limit-1; i>=0; i-- )
  {
  //*--- 2-1. TrendLine : TL.Up&Down.TrendCheck
  vSAR    = iCustom( NULL, 0, "VsVFX_SAR", 0, i );
  vSAR01  = iCustom( NULL, 0, "VsVFX_SAR", 0, i+1 );

  vLow01  = iCustom( NULL, 0, "VsVFX_SAR", 1, i+1 );
  vHigh01 = iCustom( NULL, 0, "VsVFX_SAR", 2, i+1 );

  //*--- 2-2. TrendLine : Next.Point
  //*--- MACD ---//
  vMACD   = iCustom( NULL, 0, "VsVMACD", 0, i );
  vMACD01 = iCustom( NULL, 0, "VsVMACD", 0, i+1 );
  vMACD02 = iCustom( NULL, 0, "VsVMACD", 0, i+2 );

  vMACDSig  = iCustom( NULL, 0, "VsVMACD", 1, i );  
  vMACDSig01  = iCustom( NULL, 0, "VsVMACD", 1, i+1 );
  vMACDSig02  = iCustom( NULL, 0, "VsVMACD", 1, i+2 );

  //*--- Stochastic ---//
  vSto  = iCustom( NULL, 0, "VsVSto", 0, i );
  vSto01  = iCustom( NULL, 0, "VsVSto", 0, i+1 );

  vStoSig   = iCustom( NULL, 0, "VsVSto", 1, i );
  vStoSig01 = iCustom( NULL, 0, "VsVSto", 1, i+1 );

  //*--- RSI ---//
  vRSI  = iCustom( NULL, 0, "VsVFX_RSI", 0, 0 );
  vRSI01  = iCustom( NULL, 0, "VsVFX_RSI", 0, 1 );

  }

  //*--- 2-1. TrendLine : SAR.Up&Down.TrendCheck
  tLots = VsVFX_SAR_Sig( vSAR, vSAR01, vLow01, vHigh01 );

  //*--- 2-2. TrendLine : Next.Point
  //*--- MACD ---//
  VsVFX_MACD_Sig( mdCheck, mdCheckC00,
                  vMACD, vMACD01, vMACD02,
                  vMACDSig, vMACDSig01, vMACDSig02);

  Print( "MD=" + DoubleToStr( vMACD, 4 ) 
      + "/MD.Sig=" + DoubleToStr( vMACDSig, 4 )
      + "/MD.01=" + DoubleToStr( vMACD01, 4 ) 
      + "/MD.Sig01=" + DoubleToStr( vMACDSig01, 4 )
      + "/MD.02=" + DoubleToStr( vMACD02, 4 ) 
      + "/MD.Sig02=" + DoubleToStr( vMACDSig02, 4 )
  );

  //*--- Stochastic ---//
  VsVFX_Sto_Sig(stoCheck, stoCheckC50, stoPos,
    vSto, vSto01, vStoSig, vStoSig01);

  //--- Stochastic.Trend.Up ---//
  Print( "Sto.01=" + DoubleToStr( vSto01, 4 )
      + "/Sto=" + DoubleToStr( vSto, 4 )
      + "/Sto.Sig=" + DoubleToStr( vStoSig, 4 )
  );

  //*--- RSI ---//
  VsVFX_RSI_Sig(rsiCheck, rsiCheckC50, rsiPos, vRSI, vRSI01);

  //*--- SAR & MACD & Sto & RSI ---//
  Print( "tLots=" + DoubleToStr( tLots, 0 )
      + "/MACD.C=" + DoubleToStr( mdCheck, 0 )
      + "/MACD.CC=" + DoubleToStr( mdCheckC00, 0 )
  );
  Print( "Sto.C=" + DoubleToStr( stoCheck, 0 )
      + "/Sto.CC=" + DoubleToStr( stoCheckC50, 0 )
      + "/Sto.Pos=" + DoubleToStr( stoPos, 0 )
  );
  Print( "RSI.C=" + DoubleToStr( rsiCheck, 0 )
      + "/RSI.CC=" + DoubleToStr( rsiCheckC50, 0 )
      + "/RSI.Pos=" + DoubleToStr( rsiPos, 0 )
  );

  //*--- 2-3. TrendLine(TL) : TL & Base.TL : 3x Base.TL & TL * HL
  //*--- Base.TrendLine ---//
  // const double rTime00 = rTime0;
  // const double sTime00 = sTime0;

  if( nxCheck > 0 )
  {
    BaseTL = 0;
    // sTime00 = sTime00 + (rates_total - RA0);
    // sTime00 += (rates_total - RA0);
    sTime00 = rates_total - rs0;
    rTime00 = rates_total - rr0;

    sTime01[0] = rates_total - rs1;
    // (NG) ps1 = ArrayMinimum( Low01, rates_total-rs1, 0 );
    // (NG) sPrice01[0] = low[ps1];
    sPrice01[0] = Low01;

    sTime02[0] = rates_total - rs2;
    sPrice02[0] = Low02;

    rTime01[0] = rates_total - rr1;
    rPrice01[0] = High01;

    rTime02[0] = rates_total - rr2;
    rPrice02[0] = High02;

  }
  // else if ( rTime00 > sTime00 ) BaseTL = 98;
  // else if( sTime00 > rTime00 ) BaseTL = 99;
  else if ( rTime0 > sTime0 )
  {
    BaseTL = 98;
    sTime00 = sTime0;
    sPrice00 = sPrice0;
  }
  else if ( sTime0 > rTime0 )
  {
    BaseTL = 99;
    rTime00 = rTime0;
    rPrice00 = rPrice0;
  }
  // (0.11.3.47.OK) if( nxCheck > 0 ) BaseTL = 0;
  // (0.11.3.47.OK) else if ( rTime0 > sTime0 ) BaseTL = 1;
  // (0.11.3.47.OK) else if ( sTime0 > rTime0 ) BaseTL = -1;
  // if( rTime0 > sTime0 ) BaseTL = 1;
  // if( sTime0 > rTime0 ) BaseTL = -1;

  //*--- HL.Mid Data ---//
  HLMid = iCustom( NULL, 0, "VsVHL", 0, 0 );
  HLMid01 = iCustom( NULL, 0, "VsVHL", 0, 1 );

  //*--- Base.TL.Setup ---//
  //--- Entry & Exit Story Setup ---//
  EnUpStory=false; EnDwStory=false; ExUpStory=false; ExDwStory=false;

  //--- Entry.Story ---//
  // int EnStory = USDJPY_EntrySignal(Bars,20171228);
  // Print( "FXTL_Bars=" + IntegerToString(Bars) ); // 1001
  int EnStory = USDJPY_EntrySignal(20171228);
  if(EnStory>0) EnUpStory=true;
  if(EnStory<0) EnDwStory=true;

  //--- Exit.Story ---//
  int ExStory = USDJPY_ExitSignal(20171228);
  if(ExStory>0) ExUpStory=true;
  if(ExStory<0) ExDwStory=true;

  /* (Ver.0.11.4.1)
  if( tLots==-1 && Bid<= HLMid01 && stoPos<0 && rsiPos==-50 )
    ExUpStory=true;
  //--- Exit.Down.Story ---//
  if( tLots==1 && Ask>= HLMid01 && stoPos>0 && rsiPos==50 )
    ExDwStory=true;
  */

  //--- Entry & Exit : UpTL & DwTL Signal : Setup ---//
  switch( BaseTL )
  {
    //*--- UpTL=0, DwTL=0, nxCheck=0, B.Sup:0 ---//
    // case 1:
    case 98:
      //*--- Up.Entry Algorithm ---//
      // Entry_Sig( tLots, HLMid01, mdCheck, mdCheckC00, 1 );
      // Entry_Sig( 1 );
      // Entry_Sig( 98 );
      Entry_Sig00( 98, rates_total, sTime0 );
      
      Print( "bTL." + string(BaseTL)
          + "/bB." + string(bBTL)
          + "/TL." + string(nxCheck)
          // + "/ET=" + TimeToStr( (int)EnUpTime01, TIME_SECONDS )
          + "/E1=" + TimeToStr( (int)EnUpTime01, TIME_SECONDS )
          + "/" + DoubleToStr( EnUpPrice01, Digits )
          // + "/sT=" + DoubleToStr( sTime00, 0 )
          + "/sT=" + TimeToStr( time[(int)sTime00], TIME_MINUTES )
          + "/" + DoubleToStr( sPrice00, Digits )
      );
    break;

    //*--- UpTL=0, DwTL=0, nxCheck=0, B.Res:0 ---//
    // case -1:
    case 99:
      //*--- Dw.Entry Algorithm ---//
      // Entry_Sig( -1 );
      // Entry_Sig( 99 );
      Entry_Sig00( 99, rates_total, rTime0 );

      //---* BaseTL=-1 & B.Res:0 : Print Out ---//
      Print( "bTL." + string(BaseTL)
          + "/bB." + string(bBTL)
          + "/TL." + string(nxCheck)
          // + "/ET=" + TimeToStr( (int)EnDwTime01, TIME_SECONDS )
          + "/E1=" + TimeToStr( (int)EnDwTime01, TIME_SECONDS )
          + "/" + DoubleToStr( EnDwPrice01, Digits )
          + "/rT=" + TimeToStr( time[(int)rTime00], TIME_MINUTES )
          + "/" + DoubleToStr( rPrice00, Digits )
      );
    break;

    //*--- UpTL!=0, DwTL!=0, nxCheck!=0, !B:0 ---//
    case 0:
      switch( nxCheck )
      {
        case 10:
          //--- B.Res:0 -> B.Sup:1 Setup ---//
          // (0.11.3.52.OK) Base_TrendLine(94, RxPos01, rTime0, high, low);
          //---* Base.Sup:1 Setup ---//
          ObjectMove( "BaseSup:1", 0, time[(int)sTime01[0]], sPrice01[0] );

          //---* nxCheck=10 & B.Res:0 : Print Out ---//
          Print( "bTL=" + string(BaseTL)
              + "/bBTL=" + string(bBTL)
              + "/TL=" + string(nxCheck)
              + "/ET01=" + TimeToStr( (int)EnDwTime01, TIME_SECONDS )
              + "/EP01=" + DoubleToStr( EnDwPrice01, Digits )
              + "/XT01=" + TimeToStr( (int)ExDwTime01, TIME_SECONDS )
              + "/XP01=" + DoubleToStr( ExDwPrice01, Digits )
              // + "/srT=" + DoubleToStr( RxPos01, 0 )
              + "/BS01=" + TimeToStr( time[(int)sTime01[0]], TIME_MINUTES )
              + "/" + DoubleToStr( sPrice01[0], Digits )
              + "/xPos01=" + DoubleToStr( xPos01, 0 )
          );
        break;

        case 11:
          //*--- Up.Entry Arrow: 1 & 0 ---//
          ObjectMove( "EnPos:0", 0, (int)EnUpTime01, EnUpPrice01 );
          ObjectMove( "EnPos:1", 0, (int)EnDwTime01, EnDwPrice01 );

          //--- B.Res:0 -> B.Sup:1 Setup ---//
          // (0.11.3.52.OK) Base_TrendLine(94, RxPos01, rTime0, high, low);

          //*--- Trend.Up:0 ---//
          //--- sTime01 ---//
          ObjectMove( "Trend.Up:0", 0, time[(int)sTime01[0]], sPrice01[0] );
          ObjectMove( "Trend.Up:0", 1, (int)EnUpTime01, EnUpPrice01 );

          //---* Up.Exit Algorithm ---//
          // Exit_Sig( 11, sTime0 );
          Exit_Sig( 11, sTime01[0] );

          //---* nxCheck=11 & B.Sup:1 & B.Res:0 : Print Out ---//
          //---* nxCheck=94 & B.Res:0 : Print Out ---//
          Print( "bTL=" + string(BaseTL)
              + "/bB=" + string(bBTL)
              + "/TL=" + string(nxCheck)
              + "/E1=" + TimeToStr( (int)EnUpTime01, TIME_SECONDS )
              + "/" + DoubleToStr( EnUpPrice01, Digits )
              // + "/XT01=" + TimeToStr( (int)ExDwTime01, TIME_SECONDS )
              // + "/XP01=" + DoubleToStr( ExDwPrice01, Digits )
              + "/E2=" + TimeToStr( (int)EnDwTime01, TIME_SECONDS )
              + "/" + DoubleToStr( EnDwPrice01, Digits )
              + "/X2=" + TimeToStr( (int)ExDwTime01, TIME_SECONDS )
              + "/" + DoubleToStr( ExDwPrice01, Digits )
              + "/BS1=" + TimeToStr( time[(int)sTime01[0]], TIME_MINUTES )
              + "/" + DoubleToStr( sPrice01[0], Digits )
              + "/xP1=" + DoubleToStr( xPos01, 0 )
              // + "/rTime00=" + DoubleToStr( rTime00, 0 )
              + "/rT=" + TimeToStr( time[(int)rTime00], TIME_MINUTES)
              + "/" + DoubleToStr( rPrice00, Digits )
              + "/xP1." + DoubleToStr( xPos01, 0 )
          );
        break;

        case 12:
          //*--- Up.Exit Arrow:0 & Dw.Exit Arrow:1 ---//
          ObjectMove( "ExPos:0", 0, (int)ExUpTime01, ExUpPrice01 );
          ObjectMove( "ExPos:1", 0, (int)ExDwTime01, ExDwPrice01 );

          //--- B.Res:0 -> B.Sup:1 Setup ---//
          // (0.11.3.52.OK) Base_TrendLine(94, RxPos01, rTime0, high, low);
          //--- B.Sup:1 -> B.Res:1 Setup ---//
          Base_TrendLine(92, SxPos01, sTime01[0], rates_total, high, low);

          //---* Base.Res:1 Setup ---//
          ObjectMove( "BaseRes:1", 0, time[(int)rTime01[0]], rPrice01[0] );

          //---* Dw.Entry Algorithm ---//
          Entry_Sig( 40 );

          //---* nxCheck=12 & B.Sup:1 & B.Res:0 : Print Out ---//
          Print( // "bTL=" + string(BaseTL)
              //   "bTL" // + string(BaseTL)
              ""
              + "bB." + string(bBTL)
              + "/TL." + string(nxCheck)
              + "/E1." + TimeToStr( (int)EnUpTime01, TIME_SECONDS )
              + "/" + DoubleToStr( EnUpPrice01, Digits )
              + "/X1." + TimeToStr( (int)ExUpTime01, TIME_SECONDS )
              + "/" + DoubleToStr( ExUpPrice01, Digits )
              + "/E2." + TimeToStr( (int)EnDwTime01, TIME_SECONDS )
              + "/" + DoubleToStr( EnDwPrice01, Digits )
              + "/X2." + TimeToStr( (int)ExDwTime01, TIME_SECONDS )
              + "/" + DoubleToStr( ExDwPrice01, Digits )
              + "/BS1." + TimeToStr( time[(int)sTime01[0]], TIME_MINUTES )
              + "/" + DoubleToStr( sPrice01[0], Digits )
              + "/BR1." + TimeToStr( time[(int)rTime01[0]], TIME_MINUTES )
              + "/" + DoubleToStr( rPrice01[0], Digits )
              // + "/rT=" + TimeToStr( time[(int)rTime00], TIME_MINUTES)
              // + "/" + DoubleToStr( rPrice00, Digits )
              // + "/xP2." + DoubleToStr( xPos02, 0 )
              + "/xP1." + DoubleToStr( xPos01, 0 ) 
          );
        break;

        case 20:
          //--- B.Sup:0 -> B.Res:1 Setup ---//
          // (0.11.3.52.OK) Base_TrendLine(92, SxPos01, sTime0, high, low);
          //---* Base.Res:1 Setup ---//
          ObjectMove( "BaseRes:1", 0, time[(int)rTime01[0]], rPrice01[0] );

          //---* nxCheck=20 & B.Sup:0 : Print Out ---//
          Print( "bTL=" + string(BaseTL)
              + "/bBTL=" + string(bBTL)
              + "/TL=" + string(nxCheck)
              + "/ET01=" + TimeToStr( (int)EnUpTime01, TIME_SECONDS )
              + "/EP01=" + DoubleToStr( EnUpPrice01, Digits )
              + "/XT01=" + TimeToStr( (int)ExUpTime01, TIME_SECONDS )
              + "/XP01=" + DoubleToStr( ExUpPrice01, Digits )
              + "/BR01=" + TimeToStr( time[(int)rTime01[0]], TIME_MINUTES )
              + "/" + DoubleToStr( rPrice01[0], Digits )
              + "/xPos01=" + DoubleToStr( xPos01, 0 )
          );
        break;

        case 23:
          //*--- Dw.Entry Arrow:0 & Up.Entry Arrow:1 ---//
          ObjectMove( "EnPos:0", 0, (int)EnDwTime01, EnDwPrice01 );
          ObjectMove( "EnPos:1", 0, (int)EnUpTime01, EnUpPrice01 );

          //--- B.Sup:0 -> B.Res:1 Setup ---//
          // (0.11.3.52.OK) Base_TrendLine(92, SxPos01, sTime0, high, low);
          // Base_TrendLine(92, SxPos01, sTime0, rates_total, high, low);

          //*--- Trend.Down:0 ---//
          //--- rTime01 ---//
          ObjectMove( "Trend.Down:0", 0, time[(int)rTime01[0]], rPrice01[0] );
          ObjectMove( "Trend.Down:0", 1, (int)EnDwTime01, EnDwPrice01 );

          //---* Dw.Exit Algorithm ---//
          // Exit_Sig( 23, rTime0 );
          Exit_Sig( 23, rTime01[0] );

          //---* nxCheck=23 & B.Res:1 & B.Sup:0 : Print Out ---//
          Print( "bTL=" + string(BaseTL)
              + "/bB=" + string(bBTL)
              + "/TL=" + string(nxCheck)
              + "/E1=" + TimeToStr( (int)EnDwTime01, TIME_SECONDS )
              + "/" + DoubleToStr( EnDwPrice01, Digits )
              + "/E2=" + TimeToStr( (int)EnUpTime01, TIME_SECONDS )
              + "/" + DoubleToStr( EnUpPrice01, Digits )
              + "/X2=" + TimeToStr( (int)ExUpTime01, TIME_SECONDS )
              + "/" + DoubleToStr( ExUpPrice01, Digits )
              + "/BR1=" + TimeToStr( time[(int)rTime01[0]], TIME_MINUTES )
              + "/" + DoubleToStr( rPrice01[0], Digits )
              // + "/st=" + TimeToStr( (int)sTime00, TIME_SECONDS )
              // + "/" + DoubleToStr( sPrice00, Digits )
              + "/sT=" + TimeToStr( time[(int)sTime00], TIME_MINUTES)
              + "/" + DoubleToStr( sPrice00, Digits )
              + "/xP1." + DoubleToStr( xPos01, 0 )
          );
        break;

        case 24:
          //*--- Dw.Exit Arrow:0 & Up.Exit Arrow:1 ---//
          ObjectMove( "ExPos:0", 0, (int)ExDwTime01, ExDwPrice01 );
          ObjectMove( "ExPos:1", 0, (int)ExUpTime01, ExUpPrice01 );

          //--- B.Sup:0 -> B.Res:1 Setup ---//
          // (0.11.3.52.OK) Base_TrendLine(92, SxPos01, sTime0, high, low);
          //--- B.Res:1 -> B.Sup:1 Setup ---//
          // Base_TrendLine(94, RxPos01, rTime01[0], high, low);
          Base_TrendLine(94, RxPos01, rTime01[0], rates_total, high, low);

          //---* Base.Sup:1 Setup ---//
          ObjectMove( "BaseSup:1", 0, time[(int)sTime01[0]], sPrice01[0] );

          //---* Up.Entry Algorithm ---//
          Entry_Sig( 30 );

          //---* nxCheck=24 & B.Res:1 & B.Sup:0 : Print Out ---//
          Print( // "bTL=" + string(BaseTL)
              // "bTL" // + string(BaseTL)
              ""
              // + "/bB." + string(bBTL)
              + "bB." + string(bBTL)
              + "/TL." + string(nxCheck)
              + "/E1." + TimeToStr( (int)EnDwTime01, TIME_SECONDS )
              + "/" + DoubleToStr( EnDwPrice01, Digits )
              + "/X1." + TimeToStr( (int)ExDwTime01, TIME_SECONDS )
              + "/" + DoubleToStr( ExDwPrice01, Digits )
              + "/E2." + TimeToStr( (int)EnUpTime01, TIME_SECONDS )
              + "/" + DoubleToStr( EnUpPrice01, Digits )
              + "/X2." + TimeToStr( (int)ExUpTime01, TIME_SECONDS )
              + "/" + DoubleToStr( ExUpPrice01, Digits )
              + "/BR1." + TimeToStr( time[(int)rTime01[0]], TIME_MINUTES )
              + "/" + DoubleToStr( rPrice01[0], Digits )
              // + "/st=" + TimeToStr( (int)sTime00, TIME_SECONDS )
              // + "/" + DoubleToStr( sPrice00, Digits )
              + "/BS1." + TimeToStr( time[(int)sTime01[0]], TIME_MINUTES )
              + "/" + DoubleToStr( sPrice01[0], Digits )
              // + "/sT." + TimeToStr( time[(int)sTime00], TIME_MINUTES)
              // + "/" + DoubleToStr( sPrice00, Digits )
              // + "/xPos1=" + DoubleToStr( xPos01, 0 )
              // + "/xP2." + DoubleToStr( xPos02, 0 )
              + "/xP1." + DoubleToStr( xPos01, 0 )
          );
        break;

        case 31:
          //*--- Up.Entry Arrow: 0 & 1 ---//
          ObjectMove( "EnPos:0", 0, (int)EnUpTime02, EnUpPrice02 );
          ObjectMove( "EnPos:1", 0, (int)EnDwTime01, EnDwPrice01 );
          // (0.11.3.58.OK) ObjectMove( "EnPos:0", 0, (int)EnUpTime01, EnUpPrice01 );

          //*--- Trend.Up: 0 & 1 ---//
          //--- sTime01 ---//
          ObjectMove( "Trend.Up:0", 0, time[(int)sTime01[0]], sPrice01[0] );
          ObjectMove( "Trend.Up:0", 1, (int)EnUpTime02, EnUpPrice02 );
          // (0.11.3.58.OK) ObjectMove( "Trend.Up:0", 1, (int)EnUpTime01, EnUpPrice01 );
          //--- sTime00 ---//
          ObjectMove( "Trend.Up:1", 0, time[(int)sTime00], sPrice00 );
          ObjectMove( "Trend.Up:1", 1, (int)EnUpTime01, EnUpPrice01 );
          // (0.11.3.58.OK) ObjectMove( "Trend.Up:1", 1, (int)EnUpTime02, EnUpPrice02 );

          //---* Up.Exit Algorithm ---//
          Exit_Sig( 31, sTime01[0] );

          //---* nxCheck=31 & B.Sup:1 & B.Res:1 : Print Out ---//
          Print( // "bTL=" + string(BaseTL)
              //   "bTL" // + string(BaseTL)
              ""
              // + "bB." + string(bBTL)
              + string(bBTL)
              + "/"
              // + "/TL." + string(nxCheck)
              + string(nxCheck)
              + "/E1." + TimeToStr( (int)EnUpTime02, TIME_SECONDS )
              + "/" + DoubleToStr( EnUpPrice02, Digits )
              + "/X1." + TimeToStr( (int)ExUpTime02, TIME_SECONDS )
              + "/" + DoubleToStr( ExUpPrice02, Digits )
              + "/E2." + TimeToStr( (int)EnDwTime01, TIME_SECONDS )
              + "/" + DoubleToStr( EnDwPrice01, Digits )
              + "/X2." + TimeToStr( (int)ExDwTime01, TIME_SECONDS )
              + "/" + DoubleToStr( ExDwPrice01, Digits )
              + "/BS1." + TimeToStr( time[(int)sTime01[0]], TIME_MINUTES )
              + "/" + DoubleToStr( sPrice01[0], Digits )
              + "/BR1." + TimeToStr( time[(int)rTime01[0]], TIME_MINUTES )
              + "/" + DoubleToStr( rPrice01[0], Digits )
              // + "/sT=" + TimeToStr( time[(int)sTime00], TIME_MINUTES)
              // + "/" + DoubleToStr( sPrice00, Digits )
              // + "/xP2." + DoubleToStr( xPos02, 0 )
              + "/xP1." + DoubleToStr( xPos01, 0 ) 
          );
        break;

        case 32:
          //*--- Up.Exit Arrow:0 & Dw.Exit Arrow:1 ---//
          ObjectMove( "ExPos:0", 0, (int)ExUpTime02, ExUpPrice02 );
          ObjectMove( "ExPos:1", 0, (int)ExDwTime01, ExDwPrice01 );
          // (0.11.3.58.OK) ObjectMove( "ExPos:0", 0, (int)ExUpTime01, ExUpPrice01 );

          //--- B.Sup:1 -> B.Res:2 Setup ---//
          Base_TrendLine(32, SxPos01, sTime01[0], rates_total, high, low);

          //---* Base.Res:1 & 2 Setup ---//
          ObjectMove( "BaseRes:1", 0, time[(int)rTime02[0]], rPrice02[0] );
          ObjectMove( "BaseRes:2", 0, time[(int)rTime01[0]], rPrice01[0] );

          //---* Dw.Entry Algorithm ---//
          Entry_Sig( 60 );

          //---* nxCheck=32 & B.Sup:1 & B.Res:2 : Print Out ---//
          Print( // "bTL=" + string(BaseTL)
              //   "bTL" // + string(BaseTL)
              ""
              // + "bB." + string(bBTL)
              + string(bBTL)
              +"/"
              // + "/TL." + string(nxCheck)
              + string(nxCheck)
              + "/E1." + TimeToStr( (int)EnUpTime02, TIME_SECONDS )
              + "/" + DoubleToStr( EnUpPrice02, Digits )
              + "/X1." + TimeToStr( (int)ExUpTime02, TIME_SECONDS )
              + "/" + DoubleToStr( ExUpPrice02, Digits )
              + "/E2." + TimeToStr( (int)EnDwTime01, TIME_SECONDS )
              + "/" + DoubleToStr( EnDwPrice01, Digits )
              + "/X2." + TimeToStr( (int)ExDwTime01, TIME_SECONDS )
              + "/" + DoubleToStr( ExDwPrice01, Digits )
              + "/BR2." + TimeToStr( time[(int)rTime02[0]], TIME_MINUTES )
              + "/" + DoubleToStr( rPrice02[0], Digits )
              + "/BS1." + TimeToStr( time[(int)sTime01[0]], TIME_MINUTES )
              + "/" + DoubleToStr( sPrice01[0], Digits )
              + "/BR1." + TimeToStr( time[(int)rTime01[0]], TIME_MINUTES )
              + "/" + DoubleToStr( rPrice01[0], Digits )
              // + "/sT=" + TimeToStr( time[(int)sTime00], TIME_MINUTES)
              // + "/" + DoubleToStr( sPrice00, Digits )
              // + "/xP2." + DoubleToStr( xPos02, 0 )
              + "/xP1." + DoubleToStr( xPos01, 0 ) 
          );
        break;

        case 43:
          //*--- Dw.Entry Arrow: 1 & 0 ---//
          ObjectMove( "EnPos:0", 0, (int)EnDwTime02, EnDwPrice02 );
          ObjectMove( "EnPos:1", 0, (int)EnUpTime01, EnUpPrice01 );
          // (0.11.3.59.OK) ObjectMove( "EnPos:0", 0, (int)EnDwTime01, EnDwPrice01 );

          //*--- Trend.Dw: 0 & 1 ---//
          //--- rTime01 ---//
          ObjectMove( "Trend.Down:0", 0, time[(int)rTime01[0]], rPrice01[0] );
          ObjectMove( "Trend.Down:0", 1, (int)EnDwTime02, EnDwPrice02 );
          // (0.11.3.59.OK) ObjectMove( "Trend.Down:0", 1, (int)EnDwTime01, EnDwPrice01 );
          //--- rTime00 ---//
          ObjectMove( "Trend.Down:1", 0, time[(int)rTime00], rPrice00 );
          ObjectMove( "Trend.Down:1", 1, (int)EnDwTime01, EnDwPrice01 );
          // (0.11.3.59.OK) ObjectMove( "Trend.Down:1", 1, (int)EnDwTime02, EnDwPrice02 );

          //---* Dw.Exit Algorithm ---//
          Exit_Sig( 43, rTime01[0] );

          //---* nxCheck=43 & B.Res:1 & B.Sup:1 : Print Out ---//
          Print( // "bTL=" + string(BaseTL)
              //   "bTL" // + string(BaseTL)
              ""
              // + "bB." + string(bBTL)
              + string(bBTL)
              + "/"
              // + "/TL." + string(nxCheck)
              + string(nxCheck)
              + "/E1." + TimeToStr( (int)EnDwTime02, TIME_SECONDS )
              + "/" + DoubleToStr( EnDwPrice02, Digits )
              + "/X1." + TimeToStr( (int)ExDwTime02, TIME_SECONDS )
              + "/" + DoubleToStr( ExDwPrice02, Digits )
              + "/E2." + TimeToStr( (int)EnUpTime01, TIME_SECONDS )
              + "/" + DoubleToStr( EnUpPrice01, Digits )
              + "/X2." + TimeToStr( (int)ExUpTime01, TIME_SECONDS )
              + "/" + DoubleToStr( ExUpPrice01, Digits )
              + "/BR1." + TimeToStr( time[(int)rTime01[0]], TIME_MINUTES )
              + "/" + DoubleToStr( rPrice01[0], Digits )
              + "/BS1." + TimeToStr( time[(int)sTime01[0]], TIME_MINUTES )
              + "/" + DoubleToStr( sPrice01[0], Digits ) 
              // + "/sT=" + TimeToStr( time[(int)sTime00], TIME_MINUTES)
              // + "/" + DoubleToStr( sPrice00, Digits )
              // + "/xP2." + DoubleToStr( xPos02, 0 )
              + "/xP1." + DoubleToStr( xPos01, 0 ) 
          );
        break;

        case 44:
          //*--- Dw.Exit Arrow:0 & Up.Exit Arrow:1 ---//
          ObjectMove( "ExPos:0", 0, (int)ExDwTime02, ExDwPrice02 );
          ObjectMove( "ExPos:1", 0, (int)ExUpTime01, ExUpPrice01 );
          // (0.11.3.59.OK) ObjectMove( "ExPos:0", 0, (int)ExDwTime01, ExDwPrice01 );

          //--- B.Res:1 -> B.Sup:2 Setup ---//
          Base_TrendLine(44, RxPos01, rTime01[0], rates_total, high, low);

          //---* Base.Sup:1 & 2 Setup ---//
          ObjectMove( "BaseSup:1", 0, time[(int)sTime02[0]], sPrice02[0] );
          ObjectMove( "BaseSup:2", 0, time[(int)sTime01[0]], sPrice01[0] );

          //---* Up.Entry Algorithm ---//
          Entry_Sig( 50 );

          //---* nxCheck=44 & B.Sup:2 & B.Res:1 : Print Out ---//
          Print( // "bTL=" + string(BaseTL)
              //   "bTL" // + string(BaseTL)
              ""
              // + "bB." + string(bBTL)
              + string(bBTL)
              +"/"
              // + "/TL." + string(nxCheck)
              + string(nxCheck)
              + "/E1." + TimeToStr( (int)EnDwTime02, TIME_SECONDS )
              + "/" + DoubleToStr( EnDwPrice02, Digits )
              + "/X1." + TimeToStr( (int)ExDwTime02, TIME_SECONDS )
              + "/" + DoubleToStr( ExDwPrice02, Digits )
              + "/E2." + TimeToStr( (int)EnUpTime01, TIME_SECONDS )
              + "/" + DoubleToStr( EnUpPrice01, Digits )
              + "/X2." + TimeToStr( (int)ExUpTime01, TIME_SECONDS )
              + "/" + DoubleToStr( ExUpPrice01, Digits )
              + "/BS2." + TimeToStr( time[(int)sTime02[0]], TIME_MINUTES )
              + "/" + DoubleToStr( sPrice02[0], Digits ) 
              + "/BR1." + TimeToStr( time[(int)rTime01[0]], TIME_MINUTES )
              + "/" + DoubleToStr( rPrice01[0], Digits )
              + "/BS1." + TimeToStr( time[(int)sTime01[0]], TIME_MINUTES )
              + "/" + DoubleToStr( sPrice01[0], Digits ) 
              // + "/sT=" + TimeToStr( time[(int)sTime00], TIME_MINUTES)
              // + "/" + DoubleToStr( sPrice00, Digits )
              // + "/xP2." + DoubleToStr( xPos02, 0 )
              + "/xP1." + DoubleToStr( xPos01, 0 ) 
          );
        break;

        case 51:
          //*--- Up.Entry Arrow: 0 & 1 ---//
          ObjectMove( "EnPos:0", 0, (int)EnUpTime02, EnUpPrice02 );
          ObjectMove( "EnPos:1", 0, (int)EnDwTime02, EnDwPrice02 );

          //*--- Trend.Up: 0 & 1 ---//
          //--- sTime02 ---//
          ObjectMove( "Trend.Up:0", 0, time[(int)sTime02[0]], sPrice02[0] );
          ObjectMove( "Trend.Up:0", 1, (int)EnUpTime02, EnUpPrice02 );
          //--- sTime01 ---//
          ObjectMove( "Trend.Up:1", 0, time[(int)sTime01[0]], sPrice01[0] );
          ObjectMove( "Trend.Up:1", 1, (int)EnUpTime01, EnUpPrice01 );

          //---* Up.Exit Algorithm ---//
          Exit_Sig( 51, sTime02[0] );

          //---* nxCheck=51 & B.Sup:2 & B.Res:1 : Print Out ---//
          Print( // "bTL=" + string(BaseTL)
              //   "bTL" // + string(BaseTL)
              ""
              // + "bB." + string(bBTL)
              + string(bBTL)
              + "/"
              // + "/TL." + string(nxCheck)
              + string(nxCheck)
              + "/E1." + TimeToStr( (int)EnUpTime02, TIME_SECONDS )
              + "/" + DoubleToStr( EnUpPrice02, Digits )
              + "/X1." + TimeToStr( (int)ExUpTime02, TIME_SECONDS )
              + "/" + DoubleToStr( ExUpPrice02, Digits )
              + "/E2." + TimeToStr( (int)EnDwTime02, TIME_SECONDS )
              + "/" + DoubleToStr( EnDwPrice02, Digits )
              + "/X2." + TimeToStr( (int)ExDwTime02, TIME_SECONDS )
              + "/" + DoubleToStr( ExDwPrice02, Digits )
              // + "/BR2." + TimeToStr( time[(int)rTime02[0]], TIME_MINUTES )
              // + "/" + DoubleToStr( rPrice02[0], Digits )
              + "/BS2." + TimeToStr( time[(int)sTime02[0]], TIME_MINUTES )
              + "/" + DoubleToStr( sPrice02[0], Digits )
              + "/BR1." + TimeToStr( time[(int)rTime01[0]], TIME_MINUTES )
              + "/" + DoubleToStr( rPrice01[0], Digits )
              + "/BS1." + TimeToStr( time[(int)sTime01[0]], TIME_MINUTES )
              + "/" + DoubleToStr( sPrice01[0], Digits )
              // + "/sT=" + TimeToStr( time[(int)sTime00], TIME_MINUTES)
              // + "/" + DoubleToStr( sPrice00, Digits )
              // + "/xP2." + DoubleToStr( xPos02, 0 )
              + "/xP1." + DoubleToStr( xPos01, 0 ) 
          );
        break;

        case 52:
          //*--- Up.Exit Arrow:0 & Dw.Exit Arrow:1 ---//
          ObjectMove( "ExPos:0", 0, (int)ExUpTime02, ExUpPrice02 );
          ObjectMove( "ExPos:1", 0, (int)ExDwTime02, ExDwPrice02 );

          //--- B.Sup:2 -> B.Res:2 Setup ---//
          Base_TrendLine(52, SxPos01, sTime02[0], rates_total, high, low);

          //---* Base.Res:1 & 2 Setup ---//
          ObjectMove( "BaseRes:1", 0, time[(int)rTime02[0]], rPrice02[0] );
          ObjectMove( "BaseRes:2", 0, time[(int)rTime01[0]], rPrice01[0] );

          //---* Dw.Entry Algorithm ---//
          Entry_Sig( 60 );

          //---* nxCheck=52 & B.Sup:2 & B.Res:2 : Print Out ---//
          Print( // "bTL=" + string(BaseTL)
              //   "bTL" // + string(BaseTL)
              ""
              // + "bB." + string(bBTL)
              + string(bBTL)
              + "/"
              // + "/TL." + string(nxCheck)
              + string(nxCheck)
              + "/E1." + TimeToStr( (int)EnUpTime02, TIME_SECONDS )
              + "/" + DoubleToStr( EnUpPrice02, Digits )
              + "/X1." + TimeToStr( (int)ExUpTime02, TIME_SECONDS )
              + "/" + DoubleToStr( ExUpPrice02, Digits )
              + "/E2." + TimeToStr( (int)EnDwTime02, TIME_SECONDS )
              + "/" + DoubleToStr( EnDwPrice02, Digits )
              + "/X2." + TimeToStr( (int)ExDwTime02, TIME_SECONDS )
              + "/" + DoubleToStr( ExDwPrice02, Digits )
              + "/BR2." + TimeToStr( time[(int)rTime02[0]], TIME_MINUTES )
              + "/" + DoubleToStr( rPrice02[0], Digits )
              + "/BS2." + TimeToStr( time[(int)sTime02[0]], TIME_MINUTES )
              + "/" + DoubleToStr( sPrice02[0], Digits )
              + "/BR1." + TimeToStr( time[(int)rTime01[0]], TIME_MINUTES )
              + "/" + DoubleToStr( rPrice01[0], Digits )
              + "/BS1." + TimeToStr( time[(int)sTime01[0]], TIME_MINUTES )
              + "/" + DoubleToStr( sPrice01[0], Digits )
              // + "/sT=" + TimeToStr( time[(int)sTime00], TIME_MINUTES)
              // + "/" + DoubleToStr( sPrice00, Digits )
              // + "/xP2." + DoubleToStr( xPos02, 0 )
              + "/xP1." + DoubleToStr( xPos01, 0 )
              + "/HT3." + TimeToStr( time[(int)HighPos03], TIME_MINUTES )
              + "/" + DoubleToStr( High03, Digits )
              // + "/HT2." + TimeToStr( time[(int)HighPos02], TIME_MINUTES )
              // + "/" + DoubleToStr( High02, Digits )
              + "/rr1." + string(rr1)
              + "/rr2." + string(rr2)
          );
        break;

        case 63:
          //*--- Dw.Entry Arrow: 1 & 0 ---//
          ObjectMove( "EnPos:0", 0, (int)EnDwTime02, EnDwPrice02 );
          ObjectMove( "EnPos:1", 0, (int)EnUpTime02, EnUpPrice02 );

          //*--- Trend.Dw: 0 & 1 ---//
          //--- rTime02 ---//
          ObjectMove( "Trend.Down:0", 0, time[(int)rTime02[0]], rPrice02[0] );
          ObjectMove( "Trend.Down:0", 1, (int)EnDwTime02, EnDwPrice02 );
          //--- rTime01 ---//
          ObjectMove( "Trend.Down:1", 0, time[(int)rTime01[0]], rPrice01[0] );
          ObjectMove( "Trend.Down:1", 1, (int)EnDwTime01, EnDwPrice01 );

          //---* Dw.Exit Algorithm ---//
          Exit_Sig( 63, rTime02[0] );

          //---* nxCheck=63 & B.Res:2 & B.Sup:1 : Print Out ---//
          Print( // "bTL=" + string(BaseTL)
              //   "bTL" // + string(BaseTL)
              ""
              // + "bB." + string(bBTL)
              + string(bBTL)
              + "/"
              // + "/TL." + string(nxCheck)
              + string(nxCheck)
              + "/E1." + TimeToStr( (int)EnDwTime02, TIME_SECONDS )
              + "/" + DoubleToStr( EnDwPrice02, Digits )
              + "/X1." + TimeToStr( (int)ExDwTime02, TIME_SECONDS )
              + "/" + DoubleToStr( ExDwPrice02, Digits )
              + "/E2." + TimeToStr( (int)EnUpTime02, TIME_SECONDS )
              + "/" + DoubleToStr( EnUpPrice02, Digits )
              + "/X2." + TimeToStr( (int)ExUpTime02, TIME_SECONDS )
              + "/" + DoubleToStr( ExUpPrice02, Digits )
              + "/BR2." + TimeToStr( time[(int)rTime02[0]], TIME_MINUTES )
              + "/" + DoubleToStr( rPrice02[0], Digits )
              + "/BS1." + TimeToStr( time[(int)sTime01[0]], TIME_MINUTES )
              + "/" + DoubleToStr( sPrice01[0], Digits )
              + "/BR1." + TimeToStr( time[(int)rTime01[0]], TIME_MINUTES )
              + "/" + DoubleToStr( rPrice01[0], Digits )
              // + "/sT=" + TimeToStr( time[(int)sTime00], TIME_MINUTES)
              // + "/" + DoubleToStr( sPrice00, Digits )
              // + "/xP2." + DoubleToStr( xPos02, 0 )
              + "/xP1." + DoubleToStr( xPos01, 0 ) 
          );
        break;

        case 64:
          //*--- Dw.Exit Arrow:0 & Up.Exit Arrow:1 ---//
          ObjectMove( "ExPos:0", 0, (int)ExDwTime02, ExDwPrice02 );
          ObjectMove( "ExPos:1", 0, (int)ExUpTime02, ExUpPrice02 );

          //--- B.Res:2 -> B.Sup:2 Setup ---//
          Base_TrendLine(64, RxPos01, rTime02[0], rates_total, high, low);

          //---* Base.Sup:1 & 2 Setup ---//
          ObjectMove( "BaseSup:1", 0, time[(int)sTime02[0]], sPrice02[0] );
          ObjectMove( "BaseSup:2", 0, time[(int)sTime01[0]], sPrice01[0] );

          //---* Up.Entry Algorithm ---//
          Entry_Sig( 50 );

          //---* nxCheck=64 & B.Res:2 & B.Sup:2 : Print Out ---//
          Print( // "bTL=" + string(BaseTL)
              //   "bTL" // + string(BaseTL)
              ""
              // + "bB." + string(bBTL)
              + string(bBTL)
              + "/"
              // + "/TL." + string(nxCheck)
              + string(nxCheck)
              + "/E1." + TimeToStr( (int)EnDwTime02, TIME_SECONDS )
              + "/" + DoubleToStr( EnDwPrice02, Digits )
              + "/X1." + TimeToStr( (int)ExDwTime02, TIME_SECONDS )
              + "/" + DoubleToStr( ExDwPrice02, Digits )
              + "/E2." + TimeToStr( (int)EnUpTime02, TIME_SECONDS )
              + "/" + DoubleToStr( EnUpPrice02, Digits )
              + "/X2." + TimeToStr( (int)ExUpTime02, TIME_SECONDS )
              + "/" + DoubleToStr( ExUpPrice02, Digits )
              + "/BS2." + TimeToStr( time[(int)sTime02[0]], TIME_MINUTES )
              + "/" + DoubleToStr( sPrice02[0], Digits )
              + "/BR2." + TimeToStr( time[(int)rTime02[0]], TIME_MINUTES )
              + "/" + DoubleToStr( rPrice02[0], Digits )
              + "/BS1." + TimeToStr( time[(int)sTime01[0]], TIME_MINUTES )
              + "/" + DoubleToStr( sPrice01[0], Digits )
              + "/BR1." + TimeToStr( time[(int)rTime01[0]], TIME_MINUTES )
              + "/" + DoubleToStr( rPrice01[0], Digits )
              // + "/sT=" + TimeToStr( time[(int)sTime00], TIME_MINUTES)
              // + "/" + DoubleToStr( sPrice00, Digits )
              // + "/xP2." + DoubleToStr( xPos02, 0 )
              + "/xP1." + DoubleToStr( xPos01, 0 )
              + "/LT3." + TimeToStr( time[(int)LowPos03], TIME_MINUTES )
              + "/" + DoubleToStr( Low03, Digits )
              + "/rs1." + string(rs1)
              + "/rs2." + string(rs2)
          );
        break;

        case 91:
          //*--- Up.Entry Arrow:0 ---//
          ObjectMove( "EnPos:0", 0, (int)EnUpTime01, EnUpPrice01 );

          //*--- Trend.Up:0 ---//
          // ObjectMove( "Trend.Up:0", 0, time[(int)sTime0], sPrice0 );
          ObjectMove( "Trend.Up:0", 0, time[(int)sTime00], sPrice00 );
          ObjectMove( "Trend.Up:0", 1, (int)EnUpTime01, EnUpPrice01 );
          
          //---* Up.Exit Algorithm ---//
          // Exit_Sig( 91, sTime0 );
          Exit_Sig( 91, sTime00 );

          //*--- Up.Exit Arrow:0 ---//
          // ObjectMove( "ExPos:0", 0, (int)ExUpTime01, ExUpPrice01 );

          //---* nxCheck=91 & B.Sup:0 : Print Out ---//
          Print( "bTL." + string(BaseTL)
              + "/bB." + string(bBTL)
              + "/TL." + string(nxCheck)
              + "/E1=" + TimeToStr( (int)EnUpTime01, TIME_SECONDS )
              + "/" + DoubleToStr( EnUpPrice01, Digits )
              // + "/XT01=" + TimeToStr( (int)ExUpTime01, TIME_SECONDS )
              // + "/XP01=" + DoubleToStr( ExUpPrice01, Digits )
              // + "/sT=" + TimeToStr( time[(int)sTime00], TIME_SECONDS )
              + "/sT=" + TimeToStr( time[(int)sTime00], TIME_MINUTES)
              + "/" + DoubleToStr( sPrice00, Digits )
              // + "/sT=" + DoubleToStr( sTime00, 0 )
              // + "/" + DoubleToStr( sPrice00, Digits )
              + "/sT0=" + DoubleToStr( sTime0, 0 )
              // + "/r=" + string(rates_total)
          );
        break;

        case 92:
          //*--- Up.Exit Arrow:0 ---//
          ObjectMove( "ExPos:0", 0, (int)ExUpTime01, ExUpPrice01 );

          //--- B.Sup:0 -> B.Res:1 Setup ---//
          // (0.11.3.52.OK) Base_TrendLine(92, SxPos01, sTime0, high, low);
          // Base_TrendLine(92, SxPos01, sTime0, rates_total, high, low);
          Base_TrendLine(92, SxPos01, sTime00, rates_total, high, low);
          //---* Base.Res:1 Setup ---//
          ObjectMove( "BaseRes:1", 0, time[(int)rTime01[0]], rPrice01[0] );

          //---* Dw.Entry Algorithm ---//
          // Entry_Sig( 92 );
          Entry_Sig( 92 );

          //---* nxCheck=92 & B.Sup:0 : Print Out ---//
          Print( "bTL." + string(BaseTL)
              + "/bB." + string(bBTL)
              + "/TL." + string(nxCheck)
              + "/E1=" + TimeToStr( (int)EnUpTime01, TIME_SECONDS )
              + "/" + DoubleToStr( EnUpPrice01, Digits )
              + "/X1=" + TimeToStr( (int)ExUpTime01, TIME_SECONDS )
              + "/" + DoubleToStr( ExUpPrice01, Digits )
              + "/BR01=" + TimeToStr( time[(int)rTime01[0]], TIME_MINUTES )
              + "/" + DoubleToStr( rPrice01[0], Digits )
              // + "/st=" + TimeToStr( (int)sTime00, TIME_SECONDS )
              // + "/" + DoubleToStr( sPrice00, Digits )
              + "/sT=" + TimeToStr( time[(int)sTime00], TIME_MINUTES)
              + "/" + DoubleToStr( sPrice00, Digits )
              + "/sT0=" + DoubleToStr( sTime0, 0 )
              + "/xP1." + DoubleToStr( xPos01, 0 )
          );
        break;

        case 93:
          //*--- Dw.Entry Arrow:0 ---//
          ObjectMove( "EnPos:0", 0, (int)EnDwTime01, EnDwPrice01 );

          //*--- Trend.Dw:0 ---//
          // (0.11.3.56.OK) ObjectMove( "Trend.Down:0", 0, time[(int)rTime0], rPrice0 );
          ObjectMove( "Trend.Down:0", 0, time[(int)rTime00], rPrice00 );
          ObjectMove( "Trend.Down:0", 1, (int)EnDwTime01, EnDwPrice01 );

          //---* Dw.Exit Algorithm ---//
          // (0.11.3.56.OK) Exit_Sig( 93, rTime0 );
          Exit_Sig( 93, rTime00 );

          //---* nxCheck=93 & B.Res:0 : Print Out ---//
          Print( "bTL." + string(BaseTL)
              + "/bB." + string(bBTL)
              + "/TL." + string(nxCheck)
              + "/E1=" + TimeToStr( (int)EnDwTime01, TIME_SECONDS )
              + "/" + DoubleToStr( EnDwPrice01, Digits )
              // + "/XT01=" + TimeToStr( (int)ExUpTime01, TIME_SECONDS )
              // + "/XP01=" + DoubleToStr( ExUpPrice01, Digits )
              + "/rT=" + TimeToStr( time[(int)rTime00], TIME_MINUTES)
              + "/" + DoubleToStr( rPrice00, Digits )
              + "/rT0=" + DoubleToStr( rTime0, 0 )
          );
        break;

        case 94:
          //*--- Dw.Exit Arrow:0 ---//
          ObjectMove( "ExPos:0", 0, (int)ExDwTime01, ExDwPrice01 );

          //--- B.Res:0 -> B.Sup:1 Setup ---//
          // Base_TrendLine(94, RxPos01, rTime0, high, low);
          // Base_TrendLine(94, RxPos01, rTime0, rates_total, high, low);
          Base_TrendLine(94, RxPos01, rTime00, rates_total, high, low);
          //---* Base.Sup:1 Setup ---//
          ObjectMove( "BaseSup:1", 0, time[(int)sTime01[0]], sPrice01[0] );

          //---* Up.Entry Algorithm ---//
          // Entry_Sig( 94 );
          Entry_Sig( 94 );

          //---* nxCheck=94 & B.Res:0 : Print Out ---//
          Print( "bTL." + string(BaseTL)
              + "/bB." + string(bBTL)
              + "/TL." + string(nxCheck)
              + "/E1." + TimeToStr( (int)EnDwTime01, TIME_SECONDS )
              + "/" + DoubleToStr( EnDwPrice01, Digits )
              + "/X1=" + TimeToStr( (int)ExDwTime01, TIME_SECONDS )
              + "/" + DoubleToStr( ExDwPrice01, Digits )
              + "/BS1=" + TimeToStr( time[(int)sTime01[0]], TIME_MINUTES )
              + "/" + DoubleToStr( sPrice01[0], Digits )
              + "/rT=" + TimeToStr( time[(int)rTime00], TIME_MINUTES)
              + "/" + DoubleToStr( rPrice00, Digits )
              + "/rT0=" + DoubleToStr( rTime0, 0 )
              + "/xP1." + DoubleToStr( xPos01, 0 )
          );
        break;
      }
    break;

    default:
      Print( "sTime0=" + DoubleToStr( sTime0, 0 )
          + "/rTime0=" + DoubleToStr( rTime0, 0 )
      );
    break;
  }


/* (Ver.0.11.3)
  if(sTime0[0]>rTime0[0])   // Sup.Price(Left) : Trend.Up
  {
    // Print( "sTime0:" + DoubleToStr( sTime0[0], 0 ) 
        + " > rTime0:" + DoubleToStr( rTime0[0], 0 ) );
  }
  if(rTime0[0]>sTime0[0])   // Res.Price(Left) : Trend.Down
  {
    // Print( "rTime0:" + DoubleToStr( rTime0[0], 0 ) 
        + " > sTime0:" + DoubleToStr( sTime0[0], 0 ) );
  }
*/


//---- OnCalculate done. Return new prev_calculated.
  return(rates_total);

}

//+------------------------------------------------------------------+