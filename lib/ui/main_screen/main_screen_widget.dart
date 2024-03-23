import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/services/auth_services.dart';
import 'package:themoviedb/domain/screen_factory/screen_factory.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:themoviedb/ui/main_screen/main_screen_model.dart';
import 'package:themoviedb/resources/icons/app_bar_icons_svg.dart';

class MainScreenWidget extends StatelessWidget {
  const MainScreenWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final model = context.watch<MainScreenModel>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app),
          onPressed: () {
            AuthServices.resetSession(context);
          },
        ),
        title: SizedBox(
          child: SvgPicture.string(
            width: 50,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            AppBarIsonsSvg.themoviedbIcon,
          ),
        ),
      ),
      body: IndexedStack(index: model.selectedTab, children: [
        ScreenFactory().makeMovieList(),
        ScreenFactory.makeFavoriteScreen()
      ]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: model.selectedTab,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.movie_filter), label: "Фильмы"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: "Понравившиеся"),
        ],
        onTap: model.onselectedTab,
      ),
    );
  }
}
