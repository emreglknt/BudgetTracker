import 'package:bloc/bloc.dart';
import 'package:budget_family/data/model/pieChartModel.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../data/repository/main_repo.dart';

part 'statistics_event.dart';
part 'statistics_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  StatisticsBloc() : super(StatisticsInitial()) {
    final _mainRepo = MainRepository();



      on<GetPieChart>((event, emit) async {
        emit(ChartLoadingState());
        await emit.forEach(
          _mainRepo.getPieChartList(),
          onData: (Either<String, Map<String,double>> result) => result.fold(
                (error) => ErrorState(error),
                (chartData) => PieChartSuccessState(chartData),
          ),
          onError: (_, __) => ErrorState('Bir hata oluştu.'),
        );
      });





  }

}
