import 'package:drivers_app/AllScreens/newRideScreen.dart';
import 'package:drivers_app/AllScreens/registrationScreen.dart';
import 'package:drivers_app/Assistants/assistantMethods.dart';
import 'package:drivers_app/Models/rideDetails.dart';
import 'package:drivers_app/configMaps.dart';
import 'package:drivers_app/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/scheduler.dart';
List<Point> myPointList = List<Point>();


class NotificationDialog extends StatelessWidget
{
  final RideDetails rideDetails;
  var globalrideRequestId;


  NotificationDialog({this.rideDetails});


  @override
  Widget build(BuildContext context) {

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Colors.transparent,
      elevation: 1.0,
      child: Container(
        margin: EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 30.0),
            Image.asset("images/taxi.png", width: 120.0,),
            SizedBox(height: 18.0,),
            Text("New Ride Request", style: TextStyle(fontFamily: "Brand-Bold", fontSize: 18.0,),),
            SizedBox(height: 30.0),
            Padding(
              padding: EdgeInsets.all(18.0),
              child: Column(
                children: [

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("images/pickicon.png", height: 16.0, width: 16.0,),
                      SizedBox(width: 20.0,),
                      Expanded(
                        child: Container(child: Text(rideDetails.pickup_address, style: TextStyle(fontSize: 18.0),)),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("images/desticon.png", height: 16.0, width: 16.0,),
                      SizedBox(width: 20.0,),
                      Expanded(
                        child: Container(child: Text(rideDetails.dropOff_address, style: TextStyle(fontSize: 18.0),)),
                      )
                    ],
                  ),
                  SizedBox(height: 15.0),

                ],
              ),
            ),

            SizedBox(height: 20.0),
            Divider(height: 2.0,color: Colors.black, thickness: 2.0,),
            SizedBox(height: 8.0),

            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.red)),
                    color: Colors.white,
                    textColor: Colors.red,
                    padding: EdgeInsets.all(8.0),
                    onPressed: ()
                    {
                      assetsAudioPlayer.stop();
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel".toUpperCase(),
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),

                  SizedBox(width: 25.0),

                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.green)),
                    onPressed: ()
                    {
                      assetsAudioPlayer.stop();
                      checkAvailabilityOfRide(context);
                    },

                    color: Colors.green,
                    textColor: Colors.white,
                    child: Text("Accept".toUpperCase(),
                        style: TextStyle(fontSize: 14)),
                  ),

                ],
              ),
            ),

            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }

  void checkAvailabilityOfRide(context)async{
    //var rideRequestId = await rideRequestRef.once();
    var dataSnapShot2 =  await newRequestsRef.child( (await rideRequestRef.once()).value).once();
    Navigator.pop(context);
    String theRideId = "";
    if(myPointList.length == 3)   {
      myPointList.add(Point(double.parse(dataSnapShot2.value['pickUp']['latitude'].toString()),double.parse(dataSnapShot2.value['pickUp']['longitude'].toString())));
      myPointList.add(Point(double.parse(dataSnapShot2.value['dropOff']['latitude'].toString()),double.parse(dataSnapShot2.value['dropOff']['longitude'].toString())));
    }

    if(myPointList.length == 0)   {
      // myPointList.add(Point(double.parse(dataSnapShot2.value['driver_location']['latitude'].toString()),double.parse(dataSnapShot2.value['driver_location']['longitude'].toString())));
      myPointList.add(Point(0,0));
      myPointList.add(Point(double.parse(dataSnapShot2.value['pickUp']['latitude'].toString()),double.parse(dataSnapShot2.value['pickUp']['longitude'].toString())));
      myPointList.add(Point(double.parse(dataSnapShot2.value['dropOff']['latitude'].toString()),double.parse(dataSnapShot2.value['dropOff']['longitude'].toString())));
    }
    var a = 0;
    print(myPointList.length);
    while(a<myPointList.length){
      print(myPointList[a].x);
      print(myPointList[a].y);
      a++;

    }
    bool r2canShare = true;
    if(myPointList.length > 3){
      var A1 = ((myPointList[3].x - myPointList[1].x).abs())*(myPointList[3].y - myPointList[1].y).abs()*12321.0;
      print(myPointList[3].x);
      print(myPointList[1].x);
      print(myPointList[3].y);
      print(myPointList[1].y);
      print(A1);

      var A2 = ((myPointList[3].x - myPointList[2].x).abs())*(myPointList[3].y - myPointList[1].y).abs()*12321.0;
      print(myPointList[3].x);
      print(myPointList[2].x);
      print(myPointList[3].y);
      print(myPointList[1].y);
      print(A2);

      var A3 = ((myPointList[3].x - myPointList[2].x).abs())*(myPointList[3].y - myPointList[2].y).abs()*12321.0;
      print(myPointList[3].x);
      print(myPointList[2].x);
      print(myPointList[3].y);
      print(myPointList[2].y);
      print(A3);

      var A4 = ((myPointList[3].x - myPointList[1].x).abs())*(myPointList[3].y - myPointList[2].y).abs()*12321.0;
      print(myPointList[3].x);
      print(myPointList[1].x);
      print(myPointList[3].y);
      print(myPointList[2].y);
      print(A4);

      var Atot = ((myPointList[1].x - myPointList[2].x).abs())*(myPointList[1].y - myPointList[2].y).abs()*12321.0;
      print(myPointList[1].x);
      print(myPointList[2].x);
      print(myPointList[1].y);
      print(myPointList[2].y);
      print(A1+A2+A3+A4);
      print(Atot);
      if(((A1+A2+A3+A4) - Atot).abs()<0.1){
        r2canShare = true;
      }else{
        r2canShare = false;
      }
    }
    if (r2canShare == true){
      rideRequestRef.set("accepted");
      assetsAudioPlayer.stop();
      AssistantMethods.disableHomeTabLiveLocationUpdates();
      Navigator.push(context, MaterialPageRoute(builder: (context) => NewRideScreen(rideDetails: rideDetails)));
    }else{
      assetsAudioPlayer.stop();
      displayToastMessage("Rider 2 cannot shared ride, out of range.", context);

    }

  }
}