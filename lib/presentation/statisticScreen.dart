import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:budget_family/presentation/StatisticsBloc/statistics_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as charts;
import 'package:syncfusion_flutter_gauges/gauges.dart' as gauges;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    var d = AppLocalizations.of(context)!; // localization için

    return Scaffold(

      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.indigo),
        ),
        title: Text(
       d.expense_statistics,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Colors.indigo,
          ),
        ),
      ),
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
            print(monthlyExpenses);
          }

          if (state is PieChartSuccessState) {
            PieChartdataMap = state.chartData;
          }

          return SingleChildScrollView(
            child: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildButton(
                        d.category,
                        Icons.category, // Icon for the Category button
                        Colors.blue, // Gradient start color
                        Colors.lightBlueAccent, // Gradient end color
                            () {
                          setState(() {
                            currentCard = "category";
                          });
                          context.read<StatisticsBloc>().add(GetPieChart());
                        },
                        screenWidth * 0.25, // Button width
                      ),

                      _buildButton(
                        d.monthly,
                        Icons.calendar_today, // Icon for the Month button
                        Colors.green, // Gradient start color
                        Colors.lightGreenAccent, // Gradient end color
                            () {
                          setState(() {
                            currentCard = "month";
                          });
                          context.read<StatisticsBloc>().add(GetMonthlyChart());
                        },
                        screenWidth * 0.25, // Button width
                      ),


                      _buildButton(
                        d.balance,
                        Icons.account_balance_wallet, // Icon for the Balance button
                        Colors.orange, // Gradient start color
                        Colors.redAccent, // Gradient end color
                            () {
                          setState(() {
                            currentCard = "balance";
                          });
                        },
                        screenWidth * 0.25, // Button width
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



  Widget _buildButton(String title, IconData icon, Color startColor, Color endColor, VoidCallback onPressed, double width) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.5),
          backgroundColor: Colors.transparent, // Transparent to show gradient from Ink
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [startColor, endColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: double.infinity, // Take up all available width
            height: 50, // Set height for the button
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }









//Balance Chart

  Widget _buildBalanceCard(double screenWidth, double screenHeight) {
    var d = AppLocalizations.of(context)!;
    return SizedBox(
      width: screenWidth * 1,
      height: screenHeight * 0.70,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        shadowColor: Colors.grey.withOpacity(0.9),
        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Padding(
          padding: const EdgeInsets.all(7.0),


          // Balance Radial Gauge
            child:   Material(
                elevation: 10.0,
                shadowColor: Colors.black,
                animationDuration: const Duration(milliseconds: 900),
                borderRadius: BorderRadius.circular(25),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(screenWidth * 0.05),
                      child: gauges.SfRadialGauge(
                        axes: [
                          gauges.RadialAxis(
                            maximum: 100,
                            ranges: <gauges.GaugeRange>[
                              gauges.GaugeRange(startValue: 0, endValue: 35, color: Colors.red),
                              gauges.GaugeRange(startValue: 35, endValue: 70, color: Colors.orangeAccent),
                              gauges.GaugeRange(startValue: 70, endValue: 100, color: Colors.green),
                            ],
                            pointers: <gauges.GaugePointer>[
                              gauges.NeedlePointer(
                                value: widget.totalBalance / 100,
                                enableAnimation: true,
                                animationDuration: 800,
                              ),
                            ],
                            axisLineStyle: gauges.AxisLineStyle(
                              thickness: 35,
                              color: Colors.grey.shade300,
                            ),
                            annotations: [
                              gauges.GaugeAnnotation(
                                widget: Text(
                                  d.balance,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                                angle: 360,
                                positionFactor: 0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildBalanceInfoRow(Colors.red, d.high_risk_reduce_expenses),
                          const SizedBox(height: 5),
                          _buildBalanceInfoRow(Colors.orangeAccent,d.moderate_risk_monitor_expenses),
                          const SizedBox(height: 5),
                          _buildBalanceInfoRow(Colors.green, d.safe_balance_status_is_stable),
                        ],
                      ),
                    ),
                  ],
                ),
              ),


        ),
      ),
    );
  }


  Widget _buildBalanceInfoRow(Color color, String text) {
    return Row(
      children: [
        Icon(Icons.circle, color: color, size: 15),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }



  // PieChart Card
  Widget _buildPieChartCard(double screenWidth, double screenHeight) {
    var d = AppLocalizations.of(context)!;
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
                centerText: d.expenses,
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
    var d = AppLocalizations.of(context)!;
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
            animationDuration: const Duration(milliseconds: 400),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: charts.SfCartesianChart(
                borderWidth: 0.9,
                plotAreaBorderWidth: 0,
                primaryXAxis: charts.CategoryAxis(isVisible: true,),
                primaryYAxis: charts.NumericAxis(
                  isVisible: true,
                  minimum: 0,
                  interval: 80,
                  title: charts.AxisTitle(text: d.total_expense),
                ),

                series: <charts.CartesianSeries>[
                  charts.ColumnSeries<MapEntry<String, double>, String>(
                    dataSource: monthlyExpenses.entries.toList(),
                    width: 0.3,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    xValueMapper: (MapEntry<String, double> data, _) => data.key,
                    yValueMapper: (MapEntry<String, double> data, _) => data.value,
                    pointColorMapper: (MapEntry<String, double> data, int index) {
                      List<Color> colors = [
                        Colors.red, Colors.blueAccent, Colors.green,
                        Colors.orange, Colors.purple,Colors.yellow, Colors.pink, Colors.teal, Colors.brown, Colors.cyan,
                      ];
                      return colors[index % colors.length];
                    },
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
