import 'dart:async';
import 'dart:math';

import 'package:covid_tracker_app/common/goo_maps.dart';
import 'package:covid_tracker_app/ui/components/bubble_icon.dart';
import 'package:covid_tracker_app/ui/components/drag_handler.dart';
import 'package:covid_tracker_app/ui/components/tip_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart' as Geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';

import '../../res.dart';
import 'drawer_page.dart';

const double DEFAULT_ZOOM = 19.0;

enum MenuActions { first, second, third, fouth }


class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Location location = new Location();
  bool _serviceEnabled;
  String area = "";
  PermissionStatus _permissionGranted;
  GooMaps gooMaps = GooMaps();
  var tips = [
    TipPage(
      animation: Res.wear_anim,
      title: "tip_mask_title".tr(),
      description: "tip_mask_body".tr(),
      buttonText: "okay".tr(),
    ),
    TipPage(
      animation: Res.sanitizer_anim,
      title: "tip_sanitizer_title".tr(),
      description: "tip_sanitizer_body".tr(),
      buttonText: "okay".tr(),
    ),
    TipPage(
      animation: Res.sneezing_anim,
      title: "tip_sneeze_title".tr(),
      description: "tip_sneeze_body".tr(),
      buttonText: "okay".tr(),
    ),
  ];

  Future<LocationData> _getCurrentLocation() {
    return location.getLocation();
  }

  Future<LocationData> _initLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    LocationData locationData = await location.getLocation();
    area = await _getAddressName(locationData.latitude, locationData.longitude);
    return locationData;
  }

  Widget _initAppBar(BuildContext appBarContext) {
    var isLanguageChanged = appBarContext.locale == Locale('en') ? false : true;
    return Container(
      height: 80,
      child: AppBar(
        elevation: 0.0,
        title: _areaText(area),
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
      initialChildSize: 0.1,
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
      final coordinates = new Coordinates(lat, lon);
      // List<Address> addresses = await Geocoder.google(Config.googleMapsAPIKey,
      //         language: context.locale.languageCode)
      //     .findAddressesFromCoordinates(coordinates);
      // List<Address> addresses =
      //     await Geocoder.local.findAddressesFromCoordinates(coordinates);
      List<Geo.Placemark> placemarks = await Geo.placemarkFromCoordinates(
          lat, lon,
          localeIdentifier: context.locale.languageCode);
      print("Placemark: ${placemarks.first}");
      //Address first = addresses.first;
      return "${placemarks.first.name} ${(context.locale.languageCode == 'ar') ? "،" : ","} ${placemarks.first.country}";
//  print("Element : ${first.countryCode}"); // LB
//  print("Element : ${first.subAdminArea}"); // alay
    } catch (e) {
      print("Error Getting address name : type: ${e.runtimeType} $e");
      return "Error";
    }
  }

  Future<void> _goToLocation(double lat, double lon) async {
    print("Lat, Lon: $lat, $lon");
    final GoogleMapController controller = await gooMaps.getController();
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, lon),
      zoom: DEFAULT_ZOOM,
    )));
    // locationStr = await _getAddressName(lat, lon);
    // print("Current Address : $locationStr");
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    gooMaps.getController().then((value) => value.dispose());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => tips[Random().nextInt(tips.length - 0)],
            ));
          },
          child: Icon(Icons.privacy_tip),
        ),
        body: Stack(children: [
          FutureBuilder(
            future: _initLocation(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                print("Building Map...");
                LocationData location = snapshot.data;
                gooMaps
                    .addCircle(LatLng(location.latitude, location.longitude));
                _goToLocation(location.latitude, location.longitude);
                return Stack(children: [
                  gooMaps,
                  _initAppBar(context),
                ]);
              } else if (snapshot.hasError) {
                return Text("Error !");
              }
              return Center(
                  child: Lottie.asset(Res.location_anim,
                      frameRate: FrameRate(60)));
            },
          ),
          _initBottomDrawerSheet()
        ]));
  }

  _notificationIcon() {
    return BubbleIcon(
        onPressed: () {
          print("Button Pressed !@");
        },
        icon: Icon(Icons.notifications_none_rounded));
  }

  _menuIcon() {
    return BubbleIcon(
      icon: Icon(Icons.menu_outlined),
      onPressed: () {},
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
              case MenuActions.first:
                if (isLanguageChanged) {
                  context.locale = Locale('en');
                } else {
                  context.locale = Locale('ar');
                }
                setState(() {
                  isLanguageChanged = !isLanguageChanged;
                });

                break;
              case MenuActions.second:
                // TODO: Handle this case.
                break;
              case MenuActions.third:
                // TODO: Handle this case.
                break;
              case MenuActions.fouth:
                // TODO: Handle this case.
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuActions>>[
            PopupMenuItem<MenuActions>(
              value: MenuActions.first,
              child: Text("change_language".tr()),
            ),
            PopupMenuItem<MenuActions>(
              value: MenuActions.third,
              child: Text("settings".tr()),
            ),
            PopupMenuItem<MenuActions>(
              value: MenuActions.fouth,
              child: Text("about".tr()),
            ),
          ],
        ),
      ),
    );
  }
}
