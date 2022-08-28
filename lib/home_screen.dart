import 'dart:ui';
import 'package:crypto_app/chart.dart';
import 'package:crypto_app/widgets/background.dart';
import 'package:crypto_app/detail_screen.dart';
import './constants.dart';
import './models/coin.dart';
import './services/coin_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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

  //* loading Animation
  final spinkit = const SpinKitThreeBounce(
    color: kGreenColor,
    size: 30,
  );

  checkPercentage(data, int index) {
    return data[index]
            .priceChangePercentage7DInCurrency
            .toString()
            .contains('-')
        ? kRedColor
        : kGreenColor;
  }

  // Format values like this => 100,000,000
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
              title: Text(
                'Discover',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              centerTitle: false,
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Background(
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
                          padding: const EdgeInsets.only(left: 110, top: 20),
                          child: Center(
                            child: SizedBox(
                                height: 30,
                                width: 60,
                                child: Chart(
                                  blurRadius: 30,
                                  spreadRadius: -10,
                                  data: data[index],
                                )),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            //! Ending with "..." when Flutter Text exceeds a certain length.
                            data[index].name!.length >= 13
                                ? '${data[index].name!.substring(0, 13)}...'
                                : data[index].name!,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyLarge,
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
                                style: Theme.of(context).textTheme.bodyMedium,
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
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                          coin: data[index],
                                        )));
                          },
                          tileColor: Colors.transparent,
                          subtitle: Text(data[index].symbol!.toUpperCase(),
                              style: Theme.of(context).textTheme.bodySmall),
                        ),
                      ],
                    );
                  });
            } else if (snapshot.hasError) {
              throw snapshot.error.toString();
            }
            return Center(child: spinkit);
          },
        ),
      ),
    );
  }
}
