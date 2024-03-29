//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>        //include the library for execution of trades
#include <Trade\PositionInfo.mqh> //include the library for obtaining information on positions
#include <DeepNeuralNetwork.mqh> 

int numInput=4;
int numHiddenA = 4;
int numHiddenB = 5;
int numOutput=3;

DeepNeuralNetwork dnn(numInput,numHiddenA,numHiddenB,numOutput);

//--- weight values
input double w0=-0.924;
input double w1=0.178;
input double w2=-0.977;
input double w3=0.620;
input double w4=0.950;
input double w5=0.321;
input double w6=-0.784;
input double w7=-0.271;
input double w8=0.190;
input double w9=-0.513;
input double w10=0.712;
input double w11=-0.927;
input double w12=-0.529;
input double w13=0.123;
input double w14=-0.978;
input double w15=0.459;
input double b0=0.177;
input double b1=-0.990;
input double b2=-0.600;
input double b3=0.118;
input double w40=0.807;
input double w41=-0.628;
input double w42=0.791;
input double w43=0.792;
input double w44=-0.322;
input double w45=-0.563;
input double w46=-0.742;
input double w47=-0.951;
input double w48=0.689;
input double w49=-0.760;
input double w50=0.023;
input double w51=-0.558;
input double w52=0.408;
input double w53=0.323;
input double w54=-0.699;
input double w55=-0.808;
input double w56=-0.522;
input double w57=-0.972;
input double w58=0.888;
input double w59=-0.778;
input double b4=-0.845;
input double b5=-0.233;
input double b6=0.213;
input double b7=-0.931;
input double b8=-0.976;
input double w60=-0.766;
input double w61=-0.875;
input double w62=-0.897;
input double w63=-0.312;
input double w64=-0.989;
input double w65=-0.128;
input double w66=0.895;
input double w67=-0.988;
input double w68=0.539;
input double w69=0.141;
input double w70=-0.998;
input double w71=0.870;
input double w72=0.866;
input double w73=-0.222;
input double w74=-0.250;
input double b9=-0.203;
input double b10=0.045;
input double b11=-0.873;

input double Lot=0.1;

input long order_magic=55555;//MagicNumber

MqlRates          rates[];

double            _xValues[4];   // musi byc 4-elementowa ze wzgledu na charakter budowy sieci (5-elementowy inputLayer)
double            weight[63];  
double            yValues[];     

int               ADX;
int               RSI;
int               MACD;
int               ATR;

double            SL;

double            ADXArray[];
double            DImArray[];
double            DIpArray[];
double            RSIArray[];
double            MACDArray[];
double            MACDsignalArray[];
double            ATRArray[];

double            out;          

string            my_symbol;    
ENUM_TIMEFRAMES   my_timeframe; 
double            lot_size;     

CTrade            m_Trade;      
CPositionInfo     m_Position;   
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   my_symbol=Symbol();
   my_timeframe=PERIOD_CURRENT;
   lot_size=Lot;
   m_Trade.SetExpertMagicNumber(order_magic);


   weight[0]=w0;
   weight[1]=w1;
   weight[2]=w2;
   weight[3]=w3;
   weight[4]=w4;
   weight[5]=w5;
   weight[6]=w6;
   weight[7]=w7;
   weight[8]=w8;
   weight[9]=w9;
   weight[10]=w10;
   weight[11]=w11;
   weight[12]=w12;
   weight[13]=w13;
   weight[14]=w14;
   weight[15]=w15;
   weight[16]=b0;
   weight[17]=b1;
   weight[18]=b2;
   weight[19]=b3;
   weight[20]=w40;
   weight[21]=w41;
   weight[22]=w42;
   weight[23]=w43;
   weight[24]=w44;
   weight[25]=w45;
   weight[26]=w46;
   weight[27]=w47;
   weight[28]=w48;
   weight[29]=w49;
   weight[30]=w50;
   weight[31]=w51;
   weight[32]=w52;
   weight[33]=w53;
   weight[34]=w54;
   weight[35]=w55;
   weight[36]=w56;
   weight[37]=w57;
   weight[38]=w58;
   weight[39]=w59;
   weight[40]=b4;
   weight[41]=b5;
   weight[42]=b6;
   weight[43]=b7;
   weight[44]=b8;
   weight[45]=w60;
   weight[46]=w61;
   weight[47]=w62;
   weight[48]=w63;
   weight[49]=w64;
   weight[50]=w65;
   weight[51]=w66;
   weight[52]=w67;
   weight[53]=w68;
   weight[54]=w69;
   weight[55]=w70;
   weight[56]=w71;
   weight[57]=w72;
   weight[58]=w73;
   weight[59]=w74;
   weight[60]=b9;
   weight[61]=b10;
   weight[62]=b11;

//--- return 0, initialization complete
   return(0);
  }

void OnTick()
  {
  //skopiuj wartosci 
   ArraySetAsSeries(rates,true);
   int copied=CopyRates(_Symbol,0,1,5,rates);

   //RSI
   RSI = iRSI(_Symbol,_Period,14,rates[0].close);
   ArraySetAsSeries(RSIArray,true);
   CopyBuffer(RSI,0,1,3,RSIArray);
   //double RSIValue = NormalizeDouble(RSIArray[0],2);
   
   //ATR
   ATR = iATR(_Symbol,_Period,14);
   ArraySetAsSeries(ATRArray,true);
   CopyBuffer(ATR,0,1,3,ATRArray);
   
   // ADX
   ADX = iADX(_Symbol,_Period,14);
   ArraySetAsSeries(ADXArray,true);
   CopyBuffer(ADX,0,1,1,ADXArray);
   ArraySetAsSeries(DIpArray,true);
   CopyBuffer(ADX,1,1,2,DIpArray);
   ArraySetAsSeries(DImArray,true);
   CopyBuffer(ADX,2,1,2,DImArray);

   double ADXValue = NormalizeDouble(ADXArray[0],3);
   
   // MACD
   MACD = iMACD(_Symbol,_Period,12,26,9,rates[0].close);
   ArraySetAsSeries(MACDArray,true);
   CopyBuffer(MACD,0,1,5,MACDArray);
   ArraySetAsSeries(MACDsignalArray,true);
   CopyBuffer(MACD,1,1,5,MACDsignalArray);
   
   //inicjalizacja tabeli dla sieci, dosc prymitywne sprowadzenie wartosci do podobynch rzedow
   _xValues[0] = MACDArray[0]*100;
   _xValues[1] = ADXValue/100;
   _xValues[2] = ATRArray[0]*100;
   _xValues[3] = RSIArray[0]/100;
   
   //wywołanie obliczeń dla dnn
   dnn.SetWeights(weight);
   dnn.ComputeOutputs(_xValues,yValues);
   
   // SCHEMAT // 
   //stop loss
   if(m_Position.Select(my_symbol) || SL != 0)//check if there is an open position
   {
      if(m_Position.PositionType()==POSITION_TYPE_BUY){
         if (rates[0].close < SL){
            nnClose();
            Alert("Closed on: ",rates[0].close);
            return;
            }
      }
      if(m_Position.PositionType()==POSITION_TYPE_SELL){
         if (SL < rates[0].close){
            nnClose();
            Alert("Closed on: ",rates[0].close);
            return;
         }
      }
   } 

   //sell
   if(MACDArray[1]>0) {
      if(ADXValue > 20 && ((DImArray[1]<=DIpArray[1] && DImArray[0]>=DIpArray[0]) || (RSIArray[2]>=70 && RSIArray[0]<70  )) ){
         nnSell();
         Alert("sell: "+SL+" "+ rates[0].close);
      }
      //dywergencja MACD wzgledem ceny
      if(MACDsignalArray[2] > MACDsignalArray[0] && rates[2].close < rates[0].close ){
         nnSell();
         Alert("sell: "+SL+" "+ rates[0].close);
      }

   }
  //buy
   else if(MACDArray[1]<0  ){
      //dywergencja MACD wzgledem ceny
      if(MACDsignalArray[2] < MACDsignalArray[0] && rates[2].close > rates[0].close){
         nnBuy();
         Alert("Buy: "+SL+" "+ rates[0].close);
      }  
      if(ADXValue > 20 && ((DImArray[1]>=DIpArray[1] && DImArray[0]<=DIpArray[0]) || (RSIArray[1]<=30 && RSIArray[0]>30 )) ){
         nnBuy();
         Alert("buy: "+SL+" "+ rates[0].close);
      }

   }
   
 }
  
 //+------------------------------------------------------------------+
 //| funkcje odpowiedzialne za zawieranie transakcji
 //+------------------------------------------------------------------+
void nnBuy(){
     if(yValues[0]>0.55){
      if(m_Position.Select(my_symbol))//check if there is an open position
        {
         if(m_Position.PositionType()==POSITION_TYPE_SELL)
         {
            m_Trade.PositionClose(my_symbol);//Close the opposite position if exists
            SL = 0;
         }
         if(m_Position.PositionType()==POSITION_TYPE_BUY) return;
        }
      m_Trade.Buy(lot_size,my_symbol);//open a Long position
      SL = NormalizeDouble(rates[0].close - 0.6* ATRArray[0],_Digits);
      }
}

void nnSell(){
     if(yValues[1]>0.55){
      if(m_Position.Select(my_symbol))//check if there is an open position
        {
         if(m_Position.PositionType()==POSITION_TYPE_BUY)
         {
            m_Trade.PositionClose(my_symbol);//Close the opposite position if exists
            SL = 0;
         }
        if(m_Position.PositionType()==POSITION_TYPE_SELL) return;
        }
      m_Trade.Sell(lot_size,my_symbol);//open a short position
      SL = NormalizeDouble(rates[0].close + 0.6* ATRArray[0],_Digits);
    }
}

void nnClose(){
      if(yValues[2]>0.55){
      m_Trade.PositionClose(my_symbol);//close any position
      SL = 0;
     }
}

