import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_moviedb/Provider/provider.dart';
import 'package:flutter_moviedb/YouTube%20Player/youtubeplayer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class MovieDetailsPage extends StatefulWidget {
  final trandingdata;
  const MovieDetailsPage({Key? key, this.trandingdata}) : super(key: key);

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  PageController? pageController;
  Box? trailerimage;
  bool? showgenrename(data, List genreid) {
    if (genreid.any((element) => element == data['id'])) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    Hive.box('trailerimage');
    pageController =
        PageController(initialPage: 0, keepPage: false, viewportFraction: 0.5);
    movievideo();
  }

  movievideo() async {
    await Provider.of<ProviderData>(context, listen: false)
        .getmovievideo(widget.trandingdata['id']);
  }

  final cachedmanager = CacheManager(
    Config(
      'Posterimage',
      stalePeriod: Duration(days: 7),
    ),
  );

  final trailer = CacheManager(
    Config(
      'trailerimage',
      maxNrOfCacheObjects: 100,
      stalePeriod: Duration(days: 7),
    ),
  );

  @override
  Widget build(BuildContext context) {
    List genreid = widget.trandingdata['genre_ids'];
    final providerdata = Provider.of<ProviderData>(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 550.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.loose,
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    child: CachedNetworkImage(
                      cacheManager: cachedmanager,
                      key: UniqueKey(),
                      imageUrl:
                          "https://image.tmdb.org/t/p/w500${widget.trandingdata['poster_path']}",
                      fit: BoxFit.cover,
                    ),
                    // child: Image.network(
                    //   "https://image.tmdb.org/t/p/w500${widget.trandingdata['poster_path']}",
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                  Container(
                    child: SvgPicture.asset(
                      'images/icon/play-button.svg',
                      height: 50,
                    ),
                  )
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(
                top: 5.0,
                left: 10.0,
                right: 10.0,
                bottom: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'images/icon/star.svg',
                              height: 15,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              "${widget.trandingdata['vote_average']}",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Container(
                          height: 26.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: providerdata.genresdata!.length,
                            itemBuilder: (context, index) {
                              var data = providerdata.genresdata![index];
                              return Container(
                                margin: showgenrename(data, genreid) == true
                                    ? EdgeInsets.only(left: 5.0)
                                    : EdgeInsets.zero,
                                padding: showgenrename(data, genreid) == true
                                    ? EdgeInsets.all(5.0)
                                    : EdgeInsets.zero,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: showgenrename(data, genreid) == true
                                    ? Text(
                                        data['name'],
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.bold),
                                      )
                                    : null,
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 25.0),
                  Container(
                    child: Text(
                      widget.trandingdata['original_title'],
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    child: Text(
                      widget.trandingdata['overview'],
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    child: Text(
                      "Language: ${widget.trandingdata['original_language']}",
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    child: Text(
                      "Release : ${widget.trandingdata['release_date']}",
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    child: Text(
                      "Vote : ${widget.trandingdata['vote_count']}",
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    child: Text(
                      "Trailer:",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: PageView.builder(
                      itemCount: providerdata.movievideo!.length,
                      itemBuilder: (context, index) {
                        var movievideo = providerdata.movievideo![index];
                        return AnimatedBuilder(
                          animation: pageController!,
                          builder: (context, child) {
                            return Center(
                              child: SizedBox(
                                height: 200.0,
                                width: 300.0,
                                child: child,
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => YoutubePlayerPage(
                                      youtubeurl: movievideo['key'],
                                    ),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(10.0),
                              child: Stack(
                                fit: StackFit.loose,
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 200.0,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: CachedNetworkImage(
                                        cacheManager: trailer,
                                        key: UniqueKey(),
                                        imageUrl:
                                            "https://i3.ytimg.com/vi/${movievideo['key']}/hqdefault.jpg",
                                        fit: BoxFit.cover,
                                      ),
                                      // child: Image.network(
                                      //   "https://i3.ytimg.com/vi/${movievideo['key']}/hqdefault.jpg",
                                      //   fit: BoxFit.cover,
                                      // ),
                                    ),
                                  ),
                                  Container(
                                    child: SvgPicture.asset(
                                      'images/icon/play-button.svg',
                                      height: 35,
                                    ),
                                  )
                                ],
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
          )
        ],
      ),
    );
  }
}
