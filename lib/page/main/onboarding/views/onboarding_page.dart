// ignore_for_file: prefer_const_constructors

import 'package:final_training_aia/config/routers.dart';
import 'package:final_training_aia/constants/colors.dart';
import 'package:final_training_aia/constants/constants.dart';
import 'package:final_training_aia/helpers/helper.dart';
import 'package:final_training_aia/page/main/onboarding/bloc/onboarding_bloc.dart';
import 'package:final_training_aia/page/main/onboarding/models/onboard_entity.dart';
import 'package:final_training_aia/session/session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    String email = ApplicationSesson.shared.credential?.email ?? '';
    return BlocProvider(
      create: (_) => OnboardingBloc()..add(GetOnboard()),
      child: OnboardingView(email),
    );
  }
}

class OnboardingView extends StatefulWidget {
  final String email;

  OnboardingView(this.email);
  @override
  _OnboardingViewState createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  late PageController _pageController;
  List<Onboard> listImage = [];
  List<Widget> list = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    list = buildPageIndicator(0);
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      list = buildPageIndicator(_pageController.page?.toInt() ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingBloc, OnboardState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state.status == OnboardStatus.Processing ||
            state.status == OnboardStatus.UpdateProcessing) {
          Helpers.shared.showDialogProgress(context);
        } else if (state.status == OnboardStatus.Failed) {
          Helpers.shared.hideDialogProgress(context);
          Helpers.shared.showDialogConfirm(context,message: (ApplicationSesson.shared.isOnline ? (state.error ?? 'An error occured' ) : 'Check wifi connection'));
        } else if (state.status == OnboardStatus.Success) {
          Helpers.shared.hideDialogProgress(context);
          listImage = state.data!.onboard.take(3).toList();
          list = buildPageIndicator(0);
        } else if (state.status == OnboardStatus.UpdateSuccess) {
          Helpers.shared.hideDialogProgress(context);
          Navigator.pushReplacementNamed(context, Routers.main);
        } else if (state.status == OnboardStatus.UpdateFailed) {
          Helpers.shared.hideDialogProgress(context);
          Helpers.shared.showDialogConfirm(context,message: (ApplicationSesson.shared.isOnline ? (state.error ?? 'An error occured' ) : 'Check wifi connection'));
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Container(
            height: double.infinity,
            child: Stack(
              children: [
                PageView.builder(
                  physics: ClampingScrollPhysics(),
                  controller: _pageController,
                  itemCount: listImage.length,
                  itemBuilder: (ctx, index) {
                    return Image.network(
                      Constants.prefixUrlImg + listImage[index].posterPath,
                      fit: BoxFit.cover,
                    );
                  },
                  onPageChanged: (indexPage) {
                    setState(() {
                      list = buildPageIndicator(indexPage);
                    });
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    height: 15,
                    color: Colors.transparent,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: list,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Movies & Series',
                          style: TextStyle(
                              fontSize: 35, color: AppColors.colorFFFFFF)),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'The world’s most popular and authoritative source for movies and series.',
                        style: TextStyle(
                            fontSize: 17, color: AppColors.colorFFFFFF),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 50),
                    child: Material(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.color0294A5.withOpacity(0.5),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () {
                          updateView();
                        },
                        child: Container(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(),
                              Text(
                                "Explore Collection",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: AppColors.colorFFFFFF,
                                    fontWeight: FontWeight.w400),
                              ),
                              Icon(
                                Icons.navigate_next,
                                color: AppColors.colorFFFFFF,
                                size: 35,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> buildPageIndicator(int index) {
    List<Widget> list = [];
    if (index >= listImage.length) {
      index = listImage.length - 1;
    }
    for (int i = 0; i < listImage.length; i++) {
      list.add(
          i == index ? buildItemIndicator(true) : buildItemIndicator(false));
    }
    return list;
  }

  Container buildItemIndicator(bool isActive) {
    return Container(
      height: 6,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        margin: EdgeInsets.symmetric(horizontal: 3.0),
        height: 6,
        width: 6,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? Colors.blue : Colors.white,
        ),
      ),
    );
  }

  void updateView() {
    // if (_nameKeyForm.currentState!.validate() &&
    //     _passwordKeyForm.currentState!.validate()) {
    //   _nameKeyForm.currentState!.save();
    //   _passwordKeyForm.currentState!.save();
    final bloc = context.read<OnboardingBloc>();
    bloc.add(UpdateView(
      widget.email,
    ));
    // }
  }
}
