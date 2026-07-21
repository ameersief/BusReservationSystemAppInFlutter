import 'dart:async';


import 'dart:convert';
import 'package:busreservation/models/bookingmodel.dart';
import 'package:busreservation/providers/user-provider.dart';
import 'package:busreservation/widgets/indvbooking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:busreservation/config.dart';

class Bookings extends ConsumerStatefulWidget{
  @override
  ConsumerState<Bookings> createState() => _BookingsState();
}

class _BookingsState extends ConsumerState<Bookings> {

  List<BookingModel> bookings=[];

  void getBookings() async{
    String currentUser=ref.read(userProvider.notifier).getUser();
    try {
      var response=await http.get(Uri.parse('${Config.baseUrl}/booking/$currentUser')).timeout(const Duration(seconds: 10));
      if(response.statusCode==200){
        List res=jsonDecode(response.body);
        List<BookingModel> tmp=[];
        res.forEach((e) {
          tmp.add(BookingModel(name: e["busName"], start: e["start"], end: e["end"], date: DateTime.parse(e["date"]), cost: e["price"].toDouble(), seats: e["seats"]));
        });
        if (mounted) {
          setState(() {
            bookings=tmp;
          });
        }
      }
    } catch (e) {
      // Ignore or show snackbar
    }
  }
  void initState(){
    getBookings();
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemCount:bookings.length,itemBuilder: (ctx,i)=>IndvBooking(booking:bookings[i]));
  }
}