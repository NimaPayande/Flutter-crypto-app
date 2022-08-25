import 'package:crypto_app/model/coin.dart';
import 'package:crypto_app/services/service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Coin>> _future;
  @override
  void initState() {
    _future = fetchData();
    super.initState();
  }

  Future<String> getImage(String src) {
    return Future.delayed(const Duration(seconds: 2), () {
      return src;
    });
  }

  final formatter = NumberFormat.decimalPattern();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Coin>>(
        future: _future,
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(
                        data[index].name!,
                      ),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(data[index].image!),
                        backgroundColor: Colors.transparent,
                      ),
                      subtitle: Text(
                          '\$${formatter.format(data[index].currentPrice)}'),
                    ),
                  );
                });
          } else if (snapshot.hasError) {
            throw snapshot.error.toString();
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
