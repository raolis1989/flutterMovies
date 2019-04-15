import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:movieapp/models/movieModel.dart';
import 'package:carousel_slider/carousel_slider.dart';

const baseUrl = "https://api.themoviedb.org/3/movie/";
const baseImagesUrl = "https://image.tmdb.org/t/p/";
const apiKey = "71877226423b3a2c057a1deda88f162e";

const nowPlayingUrl = "${baseUrl}now_playing?api_key=$apiKey";
const upcomingUrl = "${baseUrl}upcoming?api_key=$apiKey";
const popularUrl = "${baseUrl}popular?api_key=$apiKey";
const topRateUrl = "${baseUrl}top_rated?api_key=$apiKey";

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie App',
      theme: ThemeData.dark(),
      home: MyMovieApp(),
    ));

class MyMovieApp extends StatefulWidget {
  @override
  _MyMovieApp createState() => new _MyMovieApp();
}

class _MyMovieApp extends State<MyMovieApp> {
  Movie nowPlayinMovies;
  Movie upcomingMovies;
  Movie popularMovies;
  Movie topRatedMovies;
  int heroTag=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchNowPlayingMovies();
    _fetchUpcomingMovies();
    _fetchPopularMovies();
    _fetchTopRatedMovies();
  }

  void _fetchUpcomingMovies() async {
    var response = await http.get(upcomingUrl);
    var decodeJson = jsonDecode(response.body);
    setState(() {
      upcomingMovies = Movie.fromJson(decodeJson);
    });
  }

  void _fetchPopularMovies() async {
    var response = await http.get(popularUrl);
    var decodeJson = jsonDecode(response.body);
    setState(() {
      popularMovies = Movie.fromJson(decodeJson);
    });
  }

  void _fetchTopRatedMovies() async {
    var response = await http.get(topRateUrl);
    var decodeJson = jsonDecode(response.body);
    setState(() {
      topRatedMovies = Movie.fromJson(decodeJson);
    });
  }

  void _fetchNowPlayingMovies() async {
    var response = await http.get(nowPlayingUrl);
    var decodeJson = jsonDecode(response.body);
    setState(() {
      nowPlayinMovies = Movie.fromJson(decodeJson);
    });
  }

  Widget _builCarouselSlider() => CarouselSlider(
        items: nowPlayinMovies == null
            ? <Widget>[
                Center(
                  child: CircularProgressIndicator(),
                )
              ]
            : nowPlayinMovies.results
                .map((movieItem) => _buildMovieITem(movieItem))
                .toList(),
        autoPlay: false,
        height: 240,
        viewportFraction: 0.5,
      );

  Widget _buildMovieITem(Results movieItem) {
    heroTag+=1;
    return Material(
      elevation: 15.0,
      child: InkWell(
        onTap: () {},
        child: Hero(
          tag: heroTag,
          child: Image.network(
            "${baseImagesUrl}w342${movieItem.posterPath}",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildMovieListItem(Results movieItem) => Material(
        child: Container(
          width: 128.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(6.0),
                  child: _buildMovieITem(movieItem)),
              Padding(
                padding: EdgeInsets.only(left: 6.0, top: 2.0),
                child: Text(
                  movieItem.title,
                  style: TextStyle(fontSize: 8.0),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 6.0, top: 2.0),
                  child: Text(
                    movieItem.releaseDate,
                    style: TextStyle(fontSize: 8.0),
                  ))
            ],
          ),
        ),
      );

  Widget _buidlMoviesListView(Movie movie, String movieListTitle) => Container(
        height: 258.0,
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(left: 7.0, bottom: 7.0),
                child: Text(movieListTitle,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[400]))),
            Flexible(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: movie == null
                    ? <Widget>[Center(child: CircularProgressIndicator())]
                    : movie.results.map((movieItem) => Padding(
                          padding: EdgeInsets.only(left: 6.0, right: 2.0),
                          child: _buildMovieListItem(movieItem),
                        )).toList(),
              ),
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          'Movie App',
          style: TextStyle(
              color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text('NOW PLAYING',
                      style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              expandedHeight: 290.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: <Widget>[
                    Container(
                      child: Image.network(
                        "${baseImagesUrl}w500/xnopI5Xtky18MPhK40cZAGAOVeV.jpg",
                        fit: BoxFit.cover,
                        width: 1000.0,
                        colorBlendMode: BlendMode.dstATop,
                        color: Colors.blue.withOpacity(0.5),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 35.0),
                        child: _builCarouselSlider())
                  ],
                ),
              ),
            )
          ];
        },
        body: ListView(
          children: <Widget>[
            _buidlMoviesListView(upcomingMovies,'COMING SOON'),
            _buidlMoviesListView(popularMovies , 'POPULAR'),
            _buidlMoviesListView(topRatedMovies, 'TOP RATED')
          ],
        ),
      ),
    );
  }
}
