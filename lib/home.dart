import 'package:approval/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:otp_timer_button/otp_timer_button.dart';

class MyHome extends StatelessWidget {
  // konfirmasi menerima penawaran
  // if yes maka kirim otp kemudian tampilkan dialog input kode otp
  // if no maka tampilkan snackbar

  MyHome({Key? key}) : super(key: key);
  final Controller c = Get.put(Controller());

  //~ ==================================== //
  @override
  Widget build(BuildContext context) {
    List<String> option = [];
    c.option.forEach((element) {
      option.add(element.string);
    });

    return Scaffold(
      body: Column(
        children: [
          _confirmText(),
          _option(0, option[0]),
          _option(1, option[1]),
          _submitBtn(),
        ],
      ),
    );
  }
  //~ ==================================== //

  Text _confirmText() {
    String t = ('Halo {nomor_interet} apakah anda bersedia untuk'
        ' menerima penawaran kami {offer_type}{offer_subtype}');
    double fsize = 23;
    return Text(
      t,
      style: TextStyle(fontSize: fsize),
      textAlign: TextAlign.center,
    );
  }

  GetBuilder<Controller> _option(int index, String title) {
    return GetBuilder<Controller>(
      builder: (_) => RadioListTile(
        title: Text(title),
        value: c.option[index],
        groupValue: c.selected,
        onChanged: (RxString? val) {
          c.onClickRadioButton(val!);
        },
      ),
    );
  }

  ElevatedButton _submitBtn() {
    return ElevatedButton(
      child: const Text('Submit'),
      onPressed: () {
        if (c.userTerimaTawaran) {
          _userTerimaTawaran();
        } else {
          _userTolakTawaran();
        }
      },
    );
  }

  void _userTerimaTawaran() async {
    Get.snackbar(
      'Kode OTP Telah di Kirim',
      'Silahkan input kode OTP',
    );
    await Future.delayed(Duration(seconds: 4));
    _sendOtp();
    _inputOtpDialog();
  }

  void _sendOtp() {
    print('resend');
  }

  Future<dynamic> _inputOtpDialog() {
    return Get.defaultDialog(
      title: 'Masukkan Kode OTP',
      content: _otpForm(),
    );
  }

  Form _otpForm() {
    return Form(
      key: c.formKey,
      child: Column(
        children: [
          Row(
            children: [
              _otpTextFormField(),
              _otpSubmitIcon(),
            ],
          ),
          SizedBox(height: 10),
          _resendOtpTextButton(),
        ],
      ),
    );
  }

  Expanded _otpTextFormField() {
    return Expanded(
      child: TextFormField(
        controller: c.otp,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: _otpValidator,
        decoration: InputDecoration(
          counterText: '',
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        maxLength: 5,
        onFieldSubmitted: (String? value) {
          if (c.otpValid) _doSomething();
        },
      ),
    );
  }

  String? _otpValidator(value) {
    bool notValid = value == null || value.isEmpty;
    if (notValid) return 'Silahkan masukkan kode OTP';
    return null;
  }

  void _doSomething() {
    Get.back();
    Get.snackbar('VALID', 'DO SOMETHING WITH ${c.otp.text}');
    print('valid');
  }

  IconButton _otpSubmitIcon() {
    return IconButton(
      icon: const Icon(
        Icons.send,
        color: Colors.blue,
      ),
      onPressed: () {
        if (c.otpValid) {
          _doSomething();
        }
      },
    );
  }

  Widget _resendOtpTextButton() {
    return OtpTimerButton(
      text: Text('Resend Kode OTP'),
      duration: 2,
      onPressed: () {
        _sendOtp();
      },
    );
  }

  void _userTolakTawaran() {
    Get.snackbar(
      'Anda Menolak Tawaran',
      'Silahkan pilih yes untuk melanjutkan',
    );
  }
}
