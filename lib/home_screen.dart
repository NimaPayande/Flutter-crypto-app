import 'dart:ui';

import 'package:crypto_app/constants.dart';
import 'package:crypto_app/models/coin.dart';
import 'package:crypto_app/services/coin_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import 'constants.dart';

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

  checkPercentage(data, int index) {
    return data[index]
            .priceChangePercentage7DInCurrency
            .toString()
            .contains('-')
        ? kRedColor
        : kGreenColor;
  }

  final formatter = NumberFormat.decimalPattern();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 60),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AppBar(
              backgroundColor: Colors.black.withOpacity(.2),
              title: const Text(
                'Discover',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // blur Circle for background
          Center(
              child: Padding(
            padding: const EdgeInsets.only(left: 200, top: 200),
            child: CircleAvatar(
              radius: 1000,
              backgroundColor: kRedColor.withOpacity(.4),
            ),
          )),
          // blur Circle for background
          Center(
              child: Padding(
            padding: const EdgeInsets.only(right: 200, bottom: 200),
            child: CircleAvatar(
              radius: 1000,
              backgroundColor: Colors.blue.withOpacity(.4),
            ),
          )),
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: 100, sigmaY: 100, tileMode: TileMode.mirror),
              child: FutureBuilder<List<Coin>>(
                future: _future,
                builder: (context, snapshot) {
                  final data = snapshot.data;
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: data!.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 110, top: 20),
                                child: Center(
                                  child: SizedBox(
                                    height: 30,
                                    width: 60,
                                    child: Container(
                                      decoration: BoxDecoration(boxShadow: [
                                        BoxShadow(
                                          color: checkPercentage(data, index),
                                          blurRadius: 30,
                                          spreadRadius: -10,
                                        )
                                      ]),
                                      child: SfSparkLineChart(
                                          axisLineWidth: 0,
                                          data:
                                              data[index].sparklineIn7D!.price,
                                          color: checkPercentage(data, index)),
                                    ),
                                  ),
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  //! Ending with "..." when Flutter Text exceeds a certain length.
                                  data[index].name!.length >= 13
                                      ? '${data[index].name!.substring(0, 13)}...'
                                      : data[index].name!,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                leading: CircleAvatar(
                                  radius: 20,
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
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                        data[index]
                                                .priceChangePercentage7DInCurrency
                                                .toString()
                                                .contains('-')
                                            ? '${data[index].priceChangePercentage7DInCurrency!.toStringAsFixed(2)}%'
                                            : '+${data[index].priceChangePercentage7DInCurrency!.toStringAsFixed(3)}%',
                                        style: TextStyle(
                                          color: checkPercentage(data, index),
                                        ))
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
            ),
          ),
        ],
      ),
    );
  }
}
