// ignore_for_file: prefer_const_constructors
import 'package:final_training_aia/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class Reviewer extends StatelessWidget {
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
              'The Best of Me', 'assets/img_movie/movie.png', () {}, context);
        },
      ),
    );
  }

  Widget _buildCard(
      String name, String img, Function() onTap, BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.colorFFFFFF,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    img,
                    height: 45,
                    width: 45,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                      ),
                      SizedBox(
                        height: 10.0,
                        child: Center(
                          child: Container(
                            margin: EdgeInsetsDirectional.only(
                                start: 1.0, end: 1.0),
                            height: 1,
                            width: MediaQuery.of(context).size.width - 100,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            ReadMoreText(
              'Amanda and Dawson are soul mates who met as teens and were from different backgrounds. But circumstances would force them to part Amanda and Dawson are soul mates who met as teens and were from different backgrounds. But circumstances would force them to part But circumstances would force them to part Amanda and Dawson are soul mates who met as teens and were from different backgrounds. But circumstances would force them to part wa...But circumstances would force them to part Amanda and Dawson are soul mates who met as teens and were from different backgrounds. But circumstances would force them to part wa...But circumstances would force them to part Amanda and Dawson are soul mates who met as teens and were from different backgrounds. But circumstances would force them to part wa...',
              style: TextStyle(
                color: AppColors.color4A4A4A,
                fontSize: 15,
              ),
              trimLines: 2,
              trimMode: TrimMode.Line,
            ),
          ],
        ),
      ),
    );
  }
}
