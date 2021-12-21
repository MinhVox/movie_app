// ignore_for_file: prefer_const_constructors

import 'package:final_training_aia/config/routers.dart';
import 'package:final_training_aia/constants/colors.dart';
import 'package:final_training_aia/constants/constants.dart';
import 'package:final_training_aia/page/main/tabbar/models/search_result_entity.dart';
import 'package:flutter/material.dart';

class ArtistResult extends StatelessWidget {
  final List<SearchResult> result;

  ArtistResult({required this.result});

  @override
  Widget build(BuildContext context) {
    return result.length != 0
        ? Container(
            color: AppColors.colorEEEEEE,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemCount: result.length,
              itemBuilder: (cxt, index) {
                return _buildCard(
                    result[index].name ?? '',
                    result[index].profilePath ??
                        'wwemzKWzjKYJFfCeiB57q3r4Bcm.svg', () {
                  Navigator.pushNamed(context, Routers.artistDetail,
                      arguments: {
                        'id': result[index].id,
                      });
                });
              },
            ),
          )
        : Center(
            child: Text('No data found'),
          );
  }

  Widget _buildCard(String name, String img, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.colorFFFFFF,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5), topRight: Radius.circular(5)),
              child: Image.network(
                Constants.prefixUrlImg + img,
                height: 250,
                // width: double.infinity,
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
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          )),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
