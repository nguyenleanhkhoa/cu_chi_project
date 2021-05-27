import 'package:cuchi/src/utils/resources/dialog.resource.dart';
import 'package:cuchi/styles/theme.dart';
import 'package:flutter/material.dart';

class AlertDialogMessage extends StatelessWidget {
  String tilte;
  String subscription;
  bool isError = false;
  bool isLoading = false;
  bool isSuccess = false;
  bool isShowButtonAction = false;
  bool okButton = false;
  String btnTitle;
  Function() onOkPressed;

  AlertDialogMessage(
      {Key key,
      this.tilte,
      this.isError,
      this.isSuccess,
      this.isLoading,
      this.subscription,
      this.isShowButtonAction,
      this.okButton,
      this.btnTitle = "Đồng ý",
      this.onOkPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: EdgeInsets.all(0),
      titlePadding: EdgeInsets.all(0),
      buttonPadding: EdgeInsets.all(0),
      actionsPadding: EdgeInsets.all(0),
      // title: Text(this.tilte == null ? "" : this.tilte),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 20.0,
          ),
          showError(),
          showLoading(),
          showSuccess(this.tilte == null ? null : this.tilte),
          showDescription(this.subscription == null ? null : this.subscription),
          showActionButton(context),
          SizedBox(
            height: 20.0,
          ),
        ].where((element) => element != null).toList(),
      ),
    );
  }

  Widget showError() {
    return (this.isError != null &&
            (this.tilte != null || this.subscription != null))
        ? Column(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 50,
              ),
              SizedBox(
                height: 10.0,
              )
            ],
          )
        : null;
  }

  Widget showActionButton(context) {
    return (this.isShowButtonAction != null &&
            this.isShowButtonAction &&
            (this.tilte != null || this.subscription != null))
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10.0,
              ),
              (this.okButton == true
                  ? GestureDetector(
                      onTap: this.onOkPressed,
                      child: Container(
                        width: 100.0,
                        height: 30.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: LightTheme.colorMain,
                        ),
                        child: Center(
                          child: Text(
                            this.btnTitle,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ))
                  : const SizedBox()),
            ],
          )
        : null;
  }

  Widget showDescription(String title) {
    return (title != null && title != "")
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        : null;
  }

  Widget showLoading() {
    return (this.isLoading != null) ? AppLoad.spinLoading : const SizedBox();
  }

  Widget showSuccess(String title) {
    return (this.isSuccess != null)
        ? Column(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 50,
              ),
              SizedBox(
                height: 10.0,
              )
            ],
          )
        : const SizedBox();
  }
}
