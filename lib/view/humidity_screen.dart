import 'package:flutter/material.dart';
import 'package:iot_app/model/dht.dart';
import 'package:iot_app/view/detail_screen.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HumidityScreen extends StatelessWidget {
  final DHTModel data;
  const HumidityScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Center(child: StreamBuilder(
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SfRadialGauge(
              animationDuration: 1500,
              enableLoadingAnimation: true,
              axes: [
                RadialAxis(
                  showLabels: false,
                  showTicks: false,
                  minimum: 0,
                  maximum: 100,
                  startAngle: 270,
                  endAngle: 270,
                  axisLineStyle: AxisLineStyle(
                    color: Theme.of(context).dividerColor,
                    thickness: 20,
                  ),
                  pointers: [
                    RangePointer(
                      value: double.parse(data.humidity ?? '0'),
                      width: 20,
                      color: Theme.of(context).indicatorColor,
                      cornerStyle: CornerStyle.bothCurve,
                      enableAnimation: true,
                      animationType: AnimationType.ease,
                      animationDuration: 400,
                    )
                  ],
                  annotations: [
                    GaugeAnnotation(
                      widget: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${data.humidity} %',
                              style: const TextStyle(
                                fontSize: 60,
                                height: 1,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Độ ẩm',
                              style: TextStyle(
                                fontSize: 30,
                                height: 1,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                const Text(
                  'Cập nhật lần cuối lúc: ',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                Text(
                  data.time ?? '',
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).indicatorColor,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(
                      dhtModel: data,
                      isHumidity: true,
                    ),
                  ),
                );
              },
              child: Text(
                'Thống kê chi tiết',
                style:
                    TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
              ),
            )
          ],
        );
      },
    ));
  }
}
