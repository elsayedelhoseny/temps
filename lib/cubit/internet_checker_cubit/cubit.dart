import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../internet_checker_cubit/states.dart';

class InternetCubit extends Cubit<InternetStates> {
  StreamSubscription? _connectivitySubscription;
  final Connectivity _connectivity = Connectivity();

  InternetCubit() : super(InternetInitial()) {
    _monitorInternetConnection();
  }

  static InternetCubit get(BuildContext context) => BlocProvider.of(context);

  bool isConnected = false;
  bool isConnectingRestoredToastShown = false;

  /// Monitor internet connection changes
  void _monitorInternetConnection() {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
          final isCurrentlyConnected = results.any((result) => result != ConnectivityResult.none);
          if (isCurrentlyConnected) {
            _onConnected();
          } else {
            _onDisconnected();
          }
        });
  }

  /// Handle reconnection logic
  void _onConnected() {
    isConnected = true;
    if (!isConnectingRestoredToastShown) {
      isConnectingRestoredToastShown = true;
      emit(ReConnectedState());
    }
  }

  /// Handle disconnection logic
  void _onDisconnected() {
    isConnected = false;
    isConnectingRestoredToastShown = false;
    emit(NoInternetChecked());
  }

  /// Attempt to reconnect manually
  Future<void> tryReconnecting() async {
    if (state is! TryingToReconnecting) {
      emit(TryingToReconnecting());
      await Future.delayed(const Duration(seconds: 2));
      if (!isConnected) {
        emit(StillNotConnectedState());
      }
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}