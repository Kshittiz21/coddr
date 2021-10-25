import 'package:coddr/common/constants/size_constants.dart';
import 'package:coddr/common/extensions/size_extensions.dart';
import 'package:coddr/domain/entities/curated_contest_model.dart';
import 'package:coddr/presentation/journeys/RankList/RankListPage.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CuratedContestCard extends StatefulWidget {
  final CuratedContestModel curatedContestModel;

  const CuratedContestCard({Key key, this.curatedContestModel})
      : super(key: key);
  @override
  _CuratedContestCardState createState() => _CuratedContestCardState();
}

class _CuratedContestCardState extends State<CuratedContestCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RankListPage()));
      },
      child: Card(
        shape: CircleBorder(),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Sizes.dimen_20.w),
              color: HexColor('EED1D1')),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(Sizes.dimen_8.w),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text('Total Prize'),
                        Text('₹ ${widget.curatedContestModel.prize}'),
                      ],
                    ),
                    Spacer(),
                    Column(
                      children: [
                        Text(
                          'Contest Id',
                          style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(widget.curatedContestModel.contestId),
                      ],
                    ),
                    Spacer(),
                    Column(
                      children: [
                        Text('Entry fees'),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Sizes.dimen_8.w),
                              color: Colors.green,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(Sizes.dimen_4.w),
                              child: Text(
                                '₹ ${widget.curatedContestModel.entryFees}',
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              new LinearPercentIndicator(
                animation: true,
                lineHeight: Sizes.dimen_8.w,
                animationDuration: 2000,
                percent: 0.4,
                // center: Text("40"),
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: Colors.red[600],
                backgroundColor: Colors.grey[300],
              ),
              Padding(
                padding: EdgeInsets.all(Sizes.dimen_8.w),
                child: Row(
                  children: [
                    Text(
                        '${int.parse(widget.curatedContestModel.totalSpots) - int.parse(widget.curatedContestModel.filledSpots)} spots left'),
                    Spacer(),
                    Text('${widget.curatedContestModel.totalSpots} spots'),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
