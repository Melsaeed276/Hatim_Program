import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectionController with ChangeNotifier {
  final _connectivity = Connectivity();
  bool _isConnected = true;

  bool get getIsConnected => _isConnected;

  Connectivity get getConnectivity => _connectivity;

  set setIsConnected(bool condition) {
    _isConnected = condition;
    notifyListeners();
  }

  checkConnectivityState(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
        setIsConnected = true;
        break;
      case ConnectivityResult.wifi:
        setIsConnected = true;
        break;
      case ConnectivityResult.bluetooth:
        setIsConnected = true;
        break;
      case ConnectivityResult.ethernet:
        setIsConnected = true;
        break;
      default:
        setIsConnected = false;
    }
  }
}
