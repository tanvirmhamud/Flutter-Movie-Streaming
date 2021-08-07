import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_moviedb/Pages/movie_details.dart';
import 'package:flutter_moviedb/Provider/provider.dart';
import 'package:flutter_moviedb/Widget/moviegrid.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class SliverMoviePage extends StatefulWidget {
  const SliverMoviePage({Key? key}) : super(key: key);

  @override
  _SliverMoviePageState createState() => _SliverMoviePageState();
}

class _SliverMoviePageState extends State<SliverMoviePage> {
  PageController? _pageController;
  int correntpage = 0;
  int genresnum = 0;
  int? genresid;
  int? id;

  String genrename = "Action";

  static final cachedmanager = CacheManager(
    Config(
      'CustomCachkey',
      stalePeriod: Duration(days: 7),
    ),
  );

  @override
  void initState() {
    httpsetdata();
    _pageController =
        PageController(initialPage: 0, keepPage: false, viewportFraction: 0.8);
    super.initState();
  }

  httpsetdata() async {
    await Provider.of<ProviderData>(context, listen: false).trandingdata();
    await Provider.of<ProviderData>(context, listen: false).getgenresdata();
    await Provider.of<ProviderData>(context, listen: false).getgenresmovie();
  }

  @override
  Widget build(BuildContext context) {
    final providerdata = Provider.of<ProviderData>(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(top: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10.0),
                    child: Text(
                      "Trending Now",
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: PageView.builder(
                      onPageChanged: (value) {
                        setState(() {
                          correntpage = value;
                        });
                      },
                      controller: _pageController,
                      itemCount: providerdata.resultdata!.length,
                      itemBuilder: (context, index) {
                        var result = providerdata.resultdata![index];

                        return AnimatedBuilder(
                          animation: _pageController!,
                          builder: (context, child) {
                            double value = 1;
                            if (_pageController!.position.haveDimensions) {
                              value = _pageController!.page! - index;
                              value = (1 - (value.abs() * 0.4)).clamp(0.0, 1.0);
                            }
                            return Center(
                              child: SizedBox(
                                height: Curves.easeOut.transform(value) * 200,
                                width: 400.0,
                                child: child,
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 10.0, right: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xFF000000).withOpacity(0.3),
                                    blurRadius: 12.0,
                                    offset: Offset(1.0, 1.0) // darker color
                                    ),
                                BoxShadow(
                                    color: Color(0xFFFFFFFF).withOpacity(0.5),
                                    blurRadius: 12.0,
                                    offset: Offset(-1.0, -1.0) // darker color
                                    ),
                              ],
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MovieDetailsPage(
                                      trandingdata: result,
                                    ),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(10.0),
                              child: Stack(
                                children: [
                                  Container(
                                    height: 200,
                                    width: 400.0,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: CachedNetworkImage(
                                        cacheManager: cachedmanager,
                                        key: UniqueKey(),
                                        imageUrl:
                                            "https://image.tmdb.org/t/p/w500${result['backdrop_path']}",
                                        fit: BoxFit.cover,
                                      ),
                                      // child: Image.network(
                                      //   "https://image.tmdb.org/t/p/w500${result['backdrop_path']}",
                                      //   fit: BoxFit.cover,
                                      // ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(10.0),
                                    child: Container(
                                      padding: EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                          color: Colors.deepOrange,
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      child: Text(
                                        result['original_title'],
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Nunito',
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      child: SvgPicture.asset(
                                        'images/icon/play-button.svg',
                                        height: 40.0,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(maxHeight: 45.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: providerdata.genresdata!.length,
                      itemBuilder: (context, index) {
                        var genres = providerdata.genresdata![index];
                        return Container(
                          child: Container(
                            margin: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                                color: genresnum == index
                                    ? Colors.deepPurple
                                    : Colors.deepOrange,
                                borderRadius: BorderRadius.circular(50)),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    genresnum = index;
                                    genrename = genres['name'];
                                    providerdata.getgenreid(genres['id']);
                                    providerdata.getgenresmovie();
                                  });
                                },
                                borderRadius: BorderRadius.circular(50),
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 5.0,
                                      bottom: 5.0,
                                      left: 20.0,
                                      right: 20.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    genres['name'],
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Text(
                              "${genrename} Movie",
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.2,
                              ),
                            ),
                            Container(
                              child: Divider(
                                color: Colors.black,
                                thickness: 10.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, index) {
                var genremoviedata = providerdata.genresmovie![index];
                return Container(
                  margin: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailsPage(
                              trandingdata: genremoviedata,
                            ),
                          ));
                    },
                    borderRadius: BorderRadius.circular(10.0),
                    child: Stack(
                      children: [
                        Container(
                          height: 300.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://image.tmdb.org/t/p/w500${genremoviedata['backdrop_path']}",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(10.0),
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            genremoviedata['original_title'],
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Nunito',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            margin: EdgeInsets.all(10.0),
                            padding: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: Colors.deepOrange,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Text(
                              genremoviedata['vote_average'].toString(),
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Nunito',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
              childCount: providerdata.genresmovie!.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 4,
              mainAxisSpacing: 5,
            ),
          )
        ],
      ),
    );
  }
}
