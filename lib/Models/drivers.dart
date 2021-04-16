import 'package:firebase_database/firebase_database.dart';

class Drivers
{
  String name;
  String phone;
  String email;
  String id;
  String tricycle_color;
  String tricycle_model;
  String tricycle_number;

  Drivers({this.name, this.phone, this.email, this.id, this.tricycle_color, this.tricycle_model, this.tricycle_number, });

  Drivers.fromSnapshot(DataSnapshot dataSnapshot)
  {
    id = dataSnapshot.key;
    phone = dataSnapshot.value["phone"];
    email = dataSnapshot.value["email"];
    name = dataSnapshot.value["name"];
    tricycle_color = dataSnapshot.value["car_details"]["tricycle_color"];
    tricycle_model = dataSnapshot.value["car_details"]["tricycle_model"];
    tricycle_number = dataSnapshot.value["car_details"]["tricycle_number"];
  }
}