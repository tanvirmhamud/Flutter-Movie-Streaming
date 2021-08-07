import 'package:flutter/material.dart';
import 'package:flutter_moviedb/Pages/Movie.dart';
import 'package:flutter_moviedb/Pages/Mylist.dart';
import 'package:flutter_moviedb/Pages/Series.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int pagenum = 0;

  headertext(String pagename, int textnum) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text(
        pagename,
        style: TextStyle(
          color: pagenum == textnum ? Color(0xFFFF4800) : Color(0xFF000000),
          fontFamily: 'Nunito',
          fontSize: 17,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xEFFFFFFF),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  headertext("Series", 0),
                  headertext("Movie", 1),
                  headertext("Mylist", 2),
                ],
              ),
              Flexible(
                child: PageView(
                  onPageChanged: (value) {
                    setState(() {
                      pagenum = value;
                    });
                  },
                  children: [
                    SeriesPage(),
                    MoviePage(),
                    Mylist(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
