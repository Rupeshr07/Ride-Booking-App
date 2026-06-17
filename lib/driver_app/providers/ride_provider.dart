import 'package:flutter/material.dart';

enum RideStatus {
  idle,
  searching,
  requestReceived,
  accepted,
  arrivedAtPickup,
  pinVerified,
  loadingInProgress,
  loadingCompleted,
  rideStarted,
  arrivedAtDestination,
  unloadingInProgress,
  unloadingCompleted,
  rideCompleted,
  paymentReceived
}

class RideProvider extends ChangeNotifier {
  bool _isOnline = false;
  RideStatus _status = RideStatus.idle;

  bool get isOnline => _isOnline;
  RideStatus get status => _status;

  void toggleOnline() {
    _isOnline = !_isOnline;
    if (!_isOnline) {
      _status = RideStatus.idle;
    } else {
      // Mock receiving a request after a delay
      _simulateRequest();
    }
    notifyListeners();
  }

  void _simulateRequest() async {
    if (_isOnline && _status == RideStatus.idle) {
      await Future.delayed(const Duration(seconds: 2));
      if (_isOnline) {
        _status = RideStatus.requestReceived;
        notifyListeners();
      }
    }
  }

  void acceptRide() {
    _status = RideStatus.accepted;
    notifyListeners();
  }

  void rejectRide() {
    _status = RideStatus.idle;
    _simulateRequest();
    notifyListeners();
  }

  void arriveAtPickup() {
    _status = RideStatus.arrivedAtPickup;
    notifyListeners();
  }

  void verifyPin() {
    _status = RideStatus.pinVerified;
    notifyListeners();
  }

  void startLoading() {
    _status = RideStatus.loadingInProgress;
    notifyListeners();
  }

  void completeLoading() {
    _status = RideStatus.loadingCompleted;
    notifyListeners();
  }

  void startRide() {
    _status = RideStatus.rideStarted;
    notifyListeners();
  }

  void arriveAtDestination() {
    _status = RideStatus.arrivedAtDestination;
    notifyListeners();
  }

  void startUnloading() {
    _status = RideStatus.unloadingInProgress;
    notifyListeners();
  }

  void completeUnloading() {
    _status = RideStatus.unloadingCompleted;
    notifyListeners();
  }

  void completeRide() {
    _status = RideStatus.rideCompleted;
    notifyListeners();
  }

  void confirmPayment() {
    _status = RideStatus.paymentReceived;
    notifyListeners();
  }

  void returnToHome() {
    _status = RideStatus.idle;
    _simulateRequest();
    notifyListeners();
  }
}
