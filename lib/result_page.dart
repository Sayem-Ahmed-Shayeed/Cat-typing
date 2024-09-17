import 'dart:async';

import 'package:cat_typing/chart.dart';
import 'package:cat_typing/main.dart';
import 'package:flutter/material.dart';

class ResultsPage extends StatefulWidget {
  ResultsPage({
    super.key,
    required this.correctCount,
    required this.incorrectCount,
    required this.totalTypedCharacters,
    required this.selectedTime,
    required this.mistakeTimes,
    required this.wpmList,
    required this.timer,
    required this.wpmTimer,
  });

  final int correctCount;
  final int incorrectCount;
  final int totalTypedCharacters;
  final int selectedTime;
  List<double> wpmList;
  List<int> mistakeTimes;
  Timer timer;
  Timer wpmTimer;

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  @override
  Widget build(BuildContext context) {
    double wpm = (widget.correctCount / 5) / (widget.selectedTime / 60);
    double accuracy = (widget.correctCount / widget.totalTypedCharacters) * 100;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '${wpm.toInt()}',
                          softWrap: true ,
                          style: TextStyle(
                            color: kColorScheme.primaryContainer,
                            fontWeight:FontWeight.bold,
                          fontSize: 16
                          ),
                        ),
                        Text(
                          'wpm',
                          style: TextStyle(
                            color: kColorScheme.onPrimary,
                          fontSize: 12
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30,),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${accuracy.toInt()}%',
                          style: TextStyle(
                            color:kColorScheme.primaryContainer,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                       Text(
                          'Acc',
                          style: TextStyle(
                            color: kColorScheme.onPrimary,
                            fontSize:12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const  SizedBox(height: 30,),
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: Chart(
                    mistakeTimes: widget.mistakeTimes,
                    chosenTime: widget.selectedTime,
                    wpmList: widget.wpmList,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8,),
          Container(
            margin: const EdgeInsets.only(left: 80,right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                                '${widget.selectedTime}s',
                                style: TextStyle(
                    color: kColorScheme.primaryContainer,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                                ),
                              ),
                    Text(
                      'Time',
                      style: TextStyle(
                        color: kColorScheme.onPrimary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 90,),
                            Column(
                children: [
                  Text(
                  '${widget.correctCount}/${widget.mistakeTimes.length}/${widget.correctCount+widget.mistakeTimes.length}',
                  style: TextStyle(
                    color: kColorScheme.primaryContainer,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                                  ),
                    Text(
                      'correct,incorrect,total',
                      style: TextStyle(
                        color:kColorScheme.onPrimary,
                        fontSize: 12,
                      ),
                    ),
                ],
                            ),
              ],
            ),
          ),
          const SizedBox(height: 40,),
          TextButton(
            onPressed: () {
              widget.timer.cancel();
              widget.wpmTimer.cancel();
              Navigator.of(context).pop();
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
