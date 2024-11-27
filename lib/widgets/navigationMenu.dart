import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myapp/screens/create/addContentModal.dart';
import 'package:myapp/screens/explore/exploreScreen.dart';
import 'package:myapp/screens/favorites/favoritesScreen.dart';
import 'package:myapp/screens/main/homeScreen.dart';
import 'package:myapp/screens/profile/profileScreen.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return Scaffold(
        bottomNavigationBar: Obx(() => NavigationBar(
              backgroundColor: Colors.black,
              indicatorColor: Colors.grey,
              elevation: 0,
              height: 60,
              selectedIndex: controller.selectedIndex.value,
              onDestinationSelected: (index) => {
                if (index != 2)
                  {
                    controller.selectedIndex.value = index,
                  }
              },
              destinations: [
                NavigationDestination(
                    icon: Icon(Iconsax.home), label: 'Inicio'),
                NavigationDestination(
                    icon: Icon(Iconsax.category), label: 'Explorar'),
                NavigationDestination(
                    icon: GestureDetector(
                      onTap: () => AddContentModal.show(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.symmetric(
                              horizontal: BorderSide(
                                color: Colors.amber.withOpacity(0.8),
                                width: 4,
                              ),
                            )),
                        child: const Icon(
                          Iconsax.add,
                          color: Colors.black,
                          size: 25,
                        ),
                      ),
                    ),
                    label: ''),
                NavigationDestination(
                    icon: Icon(Iconsax.message), label: 'Mensajes'),
                NavigationDestination(
                    icon: Icon(Iconsax.user), label: 'Perfil'),
              ],
            )),
        body: Obx(() => controller.screens[controller.selectedIndex.value]));
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    HomeScreen(),
    ExploreScreen(),
    Container(),
    FavoritesScreen(),
    ProfileScreen(),
  ];
}
