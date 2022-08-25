import 'package:http/http.dart' as http;
import '../model/coin.dart';

Future<List<Coin>> fetchData() async {
  const coinUrl =
      'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false';
  final response = await http.get(Uri.parse(coinUrl));
  if (response.statusCode == 200) {
    return coinFromJson(response.body);
  } else {
    throw Exception('Failed to load');
  }
}
