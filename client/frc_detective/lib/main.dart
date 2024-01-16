import 'package:flutter/material.dart';
import 'package:eventify/eventify.dart';

import 'appconfig.dart';

import 'widgets/summary/summary.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final EventEmitter emitter = EventEmitter();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FRCDetective',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor:mainColor),
        useMaterial3: true,
      ),
      home: MyHomePage(title: appTitle, emitter: emitter),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final EventEmitter emitter;

  const MyHomePage({super.key, required this.title, required this.emitter});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(tabs: const [
              Tab(icon: Icon(Icons.data_array), text: "Summary",),
              Tab(icon: Icon(Icons.leaderboard), text: "Ranking"),
              Tab(icon: Icon(Icons.calendar_month), text: "Schedule"),
            ], labelColor: barColor, unselectedLabelColor: barColor.withAlpha(100),),
            title: const Text(appTitle, style: appBarTitle,),
            backgroundColor: mainColor,
          ),
          body: TabBarView(children: [
            Summary(emitter: widget.emitter),
            const Icon(Icons.home),
            const Icon(Icons.home),
          ])
        )
      )
    );
  }
}
