import 'dart:async';
import 'dart:collection';

import 'package:covid_tracker_app/global/covid/bloc/covid_bloc.dart';
import 'package:covid_tracker_app/global/covid/components/placeholder_box.dart';
import 'package:covid_tracker_app/global/covid/components/summary.dart';
import 'package:covid_tracker_app/global/covid/covid_service.dart';
import 'package:covid_tracker_app/global/fcm/bloc/fcm_bloc.dart';
import 'package:covid_tracker_app/global/location/bloc/location_bloc.dart';
import 'package:covid_tracker_app/global/ping/bloc/ping_bloc.dart';
import 'package:covid_tracker_app/global/theme/theme_service.dart';
import 'package:covid_tracker_app/res.dart';
import 'package:covid_tracker_app/ui/chatbot/bot_page.dart';
import 'package:covid_tracker_app/ui/expanded/expanded_page.dart';
import 'package:covid_tracker_app/ui/notification/notification_page.dart';
import 'package:covid_tracker_app/ui/settings/settings_page.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as Map;
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:easy_localization/easy_localization.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _controllerCompleter = Completer();
  LocationData currentLocationData;

  String title = "";
  String location = "";

  final Set<Map.Marker> _markers = HashSet<Map.Marker>();
  final Set<Map.Circle> _circles = HashSet<Map.Circle>();
  static const BorderRadius circular = BorderRadius.only(
      topRight: const Radius.circular(30.0),
      topLeft: const Radius.circular(30.0));

  // Circular GoogleMap Theme
  final double radius = 30;
  final Color circleColor = Colors.blue;
  final int strokeWidth = 3;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.bloc<LocationBloc>().add(InitLocation());
    context.bloc<CovidBloc>().add(GetDailyData("lb"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildLocationBloc(),
    );
  }

  BlocConsumer<LocationBloc, LocationState> buildLocationBloc() {
    return BlocConsumer<LocationBloc, LocationState>(
      buildWhen: (previous, current) {
        return current.needBuild();
      },
      listener: (BuildContext context, state) async {
        if (state is LocationInitial) {
          context
              .bloc<LocationBloc>()
              .add(GetLocation(context.locale.languageCode));
        }
        if (state is LocationLoaded) {
          onLocationLoaded(context, state);
        } else if (state is LocationUpdated) {
          onLocationUpdated(state);
        }
      },
      builder: (BuildContext context, state) {
        if (state is LocationInitial || state is LocationLoading) {
          return buildLoadingUI();
        } else if (state is LocationLoaded) {
          return buildMapAndAppBar();
        } else if (state is LocationError) {
          return buildErrorUI();
        } else {
          return Container();
        }
      },
    );
  }

  void onLocationUpdated(LocationUpdated state) {
    currentLocationData = state.locationData;
    LatLng currentLocation =
        LatLng(state.locationData.latitude, state.locationData.longitude);
    buildMapControllerAndNavigate(currentLocation);

    setState(() {
      title = state.placemarks.first.country;
      location = state.placemarks.first.subAdministrativeArea +
          ", " +
          state.placemarks.first.street;
    });
  }

  Widget buildAppBar() {
    return Container(
        height: 80,
        child: AppBar(
          actionsIconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          elevation: 0.0,
          leading: buildLeadingMenuBtn(),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Ink(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [IconButtonTheme.shadow],
                ),
                child: IconButton(
                  splashRadius: 15.0,
                  onPressed: notificationButtonPressed,
                  icon: SvgPicture.asset(Res.pastel_notification),
                ),
              ),
            ),
            buildMoreMenuBtn(),
          ],
          title: buildTitle(),
        ));
  }

  GoogleMap buildMap() {
    return GoogleMap(
        markers: _markers,
        circles: _circles,
        onMapCreated: (GoogleMapController controller) {
          _controllerCompleter.complete(controller);
        },
        zoomControlsEnabled: false,
        mapType: MapType.terrain,
        initialCameraPosition:
            const CameraPosition(target: const LatLng(0, 0)));
  }

  Widget buildTitle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [IconButtonTheme.shadow],
      ),
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SvgPicture.asset(
            Res.location,
            height: 26.0,
          ),
          Padding(padding: EdgeInsets.all(5.0)),
          Flexible(
            child: Text(title, style: Theme.of(context).textTheme.bodyText2),
          ),
        ],
      ),
      //  decoration: AppBarItemStyle.boxDecoration,
    );
  }

  Widget buildLeadingMenuBtn() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [IconButtonTheme.shadow],
        ),
        child: IconButton(
          splashRadius: 15.0,
          onPressed: robotButtonOnPressed,
          icon: SvgPicture.asset(Res.pastel_robot),
        ),
      ),
    );
  }

  Widget buildMoreMenuBtn() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [IconButtonTheme.shadow],
        ),
        child: IconButton(
          splashRadius: 15.0,
          onPressed: settingsButtonPressed,
          icon: SvgPicture.asset(Res.pastel_settings),
        ),
      ),
    );
  }

  Stack buildStackUI() {
    return Stack(
      children: [
        buildMap(),
        buildAppBar(),
      ],
    );
  }

  Widget buildLoadingUI() {
    return Center(
      child: Lottie.asset(Res.location_anim),
    );
  }

  Widget buildErrorUI() {
    return Center(
      child: Lottie.asset(Res.error_anim),
    );
  }

  Widget buildMapAndAppBar() {
    return SlidingUpPanel(
      panel: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20),
          buildDragHandler(),
          SizedBox(height: 10),
          buildLocalArea(),
          SizedBox(height: 20),
          BlocBuilder<CovidBloc, CovidState>(
            buildWhen: (previous, current) {
              return current is CovidDSLoaded;
            },
            builder: (BuildContext context, state) {
              if (state is CovidDSLoaded) {
                return buildDailySummary(state.dailySummary);
              } else if (state is CovidError) {
                return buildServiceNotAvailable();
              } else {
                return PlaceholderBox(height: 50);
              }
            },
          ),
          SizedBox(height: 50),
          buildNavigationButton(),
        ],
      ),
      borderRadius: circular,
      boxShadow: [SlidingPanelTheme.shadow],
      body: Stack(
        children: [
          buildMap(),
          buildAppBar(),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: FloatingActionButton(
                  onPressed: () {
                    buildMapControllerAndNavigate(LatLng(
                        currentLocationData.latitude,
                        currentLocationData.longitude));
                  },
                  child: Icon(Icons.location_searching_rounded),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void addCircularMarker(LatLng location) {
    _circles.add(Circle(
        center: location,
        circleId: CircleId("marker_id${_markers.length}"),
        radius: radius,
        strokeWidth: strokeWidth,
        strokeColor: circleColor.withOpacity(0.7),
        fillColor: circleColor.withOpacity(0.5)));
  }

  void addMarker(LatLng location) async {
    _markers.add(Map.Marker(
        flat: true,
        // icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(48,48)), Res.my_marker),
        position: location,
        markerId: MarkerId("marker_id${_markers.length}")));
  }

  Widget buildCollapsedWidget() {
    return Container(
      child: ClipRRect(
        borderRadius: circular,
        child: Icon(Icons.drag_handle_rounded),
      ),
    );
  }

  Widget buildDailySummary(DailySummary summary) {
    return SizedBox(
      child: Container(
        padding: const EdgeInsets.all(18.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Color(0xff222B45),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListTile(
                    leading: CircleAvatar(
                        child: Center(
                            child: SvgPicture.asset(Res.pastel_daily_cases))),
                    title: Text("daily_summary".tr(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                    subtitle: Text(
                      DateFormat('EEEE d', context.locale.languageCode)
                          .format(DateTime.now()),
                      style: TextStyle(color: Colors.white70),
                    )),
                Divider(
                  color: Colors.white24,
                  height: 30,
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),
                Summary(dailySummary: summary),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDragHandler() {
    return Center(
      child: Icon(Icons.drag_handle_rounded),
    );
  }

  Widget buildNavigationButton() {
    return Align(
        alignment: Alignment.center,
        child: FlatButton(
          shape: CircleBorder(),
          onPressed: navigationButtonPressed,
          color: Colors.grey[200],
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Icon(Icons.expand_more_rounded),
          ),
        ));
  }

  Widget buildLocalArea() {
    return ListTile(
      title: Text(
        location,
        textAlign: TextAlign.start,
        style: Theme.of(context).textTheme.subtitle1,
      ),
      trailing: CircleAvatar(
        child: SvgPicture.asset(Res.pastel_place),
      ),
    );
  }

  Widget buildServiceNotAvailable() {
    return Center(
        child: ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.red,
        child: Icon(Icons.error_outline, color: Colors.white),
      ),
      title: Text("Service Not Available !"),
    ));
  }

  void navigationButtonPressed() => Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) => ExpandedPage()));

  // void navigationButtonPressed() => navigateToPage(ExpandedPage());

  void settingsButtonPressed() => Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) => SettingsPage()));

  void robotButtonOnPressed() => Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) => ChatBotPage()));

  void notificationButtonPressed() => Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) => NotificationPage()));

  void onLocationLoaded(BuildContext context, LocationLoaded state) async {
    LatLng currentLocation =
        LatLng(state.locationData.latitude, state.locationData.longitude);

    currentLocationData = state.locationData;
    buildMapControllerAndNavigate(currentLocation);
    // init fcm
    beginFCMInitialization(context);
    // init ping
    beginPingProtocol(context, state.locationData);
    // register location update
    registerLocationUpdate();
    // update UI values
    setState(() {
      // add marker on map
      addMarker(currentLocation);
      addCircularMarker(currentLocation);
      title = state.placemarks.first.country;
      location = state.placemarks.first.subAdministrativeArea +
          "," +
          state.placemarks.first.street;
    });
  }

  void buildMapControllerAndNavigate(LatLng currentLocation) async {
    GoogleMapController _controller = await _controllerCompleter.future;

    // animate to current location and zoom
    CameraPosition newCameraPosition = CameraPosition(
        //  bearing: 192.8334901395799,
        target: currentLocation,
        //tilt: 59.440717697143555,
        zoom: 19.151926040649414);

    _controller
        .animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

  void beginPingProtocol(BuildContext context, LocationData locationData) {
    context.bloc<PingBloc>().add(BeginPingEvent(locationData));
    context.bloc<PingBloc>().add(PingAllDevices());
  }

  void beginFCMInitialization(BuildContext context) {
    context.bloc<FcmBloc>().add(InitializeFCM(context));
  }

  void registerLocationUpdate() {
    Timer.periodic(Duration(seconds: 30), (timer) {
      print("Updating Location !");
      context
          .bloc<LocationBloc>()
          .add(GetLocationUpdate(context.locale.languageCode));
    });
  }

  Future<Widget> buildPageAsync(Widget widget) async {
    return Future.microtask(() {
      return widget;
    });
  }

// void navigateToPage(Widget widget) async {
//   var page = await buildPageAsync(widget);
//   var route = MaterialPageRoute(builder: (_) => page, maintainState: false);
//   Navigator.push(context, route);
// }

}
