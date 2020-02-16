# DnnMQL5

Program for "Data Analysis on financial markets", winter semester 2019/2020.

## Usage

"StrategiaSieciNeuronowe.mq5" to be imported as expert advisor in MetaEditor, with "DeepnNeuralNetowrk.mqh" imported into "include" folder.

## Remarks

Made in MQL5, based on article by Anddy Cabrera: https://www.mql5.com/en/blogs/post/724245.

This is a simple program automating trades on FOREX. It's based on 4 technical analysis indicators to generate sell/buy/stoploss signals, which DNN picks up and classifies whether or not the trade should be taken or stopped.  
The weights and biases for neural network were optimized by genetical algorithm specifically for GBPUSD market. 

Usage of the program shows common issues related to using machine learning solutions in real time enviroments, like ovefitting and weakness for volatility. 
