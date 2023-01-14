import 'dart:convert';

import 'package:aplikasi_presensi/models/register_response_model.dart';
import 'package:aplikasi_presensi/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as myHttp;

import '../components/progress_dialog.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  RegisterResponseModel? registerResponseModel;
  TextEditingController nameTxtEdtController = TextEditingController();
  TextEditingController emailTxtEdtController = TextEditingController();
  TextEditingController passwordTxtEdtController = TextEditingController();
  FToast? fToast;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast?.init(context);
  }

  register(String name,String email, String password) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c){
          return ProgressDialog(
            msg: "Sedang Di Proses",
          );
        }
    );

    Map<String, String> body = {
      "name" : name,
      "email": email,
      "password": password
    };

    var response = await myHttp.post(
      Uri.parse('http://192.168.0.101:8000/api/register'),
      body: body,
    );

    if(response.statusCode == 401) {
      fToast?.showToast(
          child: _showToast("Datanya Tidak Valid !"),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 3)
      );
    } else {
      if(response.body.isNotEmpty){
        registerResponseModel = RegisterResponseModel.fromJson(json.decode(response.body));
        print("Hasil "+ response.body);
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (c)=> const LoginScreen()));
      }
    }
  }

  validateForm(String name,String email, String password) {
    if(nameTxtEdtController.text.isEmpty && emailTxtEdtController.text.isEmpty && passwordTxtEdtController.text.isEmpty){
      fToast?.showToast(
          child: _showToast("Semua Data Harus Di Isi !"),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 3)
      );
    }
    else if(!emailTxtEdtController.text.contains("@")){
      fToast?.showToast(
          child: _showToast("Emailnya Salah"),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 3)
      );
    }
    else if(passwordTxtEdtController.text.length < 3){
      fToast?.showToast(
          child: _showToast("Harap Isi Password Dengan Benar dan Teliti !"),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 3)
      );
    }
    else if(passwordTxtEdtController.text.isEmpty){
      fToast?.showToast(
        child: _showToast("Passwordnya Harus Di Isi !"),
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 3),
      );
    }else {
      register(name,email, password);
    }
  }

  _showToast(String? toastMsg){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.grey,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 12.0,
          ),
          Text(
            toastMsg!,
            style: const TextStyle(
                color: Colors.white
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Silahkan Daftarkan Akun Anda",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: nameTxtEdtController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                      color: Colors.grey
                  ),
                  decoration: const InputDecoration(
                    labelText: "Nama Anda",
                    hintText: "Masukan Nama Anda",
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)
                    ),
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14
                    ),
                    labelStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: emailTxtEdtController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                      color: Colors.grey
                  ),
                  decoration: const InputDecoration(
                    labelText: "Email Anda",
                    hintText: "Masukan Email Anda",
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)
                    ),
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14
                    ),
                    labelStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: passwordTxtEdtController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  style: const TextStyle(
                      color: Colors.grey
                  ),
                  decoration: const InputDecoration(
                    labelText: "Password Anda",
                    hintText: "Masukan Password Anda",
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)
                    ),
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14
                    ),
                    labelStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: (){
                    validateForm(
                        nameTxtEdtController.text.trim(),
                        emailTxtEdtController.text.trim(),
                        passwordTxtEdtController.text.trim()
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreenAccent,
                  ),
                  child: const Text(
                    "Masuk",
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18
                    ),
                  ),
                ),
                TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Udh pernah pake Aplikasinya ? Masuk Aja!",
                      style: TextStyle(
                          color: Colors.grey
                      ),
                    )
                )
              ],
            ),
          ),
        ),
    );
  }
}
