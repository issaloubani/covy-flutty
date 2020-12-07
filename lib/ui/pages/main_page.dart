import 'dart:async';
import 'dart:collection';

import 'package:covid_tracker_app/ui/components/bubble_icon.dart';
import 'package:covid_tracker_app/ui/components/drag_handler.dart';
import 'package:covid_tracker_app/ui/pages/bot_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart' as Geocoder;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as Map;
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';

import '../../res.dart';
import 'drawer_page.dart';

const double DEFAULT_ZOOM = 19.0;

enum MenuActions { changeLanguage, settings, about }

class MainPage extends StatefulWidget {
  final LocationData locationData;

  MainPage({Key key, @required this.locationData}) : super(key: key);

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  final Set<Map.Marker> _markers = HashSet<Map.Marker>();
  final Set<Map.Circle> _circles = HashSet<Map.Circle>();
  final double radius = 30;
  final Color circleColor = Colors.blue;
  final int strokeWidth = 3;

  String area = "";

  AnimationController controller;
  Completer<GoogleMapController> mapController;

  Widget _initAppBar(BuildContext appBarContext) {
    var isLanguageChanged = appBarContext.locale == Locale('en') ? false : true;
    return Container(
      height: 80,
      child: AppBar(
        elevation: 0.0,
        title: FutureBuilder(
          future: _getAddressName(
              widget.locationData.latitude, widget.locationData.longitude),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _areaText(snapshot.data);
            } else if (snapshot.hasError) {
              return _areaText("Error");
            }
            // loading data
            return _areaAnimation();
          },
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        actions: [
          _notificationIcon(),
          _moreIcon(appBarContext, isLanguageChanged),
        ],
        leading: _menuIcon(),
      ),
    );
  }

  Widget _initBottomDrawerSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.2,
      minChildSize: 0.1,
      maxChildSize: 0.47,
      builder: (BuildContext context, _scrollController) {
        return Container(
          decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0)))),
          child: NotificationListener(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowGlow();
              return;
            },
            child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DragHandler(),
                    Flexible(
                      child: DrawerPage(context),
                    )
                  ],
                )),
          ),
        );
      },
    );
  }

  Future<String> _getAddressName(double lat, double lon) async {
    print("Getting address name....");
    try {
      // List<Address> addresses = await Geocoder.google(Config.googleMapsAPIKey,
      //         language: context.locale.languageCode)
      //     .findAddressesFromCoordinates(coordinates);
      // List<Address> addresses =
      //     await Geocoder.local.findAddressesFromCoordinates(coordinates);
      List<Geocoder.Placemark> placemarks =
          await Geocoder.placemarkFromCoordinates(lat, lon,
              localeIdentifier: context.locale.languageCode);
      print("Placemark: ${placemarks.first}");
      //Address first = addresses.first;
      return "${placemarks.first.subAdministrativeArea} ${(context.locale.languageCode == 'ar') ? "،" : ","} ${placemarks.first.country}";
      //  print("Element : ${first.countryCode}"); // LB
      //  print("Element : ${first.subAdminArea}"); // alay
    } catch (e) {
      print("Error Getting address name : type: ${e.runtimeType} $e");
      return "Error";
    }
  }

  // Future<void> _goToLocation(double lat, double lon) async {
  //   print("Lat, Lon: $lat, $lon");
  //   final GoogleMapController controller = await gooMaps.getController();
  //   controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
  //     target: LatLng(lat, lon),
  //     zoom: DEFAULT_ZOOM,
  //   )));
  //   // locationStr = await _getAddressName(lat, lon);
  //   // print("Current Address : $locationStr");
  // }

  @override
  void dispose() {
    mapController.future.then((value) => dispose());
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      vsync: this, //
      duration: Duration(seconds: 1), // the SingleTickerProviderStateMixin
    );
    addCircle(
        LatLng(widget.locationData.latitude, widget.locationData.longitude));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        GoogleMap(
          zoomControlsEnabled: false,
          mapType: MapType.hybrid,
          markers: _markers,
          circles: _circles,
          onMapCreated: (GoogleMapController controller) {
            controller.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                    target: LatLng(widget.locationData.latitude,
                        widget.locationData.longitude),
                    zoom: DEFAULT_ZOOM)));
            mapController.complete(controller);
          },
          initialCameraPosition: CameraPosition(target: LatLng(0, 0)),
          trafficEnabled: true,
        ),
        _initAppBar(context),
        _initBottomDrawerSheet()
      ],
    ));
  }

  _notificationIcon() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Ink(
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        child: IconButton(
          alignment: Alignment.center,
          splashRadius: 15.0,
          onPressed: () {},
          icon: Transform.scale(
            scale: 1.0,
            child: Lottie.asset(Res.notification_anim,
                controller: controller, height: 30.0),
          ),
        ),
      ),
    );
  }

  _menuIcon() {
    return BubbleIcon(
      icon: SvgPicture.asset(Res.robot),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return BotPage();
          },
        ));
      },
    );
  }

  _areaText(String areaText) {
    return Container(
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
            child: Text(areaText, style: Theme.of(context).textTheme.bodyText2
                //     style: TextStyle(fontWeight: Theme.of(context).textTheme.bodyText1.fontWeight, fontSize: 18.0),
                ),
          ),
          Padding(padding: EdgeInsets.all(5.0)),
          PopupMenuButton(
            offset: Offset(10, 800),
            child: Icon(Icons.keyboard_arrow_down),
            itemBuilder: (context) => <PopupMenuEntry<MenuActions>>[
              PopupMenuItem<MenuActions>(
                child: Row(
                  children: [
                    SvgPicture.asset(
                      Res.location,
                      height: 26.0,
                    ),
                    Padding(padding: EdgeInsets.all(5.0)),
                    Flexible(
                      child: Text(areaText,
                          style: Theme.of(context).textTheme.bodyText2
                          //   style: TextStyle(
                          //       fontWeight: FontWeight.w400, fontSize: 18.0),
                          // ),
                          ),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }

  _areaAnimation() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [Center(child: Lottie.asset(Res.location_anim, height: 30))],
      ),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }

  _moreIcon(BuildContext context, bool isLanguageChanged) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Ink(
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        child: PopupMenuButton(
          onSelected: (MenuActions result) async {
            switch (result) {
              case MenuActions.changeLanguage:
                if (isLanguageChanged) {
                  context.locale = Locale('en');
                } else {
                  context.locale = Locale('ar');
                }
                setState(() {
                  isLanguageChanged = !isLanguageChanged;
                });

                break;
              case MenuActions.settings:
                // TODO: Handle this case.
                break;
              case MenuActions.about:
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return Scaffold(
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Lottie.asset(Res.dev_anim),
                          Text(
                            "about_body".tr(),
                            style: Theme.of(context).textTheme.headline4,
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  );
                }));
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuActions>>[
            PopupMenuItem<MenuActions>(
              value: MenuActions.changeLanguage,
              child: Text("change_language".tr()),
            ),
            PopupMenuItem<MenuActions>(
              value: MenuActions.settings,
              child: Text("settings".tr()),
            ),
            PopupMenuItem<MenuActions>(
              value: MenuActions.about,
              child: Text("about".tr()),
            ),
          ],
        ),
      ),
    );
  }

  // Future<void> _fetchLocationName() async {
  //   gooMaps.addCircle(
  //       LatLng(widget.locationData.latitude, widget.locationData.longitude));
  //   _goToLocation(widget.locationData.latitude, widget.locationData.longitude);
  //   area = await _getAddressName(
  //       widget.locationData.latitude, widget.locationData.longitude);
  // }

  void addMarker(LatLng position) {
    final String markerId = "marker_id${_markers.length}";
    _markers.add(Map.Marker(position: position, markerId: MarkerId(markerId)));
  }

  void addCircle(LatLng position) {
    final String circleId = "circle_id${_markers.length}";
    _circles.add(Circle(
        center: position,
        circleId: CircleId(circleId),
        radius: radius,
        strokeWidth: strokeWidth,
        strokeColor: circleColor.withOpacity(0.7),
        fillColor: circleColor.withOpacity(0.5)));
  }
}
