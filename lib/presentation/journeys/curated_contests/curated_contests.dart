import 'package:coddr/common/constants/size_constants.dart';
import 'package:coddr/common/extensions/size_extensions.dart';
import 'package:coddr/dependencies/get_it.dart';
import 'package:coddr/domain/entities/curated_contest_model.dart';
import 'package:coddr/domain/entities/fetch_curated_contest_argument.dart';
import 'package:coddr/domain/entities/user_model.dart';
import 'package:coddr/presentation/blocs/create_curated_contest/create_curated_contest_bloc.dart';
import 'package:coddr/presentation/blocs/curated_contest/curated_contest_bloc.dart';
import 'package:coddr/presentation/journeys/ContestCreate/CreateContest.dart';
import 'package:coddr/presentation/journeys/curated_contests/curated_contest_list.dart';
import 'package:coddr/presentation/journeys/curated_contests/platform_label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CuratedContests extends StatefulWidget {
  static const String routeName = "/curated-contests";
  final int constestId;
  final String platformId;
  final UserModel userModel;
  final DateTime startTime;
  final DateTime endtime;
  final String title;

  const CuratedContests({
    Key key,
    @required this.constestId,
    @required this.platformId,
    @required this.userModel,
    @required this.startTime,
    @required this.endtime,
    @required this.title,
  }) : super(key: key);

  @override
  _CuratedContestsState createState() => _CuratedContestsState();
}

class _CuratedContestsState extends State<CuratedContests> {
  CuratedContestBloc _curatedContestBloc;
  CreateCuratedContestBloc _createCuratedContestBloc;

  @override
  void initState() {
    _curatedContestBloc = getItInstance<CuratedContestBloc>();
    _curatedContestBloc.add(
      FetchCuratedContestEvent(
        fetchCuratedContestArgument: FetchCuratedContestArgument(
          contestId: widget.constestId,
          platfromId: widget.platformId,
        ),
      ),
    );
    _createCuratedContestBloc = getItInstance<CreateCuratedContestBloc>();
    super.initState();
  }

  @override
  void dispose() {
    _curatedContestBloc.close();
    _createCuratedContestBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<CuratedContestModel> publicContest = [], privateContest = [];

    String getNextContestId(String type) {
      String id = widget.constestId.toString() +
          type +
          (publicContest.length + 1).toString();
      return id;
    }

    return BlocBuilder<CuratedContestBloc, CuratedContestState>(
      bloc: _curatedContestBloc,
      builder: (context, state) {
        if (state is CuratedContestFetchingState)
          return Center(
            child: CircularProgressIndicator(),
          );

        if (state is CuratedContestErrorState)
          return Center(
            child: Text(
              state.message,
              style: Theme.of(context).textTheme.headline2,
            ),
          );

        if (state is CuratedContestFetchedState) {
          List<CuratedContestModel> curatedContestList =
              state.curatedContestList;
          curatedContestList.forEach((element) {
            if (element.isPrivate)
              privateContest.add(element);
            else
              publicContest.add(element);
          });
        }

        return Scaffold(
          body: ListView(
            children: [
              PlatformLabel(),
              Padding(
                padding: EdgeInsets.all(Sizes.dimen_8.w),
                child: Row(
                  children: [
                    Text(
                      'Public Contest',
                      style: TextStyle(
                          fontSize: Sizes.dimen_22.w,
                          fontWeight: FontWeight.w600),
                    ),
                    Spacer(),
                    RaisedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateContest(
                                isPrivate: false,
                                parentContestId: widget.constestId,
                                platformId: widget.platformId,
                                userModel: widget.userModel,
                                contestId: getNextContestId("PBL"),
                                startTime: widget.startTime,
                                endtime: widget.endtime,
                                title: widget.title,
                              ),
                            ),
                          );
                        },
                        color: Colors.red[900],
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(Sizes.dimen_20.w)),
                        child: Text(
                          'Create Contest',
                          style: TextStyle(color: Colors.white),
                        ))
                  ],
                ),
              ),
              CuratedContestList(
                curatedContest: publicContest,
                startTime: widget.startTime,
                endtime: widget.endtime,
                title: widget.title,
              ),
              Padding(
                padding: EdgeInsets.all(Sizes.dimen_8.w),
                child: Row(
                  children: [
                    Text(
                      'Private Contest',
                      style: TextStyle(
                          fontSize: Sizes.dimen_22.w,
                          fontWeight: FontWeight.w600),
                    ),
                    Spacer(),
                    RaisedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateContest(
                                isPrivate: true,
                                parentContestId: widget.constestId,
                                platformId: widget.platformId,
                                userModel: widget.userModel,
                                contestId: getNextContestId("PVT"),
                                startTime: widget.startTime,
                                endtime: widget.endtime,
                                title: widget.title,
                              ),
                            ),
                          );
                        },
                        color: Colors.red[900],
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(Sizes.dimen_20.w)),
                        child: Text(
                          'Create Contest',
                          style: TextStyle(color: Colors.white),
                        ))
                  ],
                ),
              ),
              CuratedContestList(
                curatedContest: privateContest,
                startTime: widget.startTime,
                endtime: widget.endtime,
                title: widget.title,
              ),
            ],
          ),
        );
      },
    );
  }
}
