import 'package:flutter/material.dart';
import 'package:iot_app/controller/dht_controller.dart';
import 'package:iot_app/model/dht.dart';
import 'package:collection/collection.dart';
import 'package:iot_app/view/chart/line_chart_week.dart';

class DetailScreen extends StatefulWidget {
  final DHTModel dhtModel;
  final bool isHumidity;
  const DetailScreen(
      {super.key, required this.dhtModel, this.isHumidity = false});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final controller = DhtController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isHumidity
            ? 'Thông tin chi tiết độ ẩm'
            : 'Thông tin chi tiết nhiệt độ'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16).copyWith(bottom: 0),
                  child: Text(
                    'Hôm nay',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                widget.isHumidity
                    ? StreamBuilder(
                        stream: controller.getListDHTToday(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final data = snapshot.data;
                            if (data!.isNotEmpty) {
                              List<double>? listHumidity = data
                                  .map((e) => double.parse(e!.humidity!))
                                  .toList();
                              double? sumHumidity = listHumidity.sum;
                              double? maxHumidity = listHumidity.max;
                              double? minHumidity = listHumidity.min;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 24),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    child: Row(
                                      children: [
                                        _buildItem(context,
                                            title: 'Độ ẩm hiện tại',
                                            value:
                                                '${widget.dhtModel.humidity}%'),
                                        _buildItem(context,
                                            title: 'Độ ẩm trung bình',
                                            value:
                                                '${(sumHumidity / data.length).toStringAsFixed(2)}%'),
                                        _buildItem(context,
                                            title: 'Độ ẩm cao nhất',
                                            value:
                                                '${maxHumidity.toStringAsFixed(2)}%C'),
                                        _buildItem(context,
                                            title: 'Độ ẩm thấp nhất',
                                            value:
                                                '${minHumidity.toStringAsFixed(2)}%'),
                                      ],
                                    ),
                                  )
                                ],
                              );
                            } else {
                              return const Center(
                                child: Text('Không có dữ liệu'),
                              );
                            }
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
                      )
                    : StreamBuilder(
                        stream: controller.getListDHTToday(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final data = snapshot.data;
                            if (data!.isNotEmpty) {
                              List<double>? listTemperature = data
                                  .map((e) => double.parse(e!.temperature!))
                                  .toList();
                              double? sumTemperature = listTemperature.sum;
                              double? maxTemperature = listTemperature.max;
                              double? minTemperature = listTemperature.min;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 24),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    child: Row(
                                      children: [
                                        _buildItem(context,
                                            title: 'Nhiệt độ hiện tại',
                                            value:
                                                '${widget.dhtModel.temperature}°C'),
                                        _buildItem(context,
                                            title: 'Nhiệt độ trung bình',
                                            value:
                                                '${(sumTemperature / data.length).toStringAsFixed(2)}°C'),
                                        _buildItem(context,
                                            title: 'Nhiệt độ cao nhất',
                                            value:
                                                '${maxTemperature.toStringAsFixed(2)}°C'),
                                        _buildItem(context,
                                            title: 'Nhiệt độ thấp nhất',
                                            value:
                                                '${minTemperature.toStringAsFixed(2)}°C'),
                                      ],
                                    ),
                                  )
                                ],
                              );
                            } else {
                              return const Center(
                                child: Text('Không có dữ liệu'),
                              );
                            }
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
                      ),
              ],
            ),
            const SizedBox(height: 48),
            StreamBuilder(
              stream: widget.isHumidity
                  ? controller.getListHumidityDHTWeek()
                  : controller.getListTempDHTWeek(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data;
                  return BuildLineChartWeek(
                    listData: data!,
                    isHumidity: widget.isHumidity,
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context,
      {required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).indicatorColor),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}
