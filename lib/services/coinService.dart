import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';

class CoinService {
  final String selectedCurrency;

  CoinService({this.selectedCurrency});

  Future<Map> getCryptoExchangeRate() async {
    Map<String, String> cryptoValues = {};

    for (String crypto in kCryptoList) {
      var url = '$kUrl' '$crypto/' '$selectedCurrency' '?apikey=$kApikey';
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        String data = response.body;
        var decodedData = jsonDecode(data);
        double currencyValue = decodedData['rate'];
        cryptoValues[crypto] = currencyValue.toStringAsFixed(0);
      } else if (response.statusCode != 200) {
        print(response.statusCode);
      }
    }
    return cryptoValues;
  }
}
