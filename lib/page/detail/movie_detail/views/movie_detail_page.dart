// ignore_for_file: prefer_const_constructors

import 'package:collection/src/iterable_extensions.dart';
import 'package:final_training_aia/config/routers.dart';
import 'package:final_training_aia/constants/colors.dart';
import 'package:final_training_aia/constants/constants.dart';
import 'package:final_training_aia/helpers/helper.dart';
import 'package:final_training_aia/page/detail/movie_detail/bloc/movie_detail_bloc.dart';
import 'package:final_training_aia/page/detail/movie_detail/models/movie_detail_entity.dart';
import 'package:final_training_aia/page/detail/movie_detail/widgets/artist.dart';

import 'package:final_training_aia/page/detail/movie_detail/widgets/more_movie.dart';
import 'package:final_training_aia/page/detail/movie_detail/widgets/reviewer.dart';
import 'package:final_training_aia/services/authentication_service.dart';
import 'package:final_training_aia/session/session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readmore/readmore.dart';

class MovieDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final argument = ModalRoute.of(context)!.settings.arguments as Map;
    int id = argument['id'];
    int type = argument['type'];
    String email = ApplicationSesson.shared.credential?.email ?? '';
    return BlocProvider(
      create: (context) =>
          MovieDetailBloc()..add(LoadMovieDetail(id, type, email)),
      child: MovieDetailView(email, id, type),
    );
  }
}

class MovieDetailView extends StatefulWidget {
  final String email;
  final int id;
  final int type;
  MovieDetailView(this.email, this.id, this.type);

  @override
  _MovieDetailViewState createState() => _MovieDetailViewState();
}

class _MovieDetailViewState extends State<MovieDetailView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  String img = '';
  bool isFavorite = false;
  List<MovieFavorrite> listFav = [];
  List arrayJson = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MovieDetailBloc, MovieDetailState>(
      listener: (context, state) {
        if (state.status == MovieDetailStatus.Processing) {
          Helpers.shared.showDialogProgress(context);
        } else if (state.status == MovieDetailStatus.Success) {
          Helpers.shared.hideDialogProgress(context);
          img = Constants.prefixUrlImg + state.data!.posterPath;
        } else if (state.status == MovieDetailStatus.Failed) {
          Helpers.shared.hideDialogProgress(context);
          print(state.error);
        } else if (state.status == MovieDetailStatus.GetFavoriteSuccess) {
          listFav = state.list!.list;
          // check IsFavoriteMovie
          final first = state.list!.list
              .firstWhereOrNull((mem) => mem.movieId == widget.id);
          if (first != null) {
            setState(() {
              isFavorite = true;
            });
          }
          // convert to Json array
          listFav.forEach((e) {
            arrayJson.add({
              "mediaType": e.mediaType,
              "movieId": e.movieId,
              "movieName": e.movieName,
              "imagePath": e.imagePath,
              "dateTimeCreated": e.dateTimeCreated
            });
          });
        } else if (state.status == MovieDetailStatus.GetFavoriteFailed) {
          print(state.error);
          Helpers.shared.showDialogConfirm(context,message: (ApplicationSesson.shared.isOnline ? (state.error ?? 'An error occured' ) : 'Check wifi connection'));
        }
      },
      builder: (context, state) {
        return Scaffold(
            backgroundColor: AppColors.colorFFFFFF,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 250,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                         
                        Image.network(
                          img,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return const Text('😢');
                          },
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                        Container(
                          width: double.infinity,
                          height: 250,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 0, color: AppColors.colorFFFFFF),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  AppColors.colorFFFFFF,
                                ],
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  icon: Icon(
                                    Icons.arrow_back_ios,
                                    color: AppColors.colorFFFFFF,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  }),
                              IconButton(
                                  icon: Icon(
                                    Icons.favorite,
                                    color: isFavorite
                                        ? Colors.red
                                        : AppColors.colorFFFFFF,
                                  ),
                                  onPressed: () {
                                    //
                                    setState(() {
                                      isFavorite = !isFavorite;
                                    });
                                    AuthenticationService service =
                                        AuthenticationService();
                                    if (isFavorite) {
                                      arrayJson.add({
                                        "mediaType": widget.type,
                                        "movieId": widget.id,
                                        "movieName": state.data?.name ?? '',
                                        "imagePath":
                                            state.data?.posterPath ?? '',
                                        "dateTimeCreated":
                                            state.data?.firstAirDate ?? ''
                                      });
                                      service.addNewFavorite(
                                          email: widget.email,
                                          array: arrayJson);
                                    } else {
                                      arrayJson.removeWhere(
                                          (e) => e["movieId"] == widget.id);
                                      service.addNewFavorite(
                                          email: widget.email,
                                          array: arrayJson);
                                    }
                                  }),
                            ],
                          ),
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(Routers.trailer);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(60 / 2),
                              child: Container(
                                color: Colors.black38,
                                child: Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 60,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          img,
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.3,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return const Text('😢');
                          },
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (state.data?.name ?? ''),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                  overflow: TextOverflow.clip,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                    state.data?.genres.list
                                            .map((e) => e.name)
                                            .join(" | ") ??
                                        '',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: _buildRating(
                                          state.data?.voteAverage ?? 0),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      (state.data?.voteAverage.toString() ??
                                              '0') +
                                          ' / 10',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                    'Language: ' +
                                        (state.data?.originalLanguage
                                                .toUpperCase() ??
                                            ''),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                    )),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(state.data?.firstAirDate ?? '',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                        )),
                                    SizedBox(
                                      width: 25,
                                    ),
                                    Text('2h 10m',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  _buildOverView(state.data?.overview ?? ''),
                  TabBar(
                    controller: _tabController,
                    labelColor: AppColors.color0294A5,
                    unselectedLabelColor: AppColors.color8899A6,
                    indicatorColor: AppColors.color0294A5,
                    tabs: [
                      Tab(
                        text: 'Cast',
                      ),
                      Tab(
                        text: 'Reviews',
                      ),
                      Tab(
                        text: 'More',
                      ),
                    ],
                  ),
                  Visibility(
                      visible: _currentIndex == 0,
                      child: ArtistList(
                        list: state.data?.createdBy.list ?? [],
                      )),
                  Visibility(visible: _currentIndex == 1, child: Reviewer()),
                  Visibility(visible: _currentIndex == 2, child: MoreList()),
                ],
              ),
            ));
      },
    );
  }

  Widget _buildOverView(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: ReadMoreText(
        text,
        style: TextStyle(
          color: AppColors.color4A4A4A,
          fontSize: 15,
        ),
        trimLines: 2,
        trimMode: TrimMode.Line,
      ),
    );
  }

  List<Widget> _buildRating(double rating) {
    List<Widget> _listStar = [];
    double numS = rating / 2;
    for (var i = 1; i <= 5; i++) {
      _listStar.add(Icon(Icons.star,
          color: (i < numS) ? AppColors.colorFEB900 : AppColors.colorD8D8D8));
    }
    return _listStar;
  }
}
