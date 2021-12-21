// ignore_for_file: prefer_const_constructors

import 'package:final_training_aia/config/routers.dart';
import 'package:final_training_aia/constants/colors.dart';
import 'package:final_training_aia/constants/constants.dart';
import 'package:final_training_aia/helpers/helper.dart';
import 'package:final_training_aia/page/main/discover/bloc/discover_bloc.dart';
import 'package:final_training_aia/page/main/discover/models/movie_entity.dart';
import 'package:final_training_aia/session/session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class DiscoverPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DiscoverBloc()..add(LoadData()),
      child: DiscoverView(),
    );
  }
}

class DiscoverView extends StatefulWidget {
  @override
  _DiscoverViewState createState() => _DiscoverViewState();
}

class _DiscoverViewState extends State<DiscoverView> {
  List<MoviePopular> listPo = [];
  List<MovieUpcoming> listUp = [];
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DiscoverBloc, DiscoverState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state.status == DiscoverStatus.Processing) {
        } else if (state.status == DiscoverStatus.PopularSuccess) {
          listPo = state.popularData!.list.take(10).toList();
        } else if (state.status == DiscoverStatus.PopularFailed) {
          print(state.error);
          Helpers.shared.showDialogConfirm(context,message: (ApplicationSesson.shared.isOnline ? (state.error ?? 'An error occured' ) : 'Check wifi connection'));
        } else if (state.status == DiscoverStatus.UpcomingSuccess) {
          listUp = state.upcomingData!.list.take(10).toList();
          Future.delayed(const Duration(milliseconds: 1000), () {
            setState(() {
              isLoading = false;
            });
          });
        } else if (state.status == DiscoverStatus.UpcomingFailed) {
          print(state.error);
          
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.only(left: 10, top: 10),
            child: SingleChildScrollView(
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle('Most Popular', () => {}),
                  SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: !isLoading,
                    child: SizedBox(
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: listPo.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: _buildMovieCard(
                                listPo[index].originalName,
                                Constants.prefixUrlImg + listPo[index].imgPath,
                                listPo[index].voteAverage ?? "", () {
                              print(listPo[index].id);
                              Navigator.pushNamed(context, Routers.movieDetail,
                                  arguments: {
                                    'id': listPo[index].id,
                                    'type': 0
                                  });
                            }),
                          );
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isLoading,
                    child: SizedBox(
                      height: 250,
                      child: Shimmer.fromColors(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: _buildShimmerMovieCard(),
                            );
                          },
                        ),
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  // _buildTitle('Most Recent', () => {}),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // SizedBox(
                  //   height: 250,
                  //   child: ListView.builder(
                  //     scrollDirection: Axis.horizontal,
                  //     itemCount: 10,
                  //     itemBuilder: (BuildContext context, int index) {
                  //       return Padding(
                  //         padding: EdgeInsets.only(right: 10),
                  //         child: _buildMovieCard('The Best of Me',
                  //             'assets/img_bg/bg_signin.png', '1h, 25mins', () {
                  //           Navigator.pushNamed(context, Routers.movieDetail);
                  //         }),
                  //       );
                  //     },
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 25,
                  // ),
                  _buildTitle('Comming Soon', () => {}),
                  SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: !isLoading,
                    child: SizedBox(
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: listUp.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: _buildMovieCard(
                                listUp[index].originalName,
                                Constants.prefixUrlImg + listUp[index].imgPath,
                                listUp[index].voteAverage ?? "",
                                () {
                                  Navigator.pushNamed(context, Routers.movieDetail,
                                  arguments: {
                                    'id': listUp[index].id,
                                    'type': 1
                                  });
                                }),
                          );
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isLoading,
                    child: SizedBox(
                      height: 250,
                      child: Shimmer.fromColors(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: _buildShimmerMovieCard(),
                            );
                          },
                        ),
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle(String title, Function() onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, color: AppColors.color4A4A4A),
        ),
        InkWell(
          onTap: () {},
          child: Row(
            children: [
              Text(
                'See All',
                style: TextStyle(fontSize: 17, color: AppColors.color0294A5),
              ),
              SizedBox(width: 10),
              Icon(
                Icons.navigate_next,
                color: AppColors.color0294A5,
                size: 25,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMovieCard(
      String title, String img, String time, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: AppColors.colorFFFFFF,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5), topRight: Radius.circular(5)),
              child: Image.network(
                img,
                width: 160,
                height: 190,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 7, 14, 5),
              child: Text(
                title,
                style: TextStyle(fontSize: 17, color: AppColors.color4A4A4A),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
              child: Text(
                time,
                style: TextStyle(fontSize: 14, color: AppColors.color9B9B9B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerMovieCard() {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: AppColors.colorFFFFFF,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            child: Container(
              width: 160,
              height: 190,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 7, 14, 5),
            child: Text(
              "",
              style: TextStyle(fontSize: 17, color: AppColors.color4A4A4A),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: Text(
              "",
              style: TextStyle(fontSize: 14, color: AppColors.color9B9B9B),
            ),
          ),
        ],
      ),
    );
  }
}
