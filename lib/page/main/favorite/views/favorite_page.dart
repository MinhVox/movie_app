// ignore_for_file: prefer_const_constructors

import 'package:final_training_aia/config/routers.dart';
import 'package:final_training_aia/constants/colors.dart';
import 'package:final_training_aia/constants/constants.dart';
import 'package:final_training_aia/helpers/helper.dart';
import 'package:final_training_aia/page/detail/movie_detail/models/movie_detail_entity.dart';
import 'package:final_training_aia/page/main/favorite/bloc/movie_favorite_bloc.dart';
import 'package:final_training_aia/session/session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class FavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String email = ApplicationSesson.shared.credential?.email ?? '';
    return BlocProvider(
      create: (_) => MovieFavoriteBloc()..add(LoadFavList(email)),
      child: FavoriteView(email),
    );
  }
}

class FavoriteView extends StatefulWidget {
  final String email;

  const FavoriteView(this.email);
  @override
  _FavoriteViewState createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  List<MovieFavorrite> list = [];
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MovieFavoriteBloc, MovieFavoriteState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state.status == FavoriteStatus.Processing) {
        } else if (state.status == FavoriteStatus.Success) {
          list = state.list!.list;
          Future.delayed(const Duration(milliseconds: 1000), () {
            setState(() {
              isLoading = false;
            });
          });
        } else if (state.status == FavoriteStatus.Failed) {
          Helpers.shared.showDialogConfirm(context,message: (ApplicationSesson.shared.isOnline ? (state.error ?? 'An error occured' ) : 'Check wifi connection'));
          print(state.error);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: isLoading
                ? Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: GridView.builder(
                      padding: const EdgeInsets.only(top: 10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 7 / 10,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        // mainAxisExtent: 10,
                      ),
                      itemCount: 10,
                      itemBuilder: (cxt, index) {
                        return _buildShimmerFavoriteCard();
                      },
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 7 / 10,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      // mainAxisExtent: 10,
                    ),
                    itemCount: list.length,
                    itemBuilder: (cxt, index) {
                      return _buildFavoriteCard(list[index].movieName,
                          Constants.prefixUrlImg + list[index].imagePath, () {
                        Navigator.pushNamed(context, Routers.movieDetail,
                            arguments: {
                              'id': list[index].movieId,
                              'type': list[index].mediaType
                            }).then((value) {
                          if (value is bool && value) {
                            final bloc = context.read<MovieFavoriteBloc>();
                            bloc.add(LoadFavList(widget.email));
                          }
                        });
                      });
                    },
                  ),
          ),
        );
      },
    );
  }

  Widget _buildFavoriteCard(String name, String img, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.colorFFFFFF,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 19.0 / 19.0,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                child: Image.network(
                  img,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 7, 0, 5),
                child: Text(
                  name,
                  style: TextStyle(fontSize: 15, color: AppColors.color4A4A4A),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

   Widget _buildShimmerFavoriteCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.colorFFFFFF,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: 20.0 / 19.0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5), topRight: Radius.circular(5)),
              child: Container(),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 7, 0, 5),
              child: Text(
                "",
                style: TextStyle(fontSize: 15, color: AppColors.color4A4A4A),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
