import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iot_app/model/dht.dart';

class DhtController extends ChangeNotifier {
  DhtController._privateConstructor();
  static final DhtController instance = DhtController._privateConstructor();
  DateTime now = DateTime.now();
  final dhtRef = FirebaseDatabase.instance
      .ref()
      .child('UNO_WiFi_REV2_Test')
      .child('Sensors')
      .child('Temp&Humid_Sensors');

  List<String> getPreviousWeekDays() {
    DateTime now = DateTime.now();
    DateTime lastDayOfWeek = now.add(Duration(days: now.weekday));
    List<String> weekDays = [];
    for (int i = 7; i > 0; i--) {
      DateTime day = lastDayOfWeek.subtract(Duration(days: i));
      String dayOfWeek = getDayOfWeek(day.weekday);
      print(dayOfWeek);
      weekDays.add(dayOfWeek);
    }
    print(weekDays);
    return weekDays;
  }

  String getDayOfWeek(int weekday) {
    switch (weekday) {
      case 1:
        return 'Th 2';
      case 2:
        return 'Th 3';
      case 3:
        return 'Th 4';
      case 4:
        return 'Th 5';
      case 5:
        return 'Th 6';
      case 6:
        return 'Th 7';
      case 7:
        return 'CN';
      default:
        return '';
    }
  }

  Stream<DHTModel?> getLastDHT() {
    final lastData = dhtRef.limitToLast(1);
    return lastData.onValue.map((event) {
      final data = event.snapshot.children.first.value;
      return DHTModel.fromJson(jsonDecode(jsonEncode(data)));
    });
  }

  Stream<List<DHTModel?>> getListDHTToday() {
    final allData = dhtRef;
    return allData.onValue.map((event) {
      final data = event.snapshot.children;
      final listData = data.map((e) {
        return DHTModel.fromJson(jsonDecode(jsonEncode(e.value)));
      }).toList();
      String formattedDate = DateFormat('d/M/yyyy').format(now);
      final listFilter = listData
          .where((element) => element.time!.contains(formattedDate))
          .toList();
      return listFilter;
    });
  }

  Stream<List<double>> getListTempDHTWeek() {
    final allData = dhtRef;
    return allData.onValue.map((event) {
      final data = event.snapshot.children;

      final listData = data.map((e) {
        return DHTModel.fromJson(jsonDecode(jsonEncode(e.value)));
      }).toList();

      List<double> weekDays = [];
      for (int i = 7; i > 0; i--) {
        DateTime day = now.subtract(Duration(days: i - 1));
        String formattedDate = DateFormat('d/M/yyyy').format(day);
        final listFilter = listData
            .where((element) => element.time!.contains(formattedDate))
            .toList();
        double sumTemperature = 0;
        if (listFilter.isNotEmpty) {
          List<double> listTemperature =
              listFilter.map((e) => double.parse(e.temperature!)).toList();
          for (var e in listTemperature) {
            sumTemperature += e;
          }
          weekDays.add(sumTemperature / listFilter.length);
        } else {
          weekDays.add(0);
        }
      }
      return weekDays;
    });
  }

  Stream<List<double>> getListHumidityDHTWeek() {
    final allData = dhtRef;
    return allData.onValue.map((event) {
      final data = event.snapshot.children;

      final listData = data.map((e) {
        return DHTModel.fromJson(jsonDecode(jsonEncode(e.value)));
      }).toList();

      List<double> weekDays = [];
      for (int i = 7; i > 0; i--) {
        DateTime day = now.subtract(Duration(days: i - 1));
        String formattedDate = DateFormat('d/M/yyyy').format(day);
        final listFilter = listData
            .where((element) => element.time!.contains(formattedDate))
            .toList();
        double sumHumidity = 0;
        if (listFilter.isNotEmpty) {
          List<double> listHumidity =
              listFilter.map((e) => double.parse(e.humidity!)).toList();
          for (var e in listHumidity) {
            sumHumidity += e;
          }
          weekDays.add(sumHumidity / listFilter.length);
        } else {
          weekDays.add(0);
        }
      }
      return weekDays;
    });
  }
}
