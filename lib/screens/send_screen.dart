import 'package:flutter/material.dart';
import 'package:lcast/services/permissions_service.dart';

class SendScreen extends StatefulWidget{
  @override
  _SendScreenState createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {
  @override
  void initState() {
    super.initState();
    PermissionsService.requestAllPermissions();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Broadcast')),
      body: Center(child: Text('Broadcasting...')),
    );
  }
}
  

  
