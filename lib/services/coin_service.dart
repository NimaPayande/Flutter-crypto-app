import 'package:http/http.dart' as http;
import '../models/coin.dart';

Future<List<Coin>> fetchData() async {
  const coinUrl =
      'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=gecko_desc&per_page=100&page=1&sparkline=true&price_change_percentage=1h%2C7d%2C14d%2C30d';
  final response = await http.get(Uri.parse(coinUrl));
  if (response.statusCode == 200) {
    return coinFromJson(response.body);
  } else {
    throw Exception('Failed to load');
  }
}
