import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class Controller extends GetxController {
  final List<RxString> option = ['yes'.obs, 'no'.obs];

  RxString selected = 'no'.obs;

  void onClickRadioButton(RxString val) {
    selected = val;
    update();
  }

  bool get userTerimaTawaran => selected == option[0];

  TextEditingController otp = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool get otpValid => formKey.currentState!.validate();
}
