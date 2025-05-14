import 'package:flutter/material.dart';
import 'package:get/get.dart';

showLoading(BuildContext context) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      content: Container(
        height: 40,
        child: Center(
            child: CircularProgressIndicator(
          color: Colors.black,
          strokeWidth: 0,
        )),
      ),
    ),
  );
}

dismissLoadingWidget() {
  Get.back();
}
