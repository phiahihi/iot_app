import 'package:flutter/material.dart';
import 'package:iot_app/model/dht.dart';
import 'package:iot_app/view/detail_screen.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class TemperatureScreen extends StatelessWidget {
  final DHTModel data;
  const TemperatureScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Center(child: StreamBuilder(
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SfRadialGauge(
              enableLoadingAnimation: true,
              axes: <RadialAxis>[
                RadialAxis(
                    minorTickStyle:
                        MinorTickStyle(color: Theme.of(context).indicatorColor),
                    majorTickStyle:
                        MajorTickStyle(color: Theme.of(context).indicatorColor),
                    axisLabelStyle: GaugeTextStyle(
                        fontSize: 15, color: Theme.of(context).indicatorColor),
                    // useRangeColorForAxis: true,
                    minimum: 0.0,
                    maximum: 50.0,
                    ranges: <GaugeRange>[
                      GaugeRange(
                          startValue: 0.0, endValue: 20.0, color: Colors.blue),
                      GaugeRange(
                          startValue: 20.0,
                          endValue: 35.0,
                          color: Colors.orange),
                      GaugeRange(
                          startValue: 35.0, endValue: 50.0, color: Colors.red)
                    ],
                    pointers: <GaugePointer>[
                      NeedlePointer(
                        knobStyle: KnobStyle(
                            knobRadius: 0.08,
                            sizeUnit: GaugeSizeUnit.factor,
                            color: Theme.of(context).indicatorColor),
                        value: double.parse(data.temperature ?? ''),
                        needleColor: Theme.of(context).indicatorColor,
                        enableAnimation: true,
                        animationType: AnimationType.ease,
                        animationDuration: 400,
                      ),
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                          widget: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("Nhiệt độ",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
                              Text('${data.temperature} °C',
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          angle: 90,
                          positionFactor: 0.5)
                    ])
              ],
            ),
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
