import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:budget_family/presentation/StatisticsBloc/statistics_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as charts;
import 'package:syncfusion_flutter_gauges/gauges.dart' as gauges;

import '../utils/utils.dart';

class ExpenseStatistics extends StatefulWidget {
  final double totalBalance;
  const ExpenseStatistics({super.key, required this.totalBalance});

  @override
  State<ExpenseStatistics> createState() => _ExpenseStatisticsState();
}

class _ExpenseStatisticsState extends State<ExpenseStatistics> {
  Map<String, double> PieChartdataMap = {};
  Map<String, double> monthlyExpenses = {};


  String currentCard = "balance";

  @override
  Widget build(BuildContext context) {

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

          if (state is MonthlyChartSuccessState) {
            monthlyExpenses = state.monthlyData;
          }

          if (state is PieChartSuccessState) {
            PieChartdataMap = state.chartData;
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.05),
                const Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 5),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Expense Statistics 📊",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.indigo,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildButton(
                        "Category",
                        Colors.blue,
                            () {
                          setState(() {
                            currentCard = "category";
                          });
                          context.read<StatisticsBloc>().add(GetPieChart());
                        },
                        screenWidth * 0.25,
                      ),
                      _buildButton(
                        "Month",
                        Colors.green,
                            () {
                          setState(() {
                            currentCard = "month";
                          });
                          context.read<StatisticsBloc>().add(GetMonthlyChart());
                        },
                        screenWidth * 0.22,
                      ),
                      _buildButton(
                        "Week",
                        Colors.orange,
                            () {
                          setState(() {
                            currentCard = "week";
                          });
                          // Weekly chart event can be added here
                        },
                        screenWidth * 0.22,
                      ),
                      _buildButton(
                        "Balance", Colors.purple,
                            () {setState(() {
                            currentCard = "balance";
                           });
                        },
                        screenWidth * 0.24,
                      ),

                    ],
                  ),
                ),
                const Divider(),
                SizedBox(height: screenHeight * 0.03),

                if (currentCard == "category") _buildPieChartCard(screenWidth, screenHeight),
                if (currentCard == "month") _buildMonthChartCard(screenWidth, screenHeight),
                if (currentCard == "balance") _buildBalanceCard(screenWidth, screenHeight),

              ],
            ),
          );
        },
      ),
    );
  }



  Widget _buildButton(String title, Color color, VoidCallback onPressed, double width) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
            side: BorderSide(color: Colors.black38, width: 1.15),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: color,
          ),
        ),
      ),
    );
  }






  //Balance  Chart
  Widget _buildBalanceCard(double screenWidth, double screenHeight) {
    return SizedBox(
      width: screenWidth * 1,
      height: screenHeight * 0.60,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        shadowColor: Colors.grey.withOpacity(0.9),
        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            elevation: 10.0,
            shadowColor: Colors.black,
            animationDuration: const Duration(milliseconds: 800),
            borderRadius: BorderRadius.circular(25),
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: gauges.SfRadialGauge(
                axes: [
                  gauges.RadialAxis(
                    pointers: [
                      gauges.RangePointer(
                        value: widget.totalBalance / 100,
                        width: 35,
                        cornerStyle: gauges.CornerStyle.bothCurve,
                        gradient: const SweepGradient(colors: [
                          Color(0xFFFFC434),
                          Color(0xFFFF8209)
                        ], stops: [0.1, 0.75]),
                      ),
                    ],
                    axisLineStyle: gauges.AxisLineStyle(
                      thickness: 35,
                      color: Colors.grey.shade300,
                    ),
                    annotations: const [
                      gauges.GaugeAnnotation(
                        widget: Text(
                          "Balance",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 25,
                            color: Colors.black,
                          ),
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
    );
  }





  // PieChart Card
  Widget _buildPieChartCard(double screenWidth, double screenHeight) {
    return SizedBox(
      width: screenWidth * 1,
      height: screenHeight * 0.60,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        shadowColor: Colors.grey.withOpacity(0.8),
        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Material(
            elevation: 10.0,
            shadowColor: Colors.black,
            animationDuration: const Duration(milliseconds: 800),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: PieChart(
                dataMap: PieChartdataMap,
                animationDuration: const Duration(milliseconds: 800),
                chartLegendSpacing: screenWidth * 0.18,
                chartRadius: screenWidth * 0.5,
                colorList: colorList,
                initialAngleInDegree: 45,
                chartType: ChartType.ring,
                ringStrokeWidth: screenWidth * 0.20,
                centerText: "Expenses",
                centerTextStyle: TextStyle(
                  fontSize: screenWidth * 0.036,
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
                    fontSize: 14,
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
    );
  }







  // Monthly Chart Card
  Widget _buildMonthChartCard(double screenWidth, double screenHeight) {
    return SizedBox(
      width: screenWidth * 1,
      height: screenHeight * 0.60,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        shadowColor: Colors.grey.withOpacity(0.9),
        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            elevation: 10.0,
            shadowColor: Colors.black,
            animationDuration: const Duration(milliseconds: 800),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: charts.SfCartesianChart(
                borderWidth: 0.5,
                plotAreaBorderWidth: 0,
                primaryXAxis: charts.CategoryAxis(isVisible: true,),
                primaryYAxis: charts.NumericAxis(
                  isVisible: true,
                  minimum: 0,
                  interval: 40, // Daha büyük aralıklar için
                  title: charts.AxisTitle(text: 'Total Expenses'),
                ),

                series: <charts.CartesianSeries>[
                  charts.ColumnSeries<MapEntry<String,double>, String>(
                    dataSource: monthlyExpenses.entries.toList(),
                    width: 0.8,
                    xValueMapper: (MapEntry<String,double> data, _) => data.key,
                    yValueMapper: (MapEntry<String,double> data, _) => data.value,
                    color: Colors.indigo,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }





}
