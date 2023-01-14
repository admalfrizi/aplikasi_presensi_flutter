import 'dart:convert';

import 'package:aplikasi_presensi/models/home_response_model.dart';
import 'package:aplikasi_presensi/screens/add_loc_screen.dart';
import 'package:aplikasi_presensi/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as myHttp;

import '../components/progress_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> _name, _token;
  HomeResponseModel? homeResponseModel;
  Datum? today;
  List<Datum> riwayat = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _token = _prefs.then((SharedPreferences prefs) {
      return prefs.getString("token") ?? "";
    });

    _name = _prefs.then((SharedPreferences prefs) {
      return prefs.getString("name") ?? "";
    });
  }

  Future<List<dynamic>?> getData() async {
    final Map<String, String> headers = {
      'Authorization': 'Bearer ' + await _token
    };

    var response = await myHttp.get(
        Uri.parse("http://192.168.0.101:8000/api/get-presensi"),
        headers: headers
    );

    homeResponseModel = HomeResponseModel.fromJson(json.decode(response.body));
    riwayat.clear();

    for (var element in homeResponseModel!.data!) {
      if(element!.isHariIni!){
        today = element;
      } else {
        riwayat.add(element);
      }
    }
  }

  Future logout() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c){
          return ProgressDialog(
            msg: "Sedang Di Proses",
          );
        }
    );
    final Map<String, String> headers = {
      'Authorization': 'Bearer ${await _token}'
    };

    var response = await myHttp.post(
        Uri.parse("http://192.168.0.101:8000/api/logout"),
        headers: headers
    );

    if(response.body.isNotEmpty){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('name');
      prefs.remove('token');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=> const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getData(),
        builder: (context, state) {
          if(state.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder(
                      future: _name,
                      builder: (context, state) {
                        if (state.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else {
                          if (state.hasData) {
                            return Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    state.data!,
                                    style: TextStyle(
                                        fontSize: 18
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      logout();
                                    },
                                    child: Icon(Icons.logout),
                                  )
                                ],
                              ),
                            );
                          } else {
                            return Text("-");
                          }
                        }
                      },
                    ),
                    SizedBox(height: 20,),
                    Container(
                      width: 400,
                      decoration: BoxDecoration(
                          color: Colors.blue[800]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              today?.tanggal ?? "-",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      today?.masuk ?? "-",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24
                                      ),
                                    ),
                                    Text(
                                      "Masuk",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      today?.pulang ?? "-",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24
                                      ),
                                    ),
                                    Text(
                                      "Pulang",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Text(
                      "Riwayat Presensi",
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: riwayat.length,
                        itemBuilder: (context, index) => Card(
                          elevation: 0,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(8.0),
                            leading: Text(riwayat[index].tanggal!),
                            title: Row(children: [
                              Column(
                                children: [
                                  Text(riwayat[index].masuk!,
                                      style: TextStyle(fontSize: 18)),
                                  Text("Masuk", style: TextStyle(fontSize: 14))
                                ],
                              ),
                              SizedBox(width: 20),
                              Column(
                                children: [
                                  Text(riwayat[index].pulang!,
                                      style: TextStyle(fontSize: 18)),
                                  Text("Pulang", style: TextStyle(fontSize: 14))
                                ],
                              ),
                            ]),
                          ),
                        ),
                      ),
                    ),                  ],
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (c) => const AddLocScreen()))
              .then((value) {setState(() {});
          });
        },
      ),
    );
  }
}
