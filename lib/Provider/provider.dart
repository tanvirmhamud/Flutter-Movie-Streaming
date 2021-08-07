import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class ProviderData extends ChangeNotifier {
  List? resultdata = [];
  List? genresdata = [];
  List? movievideo = [];
  Box? trandingbox;
  Box? genresbox;
  Box? movievideobox;

  Future trandingdata() async {
    trandingbox = Hive.box('trandingdata');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      trandingbox!.clear();
      try {
        String url =
            "https://api.themoviedb.org/3/movie/popular?api_key=0b64eff7e87e6af9905013afe5607503&language=en-US&page=1";
        var response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          notifyListeners();
          var jsondata = json.decode(response.body);
          trandingdataadd(jsondata['results']);
          notifyListeners();
        }
      } catch (e) {}
      resultdata = trandingbox!.toMap().values.toList();
      notifyListeners();
    } else {
      resultdata = trandingbox!.toMap().values.toList();
      print("internet nai ga");
    }
  }

  Future trandingdataadd(result) async {
    trandingbox = Hive.box('trandingdata');
    trandingbox!.clear();
    notifyListeners();
    for (var d in result) {
      trandingbox!.add(d);
      notifyListeners();
    }
  }

  Future getgenresdata() async {
    genresbox = Hive.box('genres');
    var connectivityResult = await (Connectivity().checkConnectivity());
    String url =
        "https://api.themoviedb.org/3/genre/movie/list?api_key=0b64eff7e87e6af9905013afe5607503&language=en-US";
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        genresbox!.clear();
        var response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          var jsondata = json.decode(response.body);
          genresdataadd(jsondata['genres']);
          notifyListeners();
        }
      } catch (e) {}
      genresdata = genresbox!.toMap().values.toList();
      notifyListeners();
    } else {
      genresdata = genresbox!.toMap().values.toList();
      notifyListeners();
    }
  }

  Future genresdataadd(_genresdata) async {
    genresbox!.clear();
    for (var d in _genresdata) {
      genresbox!.add(d);
    }
    notifyListeners();
  }

  Future getmovievideo(int movieid) async {
    movievideobox = Hive.box('movievideo');
    var connectivityResult = await (Connectivity().checkConnectivity());
    String url =
        // ignore: unnecessary_brace_in_string_interps
        "https://api.themoviedb.org/3/movie/${movieid}/videos?api_key=0b64eff7e87e6af9905013afe5607503&language=en-US";
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        movievideobox!.clear();
        var response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          var jsondata = jsonDecode(response.body);
          addmovievideo(jsondata['results']);
          notifyListeners();
        }
      } catch (e) {}
      movievideo = movievideobox!.toMap().values.toList();
      notifyListeners();
    } else {
      movievideo = movievideobox!.toMap().values.toList();
      notifyListeners();
    }
  }

  Future addmovievideo(data) async {
    movievideobox!.clear();
    for (var d in data) {
      movievideobox!.add(d);
    }
    notifyListeners();
  }
}
