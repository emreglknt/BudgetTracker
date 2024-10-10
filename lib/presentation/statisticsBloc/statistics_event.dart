part of 'statistics_bloc.dart';

@immutable
sealed class StatisticsEvent {}


class GetPieChart extends StatisticsEvent{
  GetPieChart();
}


class GetMonthlyChart extends StatisticsEvent{
  GetMonthlyChart();
}