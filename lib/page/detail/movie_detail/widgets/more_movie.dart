// ignore_for_file: prefer_const_constructors

import 'package:final_training_aia/constants/colors.dart';
import 'package:flutter/material.dart';

class MoreList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.colorEEEEEE,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 10),
        itemCount: 5,
        itemBuilder: (cxt, index) {
          return _buildCard(
              'The Best of Me', 'assets/img_movie/movie.png', () {});
        },
      ),
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
              child: Image.asset(
                img,
                // height: double.infinity,
                // width: double.infinity,
                fit: BoxFit.fitHeight,
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
                      Text('The Best of Me',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      Text('Action | Drama | Advanture',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                          )),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, color: Colors.green[500]),
                      Icon(Icons.star, color: Colors.green[500]),
                      Icon(Icons.star, color: Colors.green[500]),
                      Icon(Icons.star, color: Colors.black),
                      Icon(Icons.star, color: Colors.black),
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
