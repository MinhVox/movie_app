import 'package:final_training_aia/constants/colors.dart';
import 'package:final_training_aia/helpers/helper.dart';
import 'package:final_training_aia/page/main/artist/views/artist_page.dart';
import 'package:final_training_aia/page/main/discover/views/discover_page.dart';
import 'package:final_training_aia/page/main/favorite/views/favorite_page.dart';
import 'package:final_training_aia/page/main/genres/views/genres_page.dart';
import 'package:final_training_aia/page/main/tabbar/bloc/search_bloc.dart';
import 'package:final_training_aia/page/main/tabbar/widgets/artist_result.dart';
import 'package:final_training_aia/page/main/tabbar/widgets/movie_result.dart';
import 'package:final_training_aia/page/main/tabbar/widgets/tv_result.dart';
import 'package:final_training_aia/session/session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainTabBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(),
      child: MainTabBarView(),
    );
  }
}

class MainTabBarView extends StatefulWidget {
  @override
  _MainTabBarViewState createState() => _MainTabBarViewState();
}

class _MainTabBarViewState extends State<MainTabBarView>
    with SingleTickerProviderStateMixin {
  final List<Widget> _children = [
    DiscoverPage(),
    GenresPage(),
    ArtistPage(),
    FavoritePage(),
  ];

  final List<String> _childrenTitle = [
    'Discover',
    'Genres',
    'Artitst',
    'Favorite',
  ];

  bool _searchMode = false;
  late TabController _tabController;

  TextEditingController searchController = TextEditingController();

  int _currentIndex = 0;
  int _currentIndexSearch = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    searchController.addListener(() {
      if (searchController.text.length >= 2) {
        searching();
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
    return BlocConsumer<SearchBloc, SearchState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state.status == SearchStatus.Processing) {
        } else if (state.status == SearchStatus.Success) {
        } else if (state.status == SearchStatus.Failed) {
          print(state.error);
        }
      },
      builder: (context, state) {
        final List<Widget> _childrenSearch = [
          MovieResult(
              result: state.data?.list
                      .where((e) => e.mediaType == 'movie')
                      .toList() ??
                  []),
          TVResult(
              result:
                  state.data?.list.where((e) => e.mediaType == 'tv').toList() ??
                      []),
          MovieResult(
              result: state.data?.list
                      .where((e) => e.mediaType == 'genres')
                      .toList() ??
                  []),
          ArtistResult(
              result:
                  state.data?.list.where((e) => e.mediaType == 'person').toList() ??
                      [])
        ];
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.colorFFFFFF,
            centerTitle: true,
            elevation: 0,
            leading: _searchMode
                ? IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.color0294A5,
                    ),
                    onPressed: () {
                      // Do something.
                    })
                : null,
            title: _searchMode
                ? Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                        color: AppColors.color000000.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: TextFormField(
                        controller: searchController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.search,
                              color: AppColors.color8E8E93,
                            ),
                            hintText: 'Search...',
                            border: InputBorder.none),
                      ),
                    ),
                  )
                : Text(
                    _childrenTitle[_currentIndex],
                    style: TextStyle(
                        color: AppColors.color4A4A4A,
                        fontWeight: FontWeight.w300),
                  ),
            actions: [
              InkWell(
                onTap: () {
                  setState(() {
                    _searchMode = !_searchMode;
                    if(!_searchMode){
                      searchController.clear();
                    }
                  });
                },
                child: _searchMode
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: AppColors.color0294A5),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 11, 8),
                        child: SvgPicture.asset(
                            'assets/svg_icon/app_bar/search.svg')),
              ),
            ],
            bottom: _searchMode
                ? TabBar(
                    controller: _tabController,
                    labelColor: AppColors.color0294A5,
                    unselectedLabelColor: AppColors.color8899A6,
                    indicatorColor: AppColors.color0294A5,
                    onTap: onTapSearch,
                    tabs: [
                      Tab(
                        text: 'Movies',
                      ),
                      Tab(
                        text: 'Series',
                      ),
                      Tab(
                        text: 'Genres',
                      ),
                      Tab(
                        text: 'Artists',
                      ),
                    ],
                  )
                : null,
          ),
          body: _searchMode
              ? _childrenSearch[_currentIndexSearch]
              : Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: _children[_currentIndex],
                ),
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
                canvasColor: Colors.white,
                primaryColor: Colors.white,
                textTheme: Theme.of(context)
                    .textTheme
                    .copyWith(caption: TextStyle(color: Colors.white))),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex,
              backgroundColor: Colors.white,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              onTap: onTapInItems,
              items: [
                BottomNavigationBarItem(
                    label: "Discover",
                    icon: Column(
                      children: [
                        Container(
                          height: 20,
                          child: SvgPicture.asset(
                              'assets/svg_icon/main_tab_bar/discover.svg'),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Discover',
                          style: TextStyle(
                              fontSize: 15, color: AppColors.color9B9B9B),
                        )
                      ],
                    ),
                    activeIcon: Column(
                      children: [
                        Container(
                          height: 20,
                          child: SvgPicture.asset(
                            'assets/svg_icon/main_tab_bar/discover.svg',
                            color: AppColors.color0294A5,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Discover',
                          style: TextStyle(
                              fontSize: 15, color: AppColors.color0294A5),
                        )
                      ],
                    )),
                BottomNavigationBarItem(
                    label: "Genres",
                    icon: Column(
                      children: [
                        Container(
                          height: 20,
                          child: SvgPicture.asset(
                              'assets/svg_icon/main_tab_bar/genres.svg'),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Genres',
                          style: TextStyle(
                              fontSize: 15, color: AppColors.color9B9B9B),
                        )
                      ],
                    ),
                    activeIcon: Column(
                      children: [
                        Container(
                          height: 20,
                          child: SvgPicture.asset(
                            'assets/svg_icon/main_tab_bar/genres.svg',
                            color: AppColors.color0294A5,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Genres',
                          style: TextStyle(
                              fontSize: 15, color: AppColors.color0294A5),
                        )
                      ],
                    )),
                BottomNavigationBarItem(
                    label: "Artists",
                    icon: Column(
                      children: [
                        Container(
                          height: 20,
                          child: SvgPicture.asset(
                            'assets/svg_icon/main_tab_bar/artist.svg',
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Artists',
                          style: TextStyle(
                              fontSize: 15, color: AppColors.color9B9B9B),
                        )
                      ],
                    ),
                    activeIcon: Column(
                      children: [
                        Container(
                          height: 20,
                          child: SvgPicture.asset(
                            'assets/svg_icon/main_tab_bar/artist.svg',
                            color: AppColors.color0294A5,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Artists',
                          style: TextStyle(
                              fontSize: 15, color: AppColors.color0294A5),
                        )
                      ],
                    )),
                BottomNavigationBarItem(
                    label: "Favorite",
                    icon: Column(
                      children: [
                        Container(
                          height: 20,
                          child: SvgPicture.asset(
                              'assets/svg_icon/main_tab_bar/discover.svg'),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Favorite',
                          style: TextStyle(
                              fontSize: 15, color: AppColors.color9B9B9B),
                        )
                      ],
                    ),
                    activeIcon: Column(
                      children: [
                        Container(
                          height: 20,
                          child: SvgPicture.asset(
                            'assets/svg_icon/main_tab_bar/discover.svg',
                            color: AppColors.color0294A5,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Favorite',
                          style: TextStyle(
                              fontSize: 15, color: AppColors.color0294A5),
                        )
                      ],
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  void onTapInItems(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void onTapSearch(int index) {
    setState(() {
      _currentIndexSearch = index;
    });
  }

  void searching() {
    final bloc = context.read<SearchBloc>();
    bloc.add(Searching(searchController.text));
  }
}
