import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iot_app/controller/dht_controller.dart';
import 'package:iot_app/icons/icons.dart';
import 'package:iot_app/view/humidity_screen.dart';
import 'package:iot_app/view/temperature_screen.dart';

class TabsScreen extends StatefulWidget {
  final void Function()? onPressed;
  final ThemeMode themeMode;

  const TabsScreen({Key? key, this.onPressed, required this.themeMode})
      : super(key: key);

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final controller = DhtController.instance;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ứng dụng đo nhiệt độ và độ ẩm'),
          actions: [
            IconButton(
                icon: Icon(widget.themeMode == ThemeMode.light
                    ? Icons.dark_mode
                    : Icons.light_mode),
                onPressed: () {
                  setState(() {
                    widget.onPressed!();
                  });
                })
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                  icon: SvgPicture.asset(
                    AppIcons.temperature,
                    width: 24,
                    height: 24,
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                  text: 'Nhiệt độ'),
              Tab(
                  icon: SvgPicture.asset(AppIcons.humidity,
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                          Colors.white, BlendMode.srcIn)),
                  text: 'Độ ẩm')
            ],
          ),
        ),
        body: StreamBuilder(
            stream: controller.getLastDHT(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data;
                return TabBarView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    TemperatureScreen(
                      data: data!,
                    ),
                    HumidityScreen(
                      data: data,
                    )
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}
