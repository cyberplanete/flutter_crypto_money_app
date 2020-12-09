import 'dart:io';
import 'dart:io' show Platform;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constants.dart';
import 'services/coinService.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'EUR';
  String currencyExchangeRate;
  String currentCryptoCurrency;

  bool isWaiting = false;
  @override
  void initState() {
    super.initState();
    getBitcoinExchangeRate();
  }

  Map<String, String> cryptoValues = {};
  getBitcoinExchangeRate() async {
    CoinService coinService =
        new CoinService(selectedCurrency: selectedCurrency);
    isWaiting = true;
    try {
      var data = await coinService.getCryptoExchangeRate();
      isWaiting = false;
      setState(() {
        cryptoValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: getListOfWidgetCardCurrency(),
          ),
          Expanded(child: SizedBox()),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 10.0),
            color: Colors.lightBlue,
            child: (Platform.isIOS)
                ? iOSPicker()
                : androidDropDown(), //ou DropdownButton
          ),
        ],
      ),
    );
  }

  CupertinoTheme iOSPicker() {
    List<Widget> pickerItems = [];
    kCurrenciesList.forEach(
      (element) {
        pickerItems.add(
          Text(element),
        );
      },
    );

    return CupertinoTheme(
        data: CupertinoThemeData(
            textTheme: CupertinoTextThemeData(
                pickerTextStyle: TextStyle(color: Colors.white))),
        child: CupertinoPicker(
            itemExtent: 35,
            onSelectedItemChanged: (selectedCurrency) {
              print(selectedCurrency);
            },
            children: pickerItems));
  }

  //Utilisé dans le cas d'un dropDown liste. Android
  DropdownButton<String> androidDropDown() {
    //List<Widget> listItems = []; plus précisement --->
    List<DropdownMenuItem<String>> listItems = [];
    kCurrenciesList.forEach(
      (element) {
        listItems.add(
          DropdownMenuItem(
            child: Text(element),
            value: element,
          ),
        );
      },
    );
    return DropdownButton<String>(
        value: selectedCurrency,
        items: listItems,
        onChanged: (value) {
          print(value);
          setState(() {
            selectedCurrency = value;
            getBitcoinExchangeRate();
          });
        });
  }

  getListOfWidgetCardCurrency() {
    List<Widget> listOfWidgetCardCurrency = [];

    for (String cryptoCurrency in kCryptoList) {
      listOfWidgetCardCurrency.add(
        MakeCardCurrency(
          selectedCurrency: selectedCurrency,
          cryptoCurrency: cryptoCurrency,
          currencyValue: (isWaiting) ? '?' : cryptoValues[cryptoCurrency],
        ),
      );
    }
    return listOfWidgetCardCurrency;
  }
}

class MakeCardCurrency extends StatelessWidget {
  final selectedCurrency;
  final currencyValue;
  final cryptoCurrency;
  const MakeCardCurrency(
      {this.selectedCurrency, this.currencyValue, this.cryptoCurrency});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          color: Colors.lightBlueAccent,
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 60.0),
            child: Text(
              '1 '
              '$cryptoCurrency'
              '='
              '$currencyValue'
              '$selectedCurrency',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

/*

DropdownButton<String>(
value: selectedCurency,
items: getDropDownItems(),
onChanged: (value) {
print(value);
setState(() {
selectedCurency = value;
});
})*/

/*
MakeCardCurrency(
selectedCurrency: selectedCurrency,
cryptoCurrency: 'BTC',
currencyValue: (isWaiting) ? '?' : cryptoValues['BTC'],
),
MakeCardCurrency(
selectedCurrency: selectedCurrency,
cryptoCurrency: 'ETH',
currencyValue: (isWaiting) ? '?' : cryptoValues['ETH'],
),
MakeCardCurrency(
selectedCurrency: selectedCurrency,
cryptoCurrency: 'LTC',
currencyValue: (isWaiting) ? '?' : cryptoValues['LTC'],
),*/
