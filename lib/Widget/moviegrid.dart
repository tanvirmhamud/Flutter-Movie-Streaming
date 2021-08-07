import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_moviedb/Pages/movie_details.dart';
import 'package:flutter_moviedb/Provider/provider.dart';
import 'package:provider/provider.dart';

class MovieGridPage extends StatefulWidget {
  const MovieGridPage({Key? key}) : super(key: key);

  @override
  _MovieGridPageState createState() => _MovieGridPageState();
}

class _MovieGridPageState extends State<MovieGridPage> {
  @override
  Widget build(BuildContext context) {
    final providerdata = Provider.of<ProviderData>(context);
    return NestedScrollView(
        headerSliverBuilder: (context, innerBoxScrolled) => [
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
        body: Container());
  }
}
