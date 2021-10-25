import 'package:coddr/common/constants/size_constants.dart';
import 'package:coddr/common/extensions/size_extensions.dart';
import 'package:coddr/presentation/journeys/curated_contests/curated_contests.dart';
import 'package:flutter/material.dart';

class ContestCard extends StatelessWidget {
  final String title;
  final Color color;
  final String time;
  final String date;
  final int contestId;
  final String platformId;

  ContestCard({
    @required this.title,
    @required this.color,
    @required this.time,
    @required this.date,
    @required this.contestId,
    @required this.platformId,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context)
          .pushNamed(CuratedContests.routeName, arguments: {
        'contestId': contestId,
        'platformId': platformId,
      }),
      child: Container(
        height: Sizes.dimen_100.w,
        padding: EdgeInsets.symmetric(
          vertical: Sizes.dimen_12.w,
          horizontal: Sizes.dimen_14.w,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(Sizes.dimen_24.w),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontSize: Sizes.dimen_16.w),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
            Spacer(),
            Row(
              children: [
                Text(
                  time,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Spacer(),
                Text(
                  date,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
