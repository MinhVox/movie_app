// ignore_for_file: prefer_const_constructors

import 'package:final_training_aia/config/routers.dart';
import 'package:final_training_aia/constants/colors.dart';
import 'package:final_training_aia/constants/constants.dart';
import 'package:final_training_aia/helpers/helper.dart';
import 'package:final_training_aia/page/detail/artist_detail/bloc/artist_detail_bloc.dart';
import 'package:final_training_aia/page/detail/artist_detail/models/artist_detail_entity.dart';
import 'package:final_training_aia/page/detail/movie_detail/widgets/artist.dart';
import 'package:final_training_aia/page/detail/movie_detail/widgets/more_movie.dart';
import 'package:final_training_aia/page/detail/movie_detail/widgets/reviewer.dart';
import 'package:final_training_aia/session/session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArtistDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final argument = ModalRoute.of(context)!.settings.arguments as Map;
    int id = argument['id'];
    return BlocProvider(
      create: (context) => ArtistDetailBloc()..add(LoadArtistDetail(id)),
      child: ArtistDetailView(),
    );
  }
}

class ArtistDetailView extends StatefulWidget {
  @override
  _ArtistDetailViewState createState() => _ArtistDetailViewState();
}

class _ArtistDetailViewState extends State<ArtistDetailView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  List<ArtistImage> _listImg = [];
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
    final size = MediaQuery.of(context).size;
    return BlocConsumer<ArtistDetailBloc, ArtistDetailState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state.status == ArtistDetailStatus.Processing) {
          Helpers.shared.showDialogProgress(context);
        } else if (state.status == ArtistDetailStatus.Success) {
          Helpers.shared.hideDialogProgress(context);
        } else if (state.status == ArtistDetailStatus.Failed) {
          Helpers.shared.hideDialogProgress(context);
          Helpers.shared.showDialogConfirm(context,message: (ApplicationSesson.shared.isOnline ? (state.error ?? 'An error occured' ) : 'Check wifi connection'));
        } else if (state.status == ArtistDetailStatus.GetImgSuccess) {
          Helpers.shared.hideDialogProgress(context);
          _listImg = state.list?.list ?? [];
        } else if (state.status == ArtistDetailStatus.GetImgFailed) {
          Helpers.shared.hideDialogProgress(context);
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
                    height: 300,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          Constants.prefixUrlImg +
                              (state.data?.profilePath ?? ''),
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
                          height: 300,
                          decoration: BoxDecoration(
                              // border: Border.all(width: 0,color: AppColors.colorFFFFFF),
                              gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColors.color4A4A4A,
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
                                    Navigator.of(context).pop();
                                  }),
                              IconButton(
                                  icon: Icon(
                                    Icons.favorite,
                                    color: AppColors.colorFFFFFF,
                                  ),
                                  onPressed: () {
                                    // Do something.
                                  }),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.data?.name ?? '',
                                style: TextStyle(
                                    color: AppColors.colorFFFFFF, fontSize: 25),
                              ),
                              Text(
                                ((state.data?.gender ?? 1) == 2
                                        ? 'Actor'
                                        : "Actress") +
                                    ' | ' +
                                    (state.data?.birthday ?? ''),
                                style: TextStyle(
                                    color: AppColors.colorFFFFFF, fontSize: 17),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Image.network(
                            Constants.prefixUrlImg +
                                (_listImg.length != 0
                                    ? _listImg[0].imagePath
                                    : '/8uO0gUM8aNqYLs1OsTBQiXu0fEv.jpg'),
                            height: size.width / 4,
                            width: size.width / 4,
                            fit: BoxFit.fitHeight,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
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
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, Routers.artistImg,
                            arguments: {
                              'img': _listImg,
                            });
                            },
                            child: Container(
                              height: size.width / 4,
                              width: size.width / 4,
                              color: AppColors.color0294A5.withOpacity(0.8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _listImg.length.toString() + '+',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: AppColors.colorFFFFFF),
                                  ),
                                  Text(
                                    'See more ',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: AppColors.colorFFFFFF),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      Image.network(
                        Constants.prefixUrlImg +
                            (_listImg.length > 1
                                ? _listImg[1].imagePath
                                : '/8uO0gUM8aNqYLs1OsTBQiXu0fEv.jpg'),
                        height: size.width / 4,
                        width: size.width / 4,
                        fit: BoxFit.fitHeight,
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
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                      Image.network(
                        Constants.prefixUrlImg +
                            (_listImg.length > 2
                                ? _listImg[2].imagePath
                                : '/8uO0gUM8aNqYLs1OsTBQiXu0fEv.jpg'),
                        height: size.width / 4,
                        width: size.width / 4,
                        fit: BoxFit.fitHeight,
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
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                      Image.network(
                        Constants.prefixUrlImg +
                            (_listImg.length > 3
                                ? _listImg[3].imagePath
                                : '/8uO0gUM8aNqYLs1OsTBQiXu0fEv.jpg'),
                        height: size.width / 4,
                        width: size.width / 4,
                        fit: BoxFit.fitHeight,
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
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  TabBar(
                    controller: _tabController,
                    labelColor: AppColors.color0294A5,
                    unselectedLabelColor: AppColors.color8899A6,
                    indicatorColor: AppColors.color0294A5,
                    tabs: [
                      Tab(
                        text: 'Summary',
                      ),
                      Tab(
                        text: 'Movies',
                      ),
                      Tab(
                        text: 'More',
                      ),
                    ],
                  ),
                  Visibility(
                      visible: _currentIndex == 0,
                      child: _buildSumary(state.data?.placeOfBirth ?? '',
                          state.data?.biography ?? '')),
                  Visibility(visible: _currentIndex == 1, child: MoreList()),
                  Visibility(visible: _currentIndex == 2, child: MoreList()),
                ],
              ),
            ));
      },
    );
  }

  Widget _buildSumary(String place, String biology) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(place),
          SizedBox(
            height: 10,
          ),
          Text(biology)
        ],
      ),
    );
  }
}
