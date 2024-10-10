part of 'statistics_bloc.dart';

@immutable
sealed class StatisticsState {}

final class StatisticsInitial extends StatisticsState {}


class ChartLoadingState extends StatisticsState{}


// ---------------------------------

class PieChartSuccessState extends StatisticsState {
  final Map<String, double> chartData;
  PieChartSuccessState(this.chartData);
}




class MonthlyChartSuccessState extends StatisticsState {
  final Map<String, double> monthlyData;
  MonthlyChartSuccessState(this.monthlyData);
}







//-------------------------------------

class ErrorState extends StatisticsState {
  final String error;
  ErrorState(this.error);
}





