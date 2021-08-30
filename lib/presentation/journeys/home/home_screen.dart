import 'package:coddr/common/constants/size_constants.dart';
import 'package:coddr/common/extensions/size_extensions.dart';
import 'package:coddr/common/screen_utils/screen_util.dart';
import 'package:coddr/dependencies/get_it.dart';
import 'package:coddr/domain/entities/user_model.dart';
import 'package:coddr/presentation/blocs/contest_listing/contest_listing_bloc.dart';
import 'package:coddr/presentation/blocs/profile/profile_bloc.dart';
import 'package:coddr/presentation/journeys/home/platform_grid.dart';
import 'package:coddr/presentation/widgets/CoddrAppBar.dart';
import 'package:coddr/presentation/widgets/custom_bottom_navigation_bar.dart';
import 'package:coddr/presentation/widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'top_home_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ContestListingBloc _contestListingBloc;
  ProfileBloc _profileBloc;

  @override
  void initState() {
    _contestListingBloc = getItInstance<ContestListingBloc>();
    _profileBloc = getItInstance<ProfileBloc>();
    _profileBloc.add(FetchProfileData());
    super.initState();
  }

  @override
  void dispose() {
    _contestListingBloc.close();
    _profileBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    print(screenWidth);
    print(screenHeight);
    ScreenUtil.init(height: screenHeight, width: screenWidth);

    return BlocProvider<ContestListingBloc>.value(
      value: _contestListingBloc,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CoddrAppBar(),
          drawer: MainDrawer(),
          body: BlocBuilder<ProfileBloc, ProfileState>(
            bloc: _profileBloc,
            builder: (context, state) {
              if (state is ProfileLoding) {
                return Center(child: CircularProgressIndicator());
              }

              if (state is ProfileError) {
                return Center(child: Text(state.message));
              }

              final curState = (state as ProfileLoaded);
              UserModel userModel = curState.userModel;
              print(userModel);
              return Padding(
                padding: EdgeInsets.only(
                    left: Sizes.dimen_16.w,
                    right: Sizes.dimen_16.w,
                    top: Sizes.dimen_12.h),
                child: Column(
                  children: [
                    TopHomeScreen(
                      displayName: userModel.displayName,
                    ),
                    SizedBox(
                      height: Sizes.dimen_30.w,
                    ),
                    Text(
                      "Get Started with your favourite platform",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Expanded(child: PlatformGrid()),
                    CustomBottomNavigationBar(),
                  ],
                ),
              );
            },
          )),
    );
  }
}
