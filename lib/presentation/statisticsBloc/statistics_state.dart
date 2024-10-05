part of 'statistics_bloc.dart';

@immutable
sealed class StatisticsState {}

final class StatisticsInitial extends StatisticsState {}


class ChartLoadingState extends StatisticsState{}



class PieChartSuccessState extends StatisticsState {
  final Map<String, double> chartData;
  PieChartSuccessState(this.chartData);
}

class ErrorState extends StatisticsState {
  final String error;
  ErrorState(this.error);
}

