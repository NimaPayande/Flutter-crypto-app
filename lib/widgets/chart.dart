import 'package:crypto_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import '../models/coin.dart';

class Chart extends StatelessWidget {
  Chart(
      {required this.data,
      Key? key,
      required this.blurRadius,
      required this.spreadRadius,
      this.opacity = 1,
      this.isDetailScreen = false})
      : super(key: key);
  Coin data;
  final double blurRadius;
  final double spreadRadius;
  final double opacity;
  final bool isDetailScreen;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              // Chart Glow
              color: data.priceChangePercentage7DInCurrency! <= 0
                  ? kRedColor.withOpacity(opacity)
                  : kGreenColor.withOpacity(opacity),
              blurRadius: blurRadius,
              spreadRadius: spreadRadius,
            )
          ]),
          child: SfSparkLineChart(
            trackball: isDetailScreen
                ? const SparkChartTrackball(
                    color: Colors.white,
                    activationMode: SparkChartActivationMode.tap)
                : null,
            axisLineWidth: 0,
            data: data.sparklineIn7D!.price,
            color: data.priceChangePercentage7DInCurrency! <= 0
                ? kRedColor
                : kGreenColor,
          ),
        ),
      ],
    );
  }
}
