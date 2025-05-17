import 'package:flutter/material.dart';
import 'package:lcast/services/permissions_service.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'dart:typed_data';

class SendScreen extends StatefulWidget{
  @override
  _SendScreenState createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {
  final Strategy strategy = Strategy.P2P_STAR;
  final Map<String, ConnectionInfo> connectedDevices = {};
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<String> messages = [];


  @override
  void initState() {
    super.initState();
    requestPermissionsAndStart();
  }

  void requestPermissionsAndStart() async {
    await PermissionsService.requestAllPermissions();
    startAdvertising();
  }

  void startAdvertising() async {
      try {
        await Nearby().startAdvertising(
          "LocalCastDevice", 
          strategy, 
          onConnectionInitiated: onConnectionInit,
          onConnectionResult: (id, status) {
            print('connection $id status: $status');
          }, 
          onDisconnected: (id) {
            print('Disconnected: $id');
            connectedDevices.remove(id);
          },
        );
      } catch (e) {
        print("Advertising error: $e");
      }
    }
  

  void onConnectionInit(String id, ConnectionInfo info) {
    print("Connection initiated with: $id");
    connectedDevices[id] = info;

    Nearby().acceptConnection(
      id, 
      onPayLoadRecieved: (endpointId, payload) {
        final message = String.fromCharCodes(payload.bytes!);
        print('Received from $endpointId: $message');
      },
      onPayloadTransferUpdate: (endpointId, payloadTransferUpdate) {},
    );
  }

  void sendMessageToAll() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final payload = Uint8List.fromList(text.codeUnits);
    connectedDevices.forEach((id, _){
      Nearby().sendBytesPayload(id, payload);
    });

    setState(() {
      messages.add("You: $text");
    });

    _messageController.clear();

    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent, 
        duration: Duration(milliseconds: 300), 
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    Nearby().stopAdvertising();
    Nearby().stopAllEndpoints();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Send')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messages[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Type a message',
                      border: OutlineInputBorder(),
                    ),
                  ), 
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessageToAll,
                  color: Theme.of(context).primaryColor,
                )
              ],
            )
          )
        ],
      ),
    );
  }
}
  

  
