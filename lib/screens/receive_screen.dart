import 'package:flutter/material.dart';
import 'package:lcast/services/permissions_service.dart';

class ReceiveScreen extends StatefulWidget {
  @override
  _ReceiveScreenState createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends State<ReceiveScreen> {
  @override
  void initState() {
    super.initState();
    PermissionsService.requestAllPermissions();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Receve Mode')),
      body: Center(child: Text('Waiting for messages...')),
    );
  }
}