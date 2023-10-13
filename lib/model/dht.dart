class DHTModel {
  String? time;
  String? temperature;
  String? humidity;

  DHTModel({this.time, this.temperature, this.humidity});

  DHTModel.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    temperature = json['temperature'];
    humidity = json['humidity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time ?? '';
    data['temperature'] = temperature ?? '';
    data['humidity'] = humidity ?? '';

    return data;
  }
}
