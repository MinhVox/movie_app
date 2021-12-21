import 'package:final_training_aia/constants/colors.dart';
import 'package:final_training_aia/constants/constants.dart';
import 'package:final_training_aia/page/main/artist/models/artist_entity.dart';
import 'package:flutter/material.dart';

class ArtistList extends StatelessWidget {
  final List<Artist> list;

  ArtistList({required this.list});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.colorEEEEEE,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      margin: EdgeInsets.only(bottom: 15),
      child: list.isNotEmpty
          ? GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 8 / 10,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                // mainAxisExtent: 10,
              ),
              itemCount: list.length,
              itemBuilder: (cxt, index) {
                return _buildArtistCard(list[index].name,
                    Constants.prefixUrlImg + list[index].img, () {});
              },
            )
          : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Text("No cast found"),
              ),
          ),
    );
  }

  Widget _buildArtistCard(String name, String img, Function() onTap) {
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
              aspectRatio: 20.0 / 17.0,
              child: Image.network(
                img,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Image.asset(
                    'assets/img_bg/artist.png',
                    fit: BoxFit.cover,
                  );
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
}
