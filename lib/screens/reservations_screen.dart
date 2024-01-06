import 'package:flutter/material.dart';
import 'package:coiffinder/main.dart';

class MyReservationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Reservations')),
      body: Center(
        child: Text('My Reservations Page Content'),
      ),
      drawer: AppDrawer(),
    );
  }
}
