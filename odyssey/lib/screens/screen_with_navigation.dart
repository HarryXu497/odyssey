import 'package:flutter/material.dart';
import 'package:odyssey/routes/route_names.dart';
import 'package:odyssey/widgets/app_bottom_navigation_bar.dart';

class ScreenWithNavigation extends StatelessWidget {
  final PreferredSizeWidget appBar;
  final Widget body;

  const ScreenWithNavigation({
    super.key,
    required this.appBar,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () async {
          await Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(
            RouteNames.newTripScreen,
            (route) {
              return (ModalRoute.withName(
                    RouteNames.homeScreen,
                  )(route) ||
                  ModalRoute.withName(
                    RouteNames.profileScreen,
                  )(route) ||
                  ModalRoute.withName(
                    RouteNames.tripsScreen,
                  )(route));
            },
          );
        },
        backgroundColor:
            Theme.of(context).colorScheme.secondary,
        child: Icon(
          Icons.add,
          size: 32.0,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: AppBottomNavigationBar(),
    );
  }
}
