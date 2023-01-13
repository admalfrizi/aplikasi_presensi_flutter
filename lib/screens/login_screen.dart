import 'package:aplikasi_presensi/components/progress_dialog.dart';
import 'package:aplikasi_presensi/models/login_response_model.dart';
import 'package:aplikasi_presensi/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as myHttp;
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController emailTxtEdtController = TextEditingController();
  TextEditingController passwordTxtEdtController = TextEditingController();
  FToast? fToast;
  late Future<String> _name, _token;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _token = _prefs.then((SharedPreferences prefs){
      return prefs.getString("token") ?? "";
    });

    _name = _prefs.then((SharedPreferences prefs){
      return prefs.getString("name") ?? "";
    });

    fToast = FToast();
    fToast?.init(context);

    checkToken(_token, _name);
  }

  checkToken(token, name) async{
    String tokenStr = await token;
    String nameStr = await name;

    if(tokenStr != "" && nameStr != ""){
      Future.delayed(Duration(seconds: 1), () async {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (c)=> const HomeScreen()))
            .then((value) {
          setState(() {

          });
        });
      });
    }
  }

  login(String email, String password) async {
    LoginResponseModel? loginResponseModel;
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
      "email": email,
      "password": password
    };
    
    var response = await myHttp.post(
        Uri.parse('http://192.168.0.101:8000/api/login'),
        body: body,
    );

    if(response.statusCode == 401) {
      fToast?.showToast(
          child: _showToast("Email dan Password Tidak Valid !"),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 3)
      );
    } else {
      if(response.body.isNotEmpty){
        loginResponseModel = LoginResponseModel.fromJson(json.decode(response.body));
        saveUser(loginResponseModel.data?.accessToken, loginResponseModel.data?.user?.name);
        print("Hasil "+ response.body);
      }
    }
  }

  saveUser(String? token,String? name) async{
    try{
      print("Lewat SIni" +token!+"|"+name!);
      final SharedPreferences pref = await _prefs;
      pref.setString("name", name);
      pref.setString("token", token);
      Navigator.of(context).push(MaterialPageRoute(builder: (c)=> const HomeScreen()))
          .then((value) {
        setState(() {

        });
      });
    }catch(exp){
      print(exp.toString());
    }
  }

  validateForm(String email, String password) {
    if(emailTxtEdtController.text.isEmpty && passwordTxtEdtController.text.isEmpty){
      fToast?.showToast(
          child: _showToast("Email dan Password Harus Di Isi !"),
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
      login(email, password);
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
                "Silahkan Login",
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
                  validateForm(emailTxtEdtController.text.trim(), passwordTxtEdtController.text.trim());
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

                  },
                  child: const Text(
                    "Belum Pernah Aplikasinya ? Daftar Dong!",
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
