import 'package:flutter/material.dart';

Future<void> noInternet({required BuildContext context}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  textAlign: TextAlign.center,
                  'You do not have an internet connection, please connect to the internet to continue',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
