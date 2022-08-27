import 'dart:ffi';
import 'dart:math';

import 'package:crypto_app/constants.dart';
import 'package:crypto_app/models/chart_data.dart';
import 'package:crypto_app/models/coin.dart';
import 'package:crypto_app/services/coin_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

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

  final formatter = NumberFormat.decimalPattern();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Discover',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ))
        ],
        centerTitle: false,
      ),
      body: FutureBuilder<List<Coin>>(
        future: _future,
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: data!.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Center(
                        child: SizedBox(
                          height: 30,
                          width: 60,
                          child: SfSparkLineChart(
                            axisLineWidth: 0,
                            firstPointColor: Colors.amber,
                            data: data[index].sparklineIn7D!.price,
                            color: data[index]
                                        .priceChangePercentage7DInCurrency! <=
                                    0
                                ? kRedColor
                                : kGreenColor,
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          data[index].name!,
                          style: const TextStyle(color: Colors.white),
                        ),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            data[index].image!,
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$${formatter.format(data[index].currentPrice)}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              data[index]
                                      .priceChangePercentage7DInCurrency
                                      .toString()
                                      .contains('-')
                                  ? data[index]
                                      .priceChangePercentage7DInCurrency!
                                      .toStringAsFixed(2)
                                  : '+${data[index].priceChangePercentage7DInCurrency!.toStringAsFixed(3)}',
                              style: TextStyle(
                                  color: data[index]
                                          .priceChangePercentage7DInCurrency
                                          .toString()
                                          .contains('-')
                                      ? kRedColor
                                      : kGreenColor),
                            )
                          ],
                        ),
                        tileColor: Colors.transparent,
                        subtitle: Text(
                          data[index].symbol!.toUpperCase(),
                          style: const TextStyle(color: Colors.white60),
                        ),
                      ),
                    ],
                  );
                });
          } else if (snapshot.hasError) {
            throw snapshot.error.toString();
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
