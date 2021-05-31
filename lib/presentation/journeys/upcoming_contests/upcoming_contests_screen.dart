import 'package:coddr/common/constants/image_constants.dart';
import 'package:coddr/common/constants/size_constants.dart';
import 'package:coddr/common/screen_utils/screen_util.dart';
import 'package:coddr/dependencies/get_it.dart';
import 'package:coddr/presentation/blocs/bloc/contest_listing_bloc.dart';
import 'package:coddr/presentation/journeys/upcoming_contests/contest_card.dart';
import 'package:coddr/presentation/themes/app_color.dart';
import 'package:coddr/presentation/widgets/CoddrAppBar.dart';
import 'package:coddr/presentation/widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:coddr/common/extensions/size_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpcomingContestsScreen extends StatelessWidget {
  static const routeName = '/upcoming_contests_screen';
  ContestListingBloc _contestListingBloc;

  @override
  Widget build(BuildContext context) {
    _contestListingBloc = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CoddrAppBar(),
      drawer: MainDrawer(),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Sizes.dimen_16.w,
          vertical: Sizes.dimen_8.h,
        ),
        child: BlocBuilder<ContestListingBloc, ContestListingState>(
          bloc: _contestListingBloc,
          builder: (context, state) {
            if (state is ContestListFetchingState)
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black,
                ),
              );
            else if (state is ContestListFetchedState)
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Upcoming Contests',
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              .copyWith(fontSize: Sizes.dimen_26.w),
                        ),
                        Spacer(),
                        Image.asset(
                          Images.codeforcesLogo,
                          //fit: BoxFit.fitHeight,
                          height: Sizes.dimen_48.w,
                          width: Sizes.dimen_48.w,
                        ),
                      ],
                    ),
                    SizedBox(height: Sizes.dimen_8.h),
                    //ListView.builder(itemBuilder: itemBuilder)
                    ContestCard(
                        title: 'Educational Codeforces Round 101',
                        color: AppColor.lightGreen,
                        time: '8:05 - 10-20',
                        date: '30/05/2021'),
                    ContestCard(
                        title: 'Codeforces Round 723 (Div 2)',
                        color: AppColor.lightRed,
                        time: '8:05 - 10-20',
                        date: '30/05/2021'),
                    ContestCard(
                        title: 'Educational Codeforces Round 102',
                        color: AppColor.lightViolet,
                        time: '8:05 - 10-20',
                        date: '30/05/2021'),
                    ContestCard(
                        title: 'Codeforces Round 724 (Div 2)',
                        color: AppColor.lightBrown,
                        time: '8:05 - 10-20',
                        date: '30/05/2021'),
                  ],
                ),
              );
            else if (state is ContestListErrorState) {
              return Center(
                child: Text("${state.appErrorType}"),
              );
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
