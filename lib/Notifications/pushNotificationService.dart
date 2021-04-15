import 'package:drivers_app/Models/rideDetails.dart';
import 'package:drivers_app/Notifications/notificationDialog.dart';
import 'package:drivers_app/configMaps.dart';
import 'package:drivers_app/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:io'show Platform;

import 'package:google_maps_flutter/google_maps_flutter.dart';

class PushNotificationService
{
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  Future initialize(context) async
  {
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        retrieveRideRequestsInfo(getRideRequestId(message), context);
      },
      onLaunch: (Map<String, dynamic> message) async {
        retrieveRideRequestsInfo(getRideRequestId(message), context);
      },
      onResume: (Map<String, dynamic> message) async {
        retrieveRideRequestsInfo(getRideRequestId(message), context);
      },
    );
  }

  Future<String> getToken()async
  {
    String token =  await firebaseMessaging.getToken();
    print("This is token :: ");
    print(token);
    driversRef.child(currentfirebaseUser.uid).child("token").set(token);

    firebaseMessaging.subscribeToTopic("alldrivers");
    firebaseMessaging.subscribeToTopic("allusers");
  }

  String getRideRequestId(Map<String, dynamic> message)
  {
    String rideRequestId = "";
    if(Platform.isAndroid)
    {
      rideRequestId = message['data']['ride_request_id'];
    }
    else
    {
      rideRequestId = message['ride_request_id'];
    }

    return rideRequestId;
  }

  void retrieveRideRequestsInfo(String rideRequestId, BuildContext context)
  {
    newRequestsRef.child(rideRequestId).once().then((DataSnapshot dataSnapShot)
    {
      if(dataSnapShot.value != null)
        {
          double pickUpLocationLat = double.parse(dataSnapShot.value['pickUp']['latitude'].toString());
          double pickUpLocationLng = double.parse(dataSnapShot.value['pickUp']['longitude'].toString());
          String pickUpAddress = dataSnapShot.value['pickup_address'].toString();

          double dropOffLocationLat = double.parse(dataSnapShot.value['dropOff']['latitude'].toString());
          double dropOffLocationLng = double.parse(dataSnapShot.value['dropOff']['longitude'].toString());
          String dropOffAddress = dataSnapShot.value['dropOff_address'].toString();

          String paymentMethod = dataSnapShot.value['payment_method'].toString();

          RideDetails rideDetails = RideDetails();
          rideDetails.ride_request_id = rideRequestId;
          rideDetails.pickup_address = pickUpAddress;
          rideDetails.dropOff_address = dropOffAddress;
          rideDetails.pickUp = LatLng(pickUpLocationLat, pickUpLocationLng);
          rideDetails.dropOff = LatLng(dropOffLocationLat, dropOffLocationLng);
          rideDetails.payment_method = paymentMethod;

          print("Information :: ");
          print(rideDetails.pickup_address);
          print(rideDetails.dropOff_address);

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => NotificationDialog(rideDetails: rideDetails,),
          );
        }
    });
  }
}