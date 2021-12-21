import 'package:final_training_aia/constants/colors.dart';
import 'package:final_training_aia/helpers/helper.dart';
import 'package:final_training_aia/page/main/genres/bloc/genres_bloc.dart';
import 'package:final_training_aia/page/main/genres/models/genres_entity.dart';
import 'package:final_training_aia/session/session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class GenresPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GenresBloc()..add(LoadGenres()),
      child: GenresView(),
    );
  }
}

class GenresView extends StatefulWidget {
  @override
  _GenresViewState createState() => _GenresViewState();
}

class _GenresViewState extends State<GenresView> {
  List<Genres> list = [];
  bool isLoading = true;

  List<String> bg = [
    'assets/img_bg/bg1.png',
    'assets/img_bg/bg2.png',
    'assets/img_bg/bg1.png',
    'assets/img_bg/bg2.png',
    'assets/img_bg/bg1.png',
    'assets/img_bg/bg2.png',
    'assets/img_bg/bg1.png',
    'assets/img_bg/bg2.png',
  ];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GenresBloc, GenresState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state.status == GenresStatus.Processing) {
        } else if (state.status == GenresStatus.Success) {
          list = state.data!.list.take(5).toList();
          Future.delayed(const Duration(milliseconds: 1000), () {
            setState(() {
              isLoading = false;
            });
          });
        } else if (state.status == GenresStatus.Failed) {
          Helpers.shared.showDialogConfirm(context,message: (ApplicationSesson.shared.isOnline ? (state.error ?? 'An error occured' ) : 'Check wifi connection'));
          print(state.error);
        }
      },
      builder: (context, state) {
        return Scaffold(
            body: isLoading
                ? Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: 10,
                        itemBuilder: (ctx, index) {
                          return _buildShimmerGenresCard();
                        }),
                  )
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: list.length,
                    itemBuilder: (ctx, index) {
                      return _buildGenresCard(
                          bg[index], list[index].name, () {});
                    }));
      },
    );
  }

  Widget _buildGenresCard(String img, String title, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
        child: Stack(
          children: [
            Image.asset(
              img,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: AppColors.colorD8D8D8.withOpacity(0.65),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 25,
                    color: AppColors.color151C26,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerGenresCard() {
    return Container(
      height: 250,
       color: AppColors.colorFFFFFF,
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: AppColors.colorD8D8D8.withOpacity(0.65),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Text(
              '',
              style: TextStyle(
                fontSize: 25,
                color: AppColors.color151C26,
              ),
              softWrap: true,
              overflow: TextOverflow.fade,
            ),
          )
        ],
      ),
    );
  }
}
