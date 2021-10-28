import 'package:coddr/common/constants/size_constants.dart';
import 'package:coddr/common/extensions/size_extensions.dart';
import 'package:coddr/common/screen_utils/screen_util.dart';
import 'package:coddr/dependencies/get_it.dart';
import 'package:coddr/domain/entities/user_model.dart';
import 'package:coddr/domain/usecases/get_cf_user.dart';
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
  UserModel userModel;
  GetCFUser getCFUser;

  @override
  void initState() {
    _contestListingBloc = getItInstance<ContestListingBloc>();
    _profileBloc = getItInstance<ProfileBloc>();
    _profileBloc.add(FetchProfileData());
    getCFUser = getItInstance<GetCFUser>();
    super.initState();
  }

  @override
  void dispose() {
    _contestListingBloc.close();
    _profileBloc.close();
    super.dispose();
  }

  Future<void> _getData() async {
    setState(() {
      _profileBloc.add(FetchProfileData());
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    print(screenWidth);
    print(screenHeight);
    ScreenUtil.init(height: screenHeight, width: screenWidth);
    getCFUser(["mr_cchef"]);

    Widget leftAppBarWidget = InkWell(
      onTap: () {
        Scaffold.of(context).openDrawer();
      },
      child: Icon(Icons.menu, color: Colors.black),
    );

    Widget middleAppBarWidget = Padding(
      padding: EdgeInsets.only(top: Sizes.dimen_6.h),
      child: Text('Coddr', style: Theme.of(context).textTheme.headline5),
    );

    Widget rightAppBarWidget = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Sizes.dimen_16.w,
        vertical: Sizes.dimen_8.h,
      ),
      child: Icon(
        Icons.notifications_active_outlined,
        color: Colors.black,
      ),
    );

    return BlocProvider<ContestListingBloc>.value(
      value: _contestListingBloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CoddrAppBar(
          leftWidget: leftAppBarWidget,
          middleWidget: middleAppBarWidget,
          rightWidget: rightAppBarWidget,
        ),
        body: RefreshIndicator(
          onRefresh: _getData,
          child: BlocBuilder<ProfileBloc, ProfileState>(
            bloc: _profileBloc,
            builder: (context, state) {
              if (state is ProfileLoding) {
                return Center(child: CircularProgressIndicator());
              }
              
              if (state is ProfileError) {
                return Center(child: Text(state.message));
              }
              
              final curState = (state as ProfileLoaded);
              userModel = curState.userModel;
              //print("HAHA" + userModel.imageUrl.toString());
              return Padding(
                padding: EdgeInsets.only(
                    left: Sizes.dimen_16.w,
                    right: Sizes.dimen_16.w,
                    top: Sizes.dimen_12.h),
                child: Column(
                  children: [
                    TopHomeScreen(
                      displayName: userModel.displayName,
                      imageUrl: userModel.imageUrl,
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
          ),
        ),
        drawer: MainDrawer(),
      ),
    );
  }
}
