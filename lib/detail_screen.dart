import 'package:crypto_app/chart.dart';
import 'package:crypto_app/widgets/background.dart';
import 'package:crypto_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'models/coin.dart';

class DetailScreen extends StatefulWidget {
  DetailScreen({required this.coin, Key? key}) : super(key: key);
  Coin coin;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // Format values like this => 100,000,000
  final formatter = NumberFormat.decimalPattern();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColor,
      body: Background(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_ios_rounded)),
                    Text(
                      widget.coin.name!,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.star_border_rounded))
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${formatter.format(widget.coin.currentPrice)}',
                      style: const TextStyle(color: Colors.white, fontSize: 28),
                    ),
                    SizedBox(
                      height: 40,
                      width: 80,
                      child: Card(
                        color:
                            widget.coin.priceChangePercentage7DInCurrency! <= 0
                                ? kRedColor
                                : kGreenColor,
                        child: Center(
                          child: Text(
                            widget.coin.priceChangePercentage7DInCurrency!
                                .toStringAsFixed(3),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 80,
                ),
                Chart(
                  isDetailScreen: true,
                  data: widget.coin,
                  blurRadius: 20,
                  spreadRadius: -10,
                  opacity: 0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
