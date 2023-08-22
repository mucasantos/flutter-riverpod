// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

enum City {
  stockholm,
  paris,
  tokyo,
  barueri,
}

typedef WeatherEmoji = String;

Future<WeatherEmoji> getWeather(City city) {
  return Future.delayed(
      const Duration(seconds: 1),
      () => {
            City.barueri: 'hot',
            City.paris: 'rainy',
            City.tokyo: 'snow',
            City.stockholm: 'windy',
          }[city]!);
}

const unknownEmoji = 'not..';
//UI write and reads from this
final currentCityProvider = StateProvider<City?>((ref) => null);

//UI reads this
final weatherProvider = FutureProvider<WeatherEmoji>((ref) {
  final city = ref.watch(currentCityProvider);

  if (city != null) {
    return getWeather(city);
  } else {
    return unknownEmoji;
  }
});

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(weatherProvider);

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Weather"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            currentWeather.when(
                data: (data) => Text(data),
                error: (_, __) => const Text("error..."),
                loading: () => const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    )),
            Expanded(
                child: ListView.builder(
                    itemCount: City.values.length,
                    itemBuilder: (context, index) {
                      final city = City.values[index];
                      final isSelected = city == ref.watch(currentCityProvider);
                      return ListTile(
                        title: Text(
                          city.toString(),
                        ),
                        trailing: isSelected ? const Icon(Icons.check) : null,
                        onTap: () {
                          ref.read(currentCityProvider.notifier).state = city;
                        },
                      );
                    }))
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
