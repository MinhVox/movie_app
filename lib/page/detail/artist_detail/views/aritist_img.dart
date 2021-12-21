import 'package:final_training_aia/constants/colors.dart';
import 'package:final_training_aia/constants/constants.dart';
import 'package:final_training_aia/page/detail/artist_detail/models/artist_detail_entity.dart';
import 'package:flutter/material.dart';

class ArtistImg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final argument = ModalRoute.of(context)!.settings.arguments as Map;
    List<ArtistImage> list = argument['img'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.colorFFFFFF,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColors.color0294A5,
            ),
            onPressed: () {
              // Do something.
              Navigator.of(context).pop();
            }),
        title: Text(
          'Images',
          style: TextStyle(
              color: AppColors.color4A4A4A, fontWeight: FontWeight.w300),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            Expanded(
                child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1 / 1,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5),
                  itemCount: list.length,
                  itemBuilder: (_, index) {
                    return Image.network(
                      Constants.prefixUrlImg + list[index].imagePath,
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                      errorBuilder: (context, object, stackTrace) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
                  }),
            ))
          ],
        ),
      ),
    );
  }
}
