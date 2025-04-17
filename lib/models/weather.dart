class Weather {
  final String main;
  final String name;
  final String description;
  final String country;
  final double temp;
  final double feelsLike;
  final double minTemp;
  final double maxTemp;
  final double windSpeed;
  final int humidity;

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
