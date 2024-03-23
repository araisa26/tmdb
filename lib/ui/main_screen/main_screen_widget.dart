import 'package:flutter/material.dart';
import 'package:themoviedb/domain/api_client.dart';
import 'package:themoviedb/library/provider.dart';
import 'package:themoviedb/ui/movie_list/movie_list.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:themoviedb/ui/movie_list/movie_list_model.dart';
import 'package:themoviedb/ui/theme/app_bar_icons_svg.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({super.key});

  @override
  State<MainScreenWidget> createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  int _selectedTab = 0;
  final movieListModel = MovieListModel();
  void onselectedTab(index) {
    if (_selectedTab == index) return;
    _selectedTab = index;
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    movieListModel.setupLocal(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () {
            resetSession(context);
          },
        ),
        title: Container(
          child: SvgPicture.string(
            width: 50,
            colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
            AppBarIsonsSvg.themoviedbIcon,
          ),
        ),
      ),
      body: IndexedStack(index: _selectedTab, children: [
        NotifierProvider(
            create: () => movieListModel,
            isManagingModel: false,
            child: const MovieListWidget()),
        Center(
          child: Text(
            'Понравившиеся',
          ),
        ),
      ]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.movie_filter), label: "Фильмы"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: "Понравившиеся"),
        ],
        onTap: onselectedTab,
      ),
    );
  }
}
