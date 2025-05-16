import 'package:flutter/material.dart';
import 'send_screen.dart';
import 'receive_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Local Cast')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => SendScreen()));
              }, 
              child: Text('Start Broadcast')
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, 
                MaterialPageRoute(builder: (_) => ReceiveScreen()));
              }, 
              child: Text('Receve Mode')
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, 
                MaterialPageRoute(builder: (_) => HistoryScreen()));
              }, child: Text('History')
            ),
          ],
        ),
      )
    );
  }
}