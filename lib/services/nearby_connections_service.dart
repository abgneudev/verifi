import 'dart:convert';
import 'dart:typed_data';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:permission_handler/permission_handler.dart';

typedef PayloadCallback = void Function(String endpointId, Payload payload);
typedef ConnectionInitCallback = void Function(String id, ConnectionInfo info);
typedef ConnectionResultCallback = void Function(String id, Status status);
typedef DisconnectedCallback = void Function(String id);
typedef EndpointFoundCallback =
    void Function(String id, String name, String serviceId);
typedef EndpointLostCallback = Function(String? id);

class NearbyConnectionsService {
  static const String serviceId = "com.hackathon.escrow";
  static const Strategy strategy = Strategy.P2P_POINT_TO_POINT;

  Future<void> checkPermissions() async {
    // Request all necessary permissions
    final permissions = [
      Permission.bluetooth,
      Permission.bluetoothAdvertise,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.location,
      Permission.locationWhenInUse,
      Permission.nearbyWifiDevices,
    ];

    final statuses = await permissions.request();

    // Check if critical permissions are denied
    if (statuses[Permission.location] != PermissionStatus.granted) {
      throw Exception('Location permission is required for Nearby Connections');
    }
  }

  Future<bool> startAdvertising({
    required String userName,
    required ConnectionInitCallback onConnectionInit,
    required ConnectionResultCallback onConnectionResult,
    required DisconnectedCallback onDisconnected,
  }) async {
    await checkPermissions();

    return await Nearby().startAdvertising(
      userName,
      strategy,
      onConnectionInitiated: onConnectionInit,
      onConnectionResult: onConnectionResult,
      onDisconnected: onDisconnected,
      serviceId: serviceId,
    );
  }

  Future<bool> startDiscovery({
    required String userName,
    required EndpointFoundCallback onEndpointFound,
    required EndpointLostCallback onEndpointLost,
    required ConnectionInitCallback onConnectionInit,
    required ConnectionResultCallback onConnectionResult,
    required DisconnectedCallback onDisconnected,
  }) async {
    await checkPermissions();

    return await Nearby().startDiscovery(
      userName,
      strategy,
      onEndpointFound: (id, name, serviceId) {
        onEndpointFound(id, name, serviceId);
        Nearby().requestConnection(
          userName,
          id,
          onConnectionInitiated: onConnectionInit,
          onConnectionResult: onConnectionResult,
          onDisconnected: onDisconnected,
        );
      },
      onEndpointLost: onEndpointLost,
      serviceId: serviceId,
    );
  }

  void acceptConnection(String endpointId, PayloadCallback onPayloadReceived) {
    Nearby().acceptConnection(endpointId, onPayLoadRecieved: onPayloadReceived);
  }

  void sendJsonPayload(String endpointId, Map<String, dynamic> data) {
    final payload = jsonEncode(data);
    Nearby().sendBytesPayload(endpointId, utf8.encode(payload));
  }

  void sendBytesPayload(String endpointId, Uint8List bytes) {
    Nearby().sendBytesPayload(endpointId, bytes);
  }

  Future<void> stopAdvertising() async {
    await Nearby().stopAdvertising();
  }

  Future<void> stopDiscovery() async {
    await Nearby().stopDiscovery();
  }

  Future<void> disconnectFromEndpoint(String endpointId) async {
    await Nearby().disconnectFromEndpoint(endpointId);
  }
}
