import 'package:bloc/bloc.dart';
import 'package:coddr/domain/entities/curated_contest_model.dart';
import 'package:coddr/domain/entities/fetch_curated_contest_argument.dart';
import 'package:coddr/domain/usecases/fetch_curated_contest.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'curated_contest_event.dart';
part 'curated_contest_state.dart';

class CuratedContestBloc
    extends Bloc<CuratedContestEvent, CuratedContestState> {
  FetchCuratedContest fetchCuratedContest;

  CuratedContestBloc({@required this.fetchCuratedContest})
      : super(CuratedContestInitial());

  @override
  Stream<CuratedContestState> mapEventToState(
      CuratedContestEvent event) async* {
    if (event is FetchCuratedContestEvent) {
      yield CuratedContestFetchingState();

      final eitherResponse =
          await fetchCuratedContest(event.fetchCuratedContestArgument);

      yield eitherResponse.fold(
          (appError) => CuratedContestErrorState("API failed"),
          (curatedContestList) => CuratedContestFetchedState(
              curatedContestList: curatedContestList));
    }
  }
}
