import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Aboba',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent)
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toogleFavorites() {
    favorites.add(current);
    print(favorites);
  
  notifyListeners();
  }

  void clearFavorites() {
    favorites.clear();
  } 
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
    case 0:
      page = GeneratorPage();
      break;
    case 1:
      page = FavoritePage();
      break;
    default:
      throw UnimplementedError('no widget for $selectedIndex');
  }
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home), 
                    label: Text("Home"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite), 
                      label: Text("favorites")
                    ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
           );
      }
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toogleFavorites();
                }, 
                icon: Icon(icon), 
                label: Text("Like"),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                }, 
                child: Text("Next"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FavoritePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Favorite words:"),
          for (var pair in appState.favorites)
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text(pair.asLowerCase),
            ),
            ElevatedButton(
              onPressed: () {
                appState.clearFavorites();
              }, 
              child: Text("Clear")
          )
       ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: theme.colorScheme.onPrimary
    );
    return Card(
      color: theme.colorScheme.primary,
      elevation: 20,
      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}

