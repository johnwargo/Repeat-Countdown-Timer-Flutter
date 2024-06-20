import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const appName = 'Repeat Countdown';
const eventName = 'Christmas';
const int targetMonth = 12;
const int targetDay = 25;

// controls app styling
const double theFontSize = 18;
const double boxHeight = 5;
const TextStyle itemStyle = TextStyle(fontSize: theFontSize);
const TextStyle headerStyle =
    TextStyle(fontSize: theFontSize, fontWeight: FontWeight.bold);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CountdownApp(
          title: appName,
          eventName: eventName,
          targetMonth: targetMonth,
          targetDay: targetMonth),
    );
  }
}

class CountdownApp extends StatefulWidget {
  final String title;
  final String eventName;
  final int targetMonth;
  final int targetDay;

  const CountdownApp(
      {super.key,
      required this.title,
      required this.eventName,
      required this.targetMonth,
      required this.targetDay});

  @override
  State<CountdownApp> createState() => _CountdownAppState();
}

class _CountdownAppState extends State<CountdownApp> {
  late Duration timeDiff;
  late DateTime eventDate;

  Duration getEventDiff() {
    return eventDate.difference(DateTime.now());
  }

  void calcTimeDiff() {
    // Calculate the time between the current time and the retirement date
    Duration theDiff;

    theDiff = getEventDiff();
    if (theDiff.inSeconds < 0) {
      setState(() {
        // increment the year
        eventDate =
            DateTime(eventDate.year + 1, eventDate.month, eventDate.day);
        timeDiff = theDiff;
      });
    } else {
      setState(() {
        timeDiff = theDiff;
      });
    }
  }

  @override
  void initState() {
    eventDate = DateTime(DateTime.now().year, targetMonth, targetDay);
    timeDiff = getEventDiff();
    Timer periodicTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        calcTimeDiff();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Time to $eventName ${eventDate.year}:', style: headerStyle),
              const SizedBox(height: 10),
              _countdownItem(
                  unit: timeDiff.inDays, label: 'Day', spacing: boxHeight),
              _countdownItem(
                  unit: timeDiff.inHours, label: 'Hour', spacing: boxHeight),
              _countdownItem(
                  unit: timeDiff.inMinutes,
                  label: 'Minute',
                  spacing: boxHeight),
              _countdownItem(
                  unit: timeDiff.inSeconds,
                  label: 'Second',
                  spacing: boxHeight),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _countdownItem(
    {required int unit, required String label, required double spacing}) {
  var testSuffix = unit == 1 ? '' : 's';
  var formatter = NumberFormat('###,###,###,000');
  var numberStr = formatter.format(unit);
  return Column(children: [
    Text('$numberStr $label$testSuffix', style: itemStyle),
    SizedBox(height: spacing),
  ]);
}
