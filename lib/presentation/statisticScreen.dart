import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:budget_family/presentation/StatisticsBloc/statistics_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../utils/utils.dart';

class ExpenseStatistics extends StatefulWidget {
  final double totalBalance;
  const ExpenseStatistics({super.key, required this.totalBalance});


  @override
  State<ExpenseStatistics> createState() => _ExpenseStatisticsState();
}

class _ExpenseStatisticsState extends State<ExpenseStatistics> {
  Map<String, double> PieChartdataMap = {};

  @override
  void initState() {
    super.initState();
    final currentState = context.read<StatisticsBloc>().state;
    if (currentState is! PieChartSuccessState) {
      context.read<StatisticsBloc>().add(GetPieChart());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ekran boyutunu almak için MediaQuery kullanıyoruz
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: BlocBuilder<StatisticsBloc, StatisticsState>(
        builder: (context, state) {
          if (state is ChartLoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                strokeWidth: 2.0,
              ),
            );
          }

          if (state is ErrorState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              AnimatedSnackBar.material(
                state.error,
                type: AnimatedSnackBarType.error,
                mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                duration: const Duration(seconds: 4),
              ).show(context);
            });
          }

          if (state is PieChartSuccessState) {
            PieChartdataMap = state.chartData;
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.05),

                const Padding(
                  padding: EdgeInsets.only(left:10.0,top: 5),
                  child:  Align(alignment: Alignment.topLeft,
                      child: Text("Statistic Charts 📊",style:TextStyle(fontSize: 20,fontWeight: FontWeight.w400,color: Colors.indigo) ,)),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: screenWidth*0.25,
                        child: ElevatedButton(
                          onPressed: () {
                            // Category butonuna basıldığında yapılacak işlemler
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17),
                            ),
                          ),
                          child: const Text(
                            'Category',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: screenWidth*0.22,
                        child: ElevatedButton(
                          onPressed: () {
                            // Monthly butonuna basıldığında yapılacak işlemler
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17),
                            ),
                          ),
                          child: const Text(
                            'Month',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: screenWidth*0.22,
                        child: ElevatedButton(
                          onPressed: () {
                            // Weekly butonuna basıldığında yapılacak işlemler
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17),
                            ),
                          ),
                          child: const Text(
                            'Week',
                            style: TextStyle(
                              fontSize: 12, // Metin boyutunu azalt
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: screenWidth*0.24,
                        child: ElevatedButton(
                          onPressed: () {
                            // Balance butonuna basıldığında yapılacak işlemler
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17), 
                            ),
                          ),
                          child: const Text(
                            'Balance',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(),

                SizedBox(height: screenHeight * 0.03),


            SafeArea(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Yatay kaydırma
                child: Padding(
                  padding: const EdgeInsets.only(bottom:20.0),
                  child: Row(
                    children: [
                      // First Card
                      SizedBox(
                        width: screenWidth * 1,
                        height: screenHeight* 0.60,
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          shadowColor: Colors.grey.withOpacity(0.8),
                          margin: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(screenWidth * 0.05),
                            child: Material(
                              elevation: 10.0,
                              shadowColor: Colors.black,
                              borderRadius: BorderRadius.circular(20),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: PieChart(
                                  dataMap: PieChartdataMap,
                                  animationDuration: const Duration(milliseconds: 800),
                                  chartLegendSpacing: screenWidth * 0.15,
                                  chartRadius: screenWidth * 0.5,
                                  colorList: colorList,
                                  initialAngleInDegree: 45,
                                  chartType: ChartType.ring,
                                  ringStrokeWidth: screenWidth * 0.20,
                                  centerText: "Expenses",
                                  centerTextStyle: TextStyle(
                                    fontSize: screenWidth * 0.042,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.indigo,
                                  ),
                                  legendOptions: const LegendOptions(
                                    showLegendsInRow: true,
                                    legendPosition: LegendPosition.bottom,
                                    showLegends: true,
                                    legendShape: BoxShape.circle,
                                    legendTextStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    ),
                                  ),
                                  chartValuesOptions: const ChartValuesOptions(
                                    showChartValueBackground: true,
                                    showChartValuesInPercentage: true,
                                    showChartValuesOutside: true,
                                    decimalPlaces: 2,
                                  ),
                                  emptyColor: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // İkinci Card
                      SizedBox(width: screenWidth * 0.10), // Kartlar arası boşluk
                      SizedBox(
                        width: screenWidth * 1,
                        height: screenHeight* 0.60,
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          shadowColor: Colors.grey.withOpacity(0.9),
                          margin: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(screenWidth * 0.05),
                            child: Material(
                              elevation: 10.0,
                              shadowColor: Colors.black,
                              animationDuration: const Duration(milliseconds: 800),
                              borderRadius: BorderRadius.circular(20),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SfRadialGauge(
                                  axes: [
                                    RadialAxis(
                                      pointers: [
                                        RangePointer(
                                          value: widget.totalBalance / 100,
                                          width: 35,
                                          cornerStyle: CornerStyle.bothCurve,
                                          gradient: const SweepGradient(colors: [
                                            Color(0xFFFFC434),
                                            Color(0xFFFF8209)
                                          ]),
                                        ),
                                      ],
                                      axisLineStyle: AxisLineStyle(
                                        thickness: 35,
                                        color: Colors.grey.shade300,
                                      ),
                                      startAngle: 5,
                                      endAngle: 5,
                                      showLabels: true,
                                      showTicks: true,
                                      annotations: [
                                        GaugeAnnotation(
                                          widget: Text(
                                            "Balance",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 25,
                                                color: Colors.black),
                                          ),
                                          angle: 270,
                                          positionFactor: 0,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )








            ],
            ),
          );
        },
      ),
    );
  }
}
