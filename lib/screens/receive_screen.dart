import 'package:flutter/material.dart';
import 'package:lcast/services/permissions_service.dart';
import 'package:nearby_connections/nearby_connections.dart';

class ReceiveScreen extends StatefulWidget {
  @override
  _ReceiveScreenState createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends State<ReceiveScreen> {
  final Strategy strategy = Strategy.P2P_STAR;
  final Map<String, ConnectionInfo> connectedDevices = {};
  List<String> receivedMessages = [];

  @override
  void initState() {
    super.initState();
    requestPermissionsAndStart();
  }

  void requestPermissionsAndStart() async {
    await PermissionsService.requestAllPermissions();
    startDiscovery();
  }

  void startDiscovery() async {
    try {
      await Nearby().startDiscovery(
        "LocalCastClient",
        strategy,
        onEndpointFound: (id, name, serviceId) {
          print("found endpoint: $name ($id)");
          Nearby().requestConnection(
            "LocalCastClient", 
            id, 
            onConnectionInitiated: onConnectionInit, 
            onConnectionResult: (id, status) {
              print("Conncetion status $status");
            }, 
            onDisconnected: (id) {
              print("Disconnected from: $id");
              connectedDevices.remove(id);
            },
          );
        },
        onEndpointLost: (id) {
          print("Lost:$id");
        },
      );
    } catch (e) {
      print("Discovery error: $e");
    }
  }

  void onConnectionInit(String id, ConnectionInfo info) {
    connectedDevices[id] = info;

    Nearby().acceptConnection(
      id, 
      onPayLoadRecieved: (endpointId, payload) {
        final message = String.fromCharCodes(payload.bytes!);
        setState(() {
          receivedMessages.add(message);
        });
        print('Received from $endpointId: $message');
      },
      onPayloadTransferUpdate: (endpointId, payloadTransferUpdate) {},
    );
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
      appBar: AppBar(title: Text('Receve')),
      body: Column(
        children: [
          Expanded(child: ListView.builder(
            itemCount: receivedMessages.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(receivedMessages[index]),
              );
            },
          ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Discovering nearby devices..."),
          ),
        ],
      ),
    );
  }
}