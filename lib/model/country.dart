class Country {
  String country;
  String continent;
  int population;
  String newcases;
  int activecases;
  int criticalcases;
  int recoveredcases;
  int totalcases;
  String newdeaths;
  int totaldeaths;
  String day;
  Country(
      {this.country,
      this.continent,
      this.population,
      this.newcases,
      this.activecases,
      this.criticalcases,
      this.recoveredcases,
      this.totalcases,
      this.newdeaths,
      this.totaldeaths,
      this.day});

  Map<String,dynamic> toJson()=>{
    'country':country ,
    'continent':continent ,
    'population':population,
    'newcases':newcases ?? '0',
    'activecases':activecases ?? '-',
    'criticalcases':criticalcases ?? '-',
    'recoveredcases':recoveredcases ?? '-',
    'totalcases':totalcases ?? '-',
    'newdeaths':newdeaths ?? '0',
    'totaldeaths':totaldeaths,
    'day':day
  };


}
