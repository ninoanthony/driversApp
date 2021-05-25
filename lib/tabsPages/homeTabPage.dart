import 'dart:async';
import 'package:drivers_app/AllScreens/registrationScreen.dart';
import 'package:drivers_app/Assistants/assistantMethods.dart';
import 'package:drivers_app/Models/drivers.dart';
import 'package:drivers_app/Notifications/pushNotificationService.dart';
import 'package:drivers_app/configMaps.dart';
import 'package:drivers_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_restart/flutter_restart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeTabPage extends StatefulWidget {
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();

  GoogleMapController newGoogleMapController;



  var geolocator = Geolocator();

  String driverStatusText = "Offline Now - Go Online ";

  Color driverStatusColor = Colors.black;

  bool isDriverAvailable = false;

  @override
  void initState() {
    super.initState();

    getCurrentDriverInfo();
  }

  getRatings()
  {
    //update Ratings
    driversRef.child(currentfirebaseUser.uid).child("ratings").once().then((DataSnapshot dataSnapshot)
    {
      if(dataSnapshot.value != null)
      {
        double ratings = double.parse(dataSnapshot.value.toString());
        setState(() {
          starCounter = ratings;
        });
        if(starCounter <=1)
        {
          setState(() {
            title = "Very Bad";
          });
          return;
        }
        if(starCounter <=2)
        {
          setState(() {
            title = "Bad";
          });
          return;
        }
        if(starCounter <=3)
        {
          setState(() {
            title = "Good";
          });
          return;
        }
        if(starCounter <=4)
        {
          setState(() {
            title = "Very Good";
          });
          return;
        }
        if(starCounter <=5)
        {
          setState(() {
            title = "Excellent";
          });
          return;
        }
      }
    });

  }

  void locatePosition() async
  {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition = new CameraPosition(target: latLatPosition, zoom: 14);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  void getCurrentDriverInfo() async
  {
    currentfirebaseUser = await FirebaseAuth.instance.currentUser;
    driversRef.child(currentfirebaseUser.uid).once().then((DataSnapshot dataSnapshot){
      if (dataSnapshot.value != null)
      {
        driversInformation = Drivers.fromSnapshot(dataSnapshot);
      }
    });

    PushNotificationService pushNotificationService = PushNotificationService();

    pushNotificationService.initialize(context);
    pushNotificationService.getToken();

    AssistantMethods.retrieveHistoryInfo(context);
    getRatings();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          initialCameraPosition: HomeTabPage._kGooglePlex,
          myLocationEnabled: true,
          onMapCreated: (GoogleMapController controller)
          {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;

            locatePosition();
          },
        ),

       
        //online offline driver Container
        Container(
          height: 140.0,
          width: double.infinity,
          color: Colors.lightBlue ,
        ),

        Positioned(
          top: 60.0,
          left: 0.0,
          right: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             Padding(
               padding: EdgeInsets.symmetric(horizontal: 16.0),
               child: RaisedButton(
                 onPressed: ()
                 {

                    if(isDriverAvailable != true)
                    {
                      makeDriverOnlineNow();
                      getLocationLiveUpdates();

                      setState(() {
                        driverStatusColor = Colors.green;
                        driverStatusText = "Online Now";
                        isDriverAvailable = true;
                      });
                      displayToastMessage("you are Online Now.", context);
                    }
                    else
                      {

                      makeDriverOfflineNow();

                      setState(() {
                        driverStatusColor = Colors.black;
                        driverStatusText = "Offline Now - Go Online ";
                        isDriverAvailable = false;
                      });

                      displayToastMessage("you are Offline Now.", context);
                    }
                 },
                 color: driverStatusColor,
                 child: Padding(
                   padding: EdgeInsets.all(17.0),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text(driverStatusText, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),),
                       Icon(Icons.phone_android, color: Colors.white, size: 24.0,),
                     ],
                   ),
                 ),
               ),
             ),
           ],
          ),
        ),
      ],
    );
  }



   void makeDriverOnlineNow() async
   {
     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
     currentPosition = position;

     Geofire.initialize("availableDrivers");
     Geofire.setLocation(currentfirebaseUser.uid, currentPosition.latitude, currentPosition.longitude);

     rideRequestRef.set("searching");
     rideRequestRef.onValue.listen((event) {

     });
   }

   void getLocationLiveUpdates()
   {

     homeTabPageStreamSubscription = Geolocator.getPositionStream().listen((Position position)
      {
       currentPosition = position;
       if(isDriverAvailable == true)
       {
          Geofire.setLocation(currentfirebaseUser.uid, position.latitude, position.longitude);
       }
       LatLng latLng = LatLng(position.latitude, position.longitude);
       newGoogleMapController.animateCamera(CameraUpdate.newLatLng(latLng));
      });
   }

   void makeDriverOfflineNow()
   {
     Geofire.removeLocation(currentfirebaseUser.uid);
     rideRequestRef.onDisconnect();
     rideRequestRef.remove();
     rideRequestRef = null;
     _restartApp();


   }
   void _restartApp() async
   {
     FlutterRestart.restartApp();
   }
}
