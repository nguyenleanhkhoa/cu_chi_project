import 'dart:async';

import 'package:cuchi/src/utils/UtilsCommon.dart';
import 'package:flutter/cupertino.dart';

enum BaseStatus { unknown, onProgress, onSuccess, onError, onWarning }

class BaseObservableObject {
  final BaseStatus status;
  final String message;
  final bool isShowLoading;
  final bool isShowDialogMessage;
  final String errorMess;
  BaseObservableObject(
      {this.status = BaseStatus.unknown,
      this.message,
      this.isShowLoading = true,
      this.isShowDialogMessage,
      this.errorMess = ""});
}

var baseController = StreamController<BaseObservableObject>.broadcast();

Stream<BaseObservableObject> get baseStream => baseController.stream;
bool isLoading = false;

class BaseObserver {
  void loading() {
    print("loadning....");
    baseController.sink.add(BaseObservableObject(
      status: BaseStatus.onProgress,
    ));
  }

  void success(
      {bool isShowDialogMessage = false,
      String message = "",
      bool isPopToParent = false,
      BuildContext context}) {
    print("succeess....");
    baseController.sink.add(BaseObservableObject(
      status: BaseStatus.onSuccess,
      isShowDialogMessage: isShowDialogMessage,
      message: message,
    ));
  }

  void error(
      {bool isShowDialogMessage = false,
      String message = "",
      BuildContext context}) {
    baseController.sink.add(BaseObservableObject(
        status: BaseStatus.onError,
        isShowDialogMessage: isShowDialogMessage,
        errorMess: message));
  }

  void warning(
      {bool isShowDialogMessage = false,
      String message = "",
      BuildContext context}) {
    baseController.sink.add(BaseObservableObject(
        status: BaseStatus.onWarning,
        isShowDialogMessage: isShowDialogMessage,
        errorMess: message));
  }

  Stream<dynamic> callFunctionStream(
      {Function func, BuildContext context}) async* {
    loading();
    try {
      await func();
    } catch (e) {
      error(message: e.toString());
    }
    await Future.delayed(const Duration(milliseconds: 1000));
    success(message: 'Finish', context: context);
  }

  Future<void> callFunctionFuture({Function func}) async {
    loading();
    try {
      await func();
    } catch (e) {
      error(message: e.toString());
    }
    await Future.delayed(const Duration(milliseconds: 1000));

    success(message: 'Finish');
  }

  void close() {
    baseController.close();
  }
}

final baseObserverController = BaseObserver();
