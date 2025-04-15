class Weather {
  late String main;
  late String name;
  late String description;
  late String country;
  late double temp;
  late double feelsLike;
  late double minTemp;
  late double maxTemp;
  late double windSpeed;
  late int humidity;

  Weather({
    required this.feelsLike,
    required this.windSpeed,
    required this.humidity,
    required this.main,
    required this.country,
    required this.description,
    required this.maxTemp,
    required this.minTemp,
    required this.name,
    required this.temp,
  });
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      feelsLike: json['main']['feels_like'],
      windSpeed: json['wind']['speed'],
      humidity: json['main']['humidity'],
      main: json['weather'][0]['main'],
      country: json['sys']['country'],
      description: json['weather'][0]['description'],
      maxTemp: json['main']['temp_max'],
      minTemp: json['main']['temp_min'],
      name: json['name'],
      temp: json['main']['temp'],
    );
  }
}
