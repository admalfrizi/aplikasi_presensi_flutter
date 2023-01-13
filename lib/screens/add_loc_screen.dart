import 'dart:convert';

import 'package:aplikasi_presensi/models/save_presensi_response_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:http/http.dart' as myHttp;

class AddLocScreen extends StatefulWidget {
  const AddLocScreen({Key? key}) : super(key: key);

  @override
  State<AddLocScreen> createState() => _AddLocScreenState();
}

class _AddLocScreenState extends State<AddLocScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> _token;
  FToast? fToast;

  Future<LocationData?> _currentLocation() async {
    bool serviceEnable;
    PermissionStatus permissionGranted;
    Location location = new Location();

    serviceEnable = await location.serviceEnabled();
    if (!serviceEnable) {
      serviceEnable = await location.requestService();
      if (!serviceEnable) {
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    return await location.getLocation();
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

  Future savePresensi(latitude, longitude) async{
    SavePresensiResponseModel savePresensiResponseModel;

    Map<String,String> body = {
      "latitude": latitude.toString(),
      "longitude": longitude.toString()
    };

    Map<String, String> headers = {
      'Authorization': 'Bearer ' + await _token,
      'Content-Type': 'application/json',
      'Charset': 'utf-8'
    };
    
    var response = await myHttp.post(
        Uri.parse("http://192.168.0.101:8000/api/save-presensi"),
        body: jsonEncode(body),
        headers: headers
    );

    savePresensiResponseModel = SavePresensiResponseModel.fromJson(json.decode(response.body));

    if(savePresensiResponseModel.meta?.code == 200){
      fToast?.showToast(
          child: _showToast("Presensi Anda Telah Tersimpan"),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 3)
      );
      Navigator.pop(context);
    } else {
      fToast?.showToast(
          child: _showToast("Gagal Menyimpan !"),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 3)
      );
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast?.init(context);
    _token = _prefs.then((SharedPreferences prefs) {
      return prefs.getString("token") ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Lokasi Anda"),
        elevation: 0,
      ),
      body: FutureBuilder<LocationData?>(
        future: _currentLocation(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.hasData){
            final LocationData currentLoc = snapshot.data;
            return SafeArea(
              child: Column(
                children: [
                  Container(
                    height: 300,
                    child: SfMaps(
                        layers: [
                          MapTileLayer(
                            initialFocalLatLng: MapLatLng(currentLoc.latitude!, currentLoc.longitude!),
                            initialZoomLevel: 15,
                            initialMarkersCount: 1,
                            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                            markerBuilder: (BuildContext context, int index){
                              return MapMarker(
                                  latitude: currentLoc.latitude!,
                                  longitude: currentLoc.longitude!,
                                  child: Icon(Icons.location_on, color: Colors.red,),
                              );
                            },
                          ),
                        ]
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: (){
                        savePresensi(currentLoc.latitude, currentLoc.longitude);
                      },
                      child: Text(
                        "Simpan Presensi Anda"
                      )
                  )
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
