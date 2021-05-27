import 'package:cuchi/src/screens/screen.dart';

import 'package:cuchi/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

import 'src/bloc/bloc.g.dart';

void main() async {
  await DotEnv.load(fileName: '.env');

  runApp(
    MyApp(),
  );

  // runApp(TestScale());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Wakelock.enable();

    return MultiBlocProvider(
      providers: [
        BlocProvider<DetailPlaceBloc>(
          create: (BuildContext context) => DetailPlaceBloc(),
        ),
        BlocProvider<MapBloc>(
          create: (BuildContext context) => MapBloc(),
        ),
        BlocProvider<TimelineInputBloc>(
          create: (BuildContext context) => TimelineInputBloc(),
        ),
        BlocProvider<ScaleBarBloc>(
          create: (BuildContext context) => ScaleBarBloc(),
        ),
        BlocProvider<TimelineBarBloc>(
          create: (BuildContext context) => TimelineBarBloc(),
        ),
        BlocProvider<NearByBloc>(
          create: (BuildContext context) => NearByBloc(),
        ),
        BlocProvider<TabBarTypeBloc>(
          create: (BuildContext context) => TabBarTypeBloc(),
        ),
        BlocProvider<UserInforBloc>(
          create: (BuildContext context) => UserInforBloc(),
        ),
        BlocProvider<SearchBloc>(
          create: (BuildContext context) => SearchBloc(),
        ),
        BlocProvider<ZoomInOutBloc>(
          create: (BuildContext context) => ZoomInOutBloc(),
          child: Container(),
        ),
        BlocProvider<ListLocationBloc>(
          create: (BuildContext context) => ListLocationBloc(),
        ),
        BlocProvider<ButtonMapBloc>(
          create: (BuildContext context) => ButtonMapBloc(),
        ),
        BlocProvider<DetailMapBloc>(
          create: (BuildContext context) => DetailMapBloc(),
        ),
        BlocProvider<MapNavigatorBloc>(
          create: (BuildContext context) => MapNavigatorBloc(),
        ),
        BlocProvider<ListLocationHistoryBloc>(
          create: (BuildContext context) => ListLocationHistoryBloc(),
        ),
        BlocProvider<MapDetailBloc>(
          create: (BuildContext context) => MapDetailBloc(),
        ),
        BlocProvider<PinLocationBloc>(
          create: (BuildContext context) => PinLocationBloc(),
        ),
        BlocProvider<ButtonInSearchBloc>(
          create: (BuildContext context) => ButtonInSearchBloc(),
        ),
        BlocProvider<ButtonIntDetailBloc>(
          create: (BuildContext context) => ButtonIntDetailBloc(),
        ),
        BlocProvider<ToolMapBloc>(
          create: (BuildContext context) => ToolMapBloc(),
        ),
        BlocProvider<FilterRadiusBloc>(
          create: (BuildContext context) => FilterRadiusBloc(),
        ),
        BlocProvider<PinMapBloc>(
          create: (BuildContext context) => PinMapBloc(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: LightTheme.themeCustom,
        home: CheckingScreen(),
        routes: {
          CheckingScreen.routeName: (ctx) => CheckingScreen(),
          ShareLocationScreen.routeName: (ctx) => ShareLocationScreen(),
          NearByLocationScreen.routeName: (ctx) => NearByLocationScreen(),
          MapOverviewScreen.routeName: (ctx) => MapOverviewScreen(),
          MapOverviewDetail.routeName: (ctx) => MapOverviewDetail(),
          AddPlaceScreen.routeName: (ctx) => AddPlaceScreen(),
          UserInformationScreen.routeName: (ctx) => UserInformationScreen(),
          ListHistoryScreen.routeName: (ctx) => ListHistoryScreen(),
          DetailPlaceScreen.routeName: (ctx) => DetailPlaceScreen(),
          GoogleMapPinLocationScreen.routeName: (ctx) =>
              GoogleMapPinLocationScreen(),
        },
      ),
    );
  }
}
