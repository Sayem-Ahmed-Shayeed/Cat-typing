import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cat_typing/main.dart';
import 'package:cat_typing/result_page.dart';
import 'dummy data.dart';

class TypingTest extends StatefulWidget {
  const TypingTest({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TypingTestState();
  }
}

class _TypingTestState extends State<TypingTest> {
  late String targetText;
  final TextEditingController _controller = TextEditingController();
  Timer? _timer;
  Timer? _wpmTimer;
  int _selectedTime = 0;
  bool _timerStarted = false;
  int correctCount = 0;
  int incorrectCount = 0;
  int totalTypedCharacters = 0;
  List<double> wpmList = [];
  Set<int> mistakeTimes = {};
  int _secondsElapsed = 0;
  int _lastMistakeLoggedAtSecond = -1;

  // Manage the visible text lines
  final int _linesVisible = 3;
  List<String> _lines = [];
  int _currentLineIndex = 0;

  @override
  void initState() {
    super.initState();
    targetText = TypingTestHelper.getRandomTargetText();
    _controller.addListener(_checkInput);
    _initializeLines();
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    _wpmTimer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_timerStarted) return; // Prevent starting the timer multiple times

    _timerStarted = true;
    _timer?.cancel();
    _wpmTimer?.cancel();

    _timer = Timer(Duration(seconds: _selectedTime), () {
      _navigateToResults(); // Navigate to results after time is up
    });

    _wpmTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateWPM();
    });
  }

  bool _isDialogVisible = false;

  void _checkInput() {
    // Ensure the timer has started and user has typed something
    if (_controller.text.isNotEmpty) {
      if (_selectedTime == 0) {
        _showSelectTimerDialog(); // Show dialog if no timer is selected
      } else if (!_timerStarted) {
        _startTimer(); // Start the timer if it's not running
      }

      // Evaluate typing and update visible lines if timer is running
      if (_timerStarted) {
        setState(() {
          _evaluateTyping(); // Check and color typed text
          _updateVisibleLines(); // Update visible text lines for scrolling effect
        });
      }
    }
  }

  void _showSelectTimerDialog() {
    if (_isDialogVisible) return; // Prevent multiple dialog instances

    setState(() {
      _isDialogVisible = true; // Mark that the dialog is open
    });

    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent dismissing the dialog by tapping outside
      builder: (BuildContext ctx) {
        return AlertDialog(
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            "No Timer Selected",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          content: const Text(
            "Please select a timer before starting the typing test.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _controller.clear(); // Clear the input field
                  _isDialogVisible =
                      false; // Reset the flag when the dialog is closed
                  Navigator.of(ctx).pop(); // Close the dialog
                });
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.blueAccent.withOpacity(0.1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    ).then((_) {
      setState(() {
        _isDialogVisible =
            false; // Ensure the dialog flag is reset after closing
      });
    });
  }

  void _updateWPM() {
    setState(() {
      _secondsElapsed++;
      int totalCharactersTyped = _controller.text.length;

      if (_secondsElapsed > 0) {
        double wpm = (totalCharactersTyped * 60) / (5 * _secondsElapsed);
        wpmList.add(wpm);
      }
    });
  }

  void _evaluateTyping() {
    String userInput = _controller.text;

    for (int i = 0; i < targetText.length; i++) {
      if (i < userInput.length) {
        if (userInput[i] != targetText[i] &&
            _secondsElapsed != _lastMistakeLoggedAtSecond) {
          _recordMistake();
          _lastMistakeLoggedAtSecond = _secondsElapsed;
        }
      }
    }
  }

  void _recordMistake() {
    mistakeTimes.add(_secondsElapsed);
  }

  void _navigateToResults() {
    correctCount = 0;
    incorrectCount = 0;
    totalTypedCharacters = _controller.text.length;
    _timer!.cancel();
    _wpmTimer!.cancel();

    String userInput = _controller.text;
    for (int i = 0; i < targetText.length; i++) {
      if (i < userInput.length) {
        if (targetText[i] == ' ' && userInput[i] == targetText[i]) {
          continue;
        } else if (userInput[i] == targetText[i] && targetText[i] != ' ') {
          correctCount++;
        } else {
          incorrectCount++;
        }
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsPage(
          timer: _timer!,
          wpmTimer: _wpmTimer!,
          correctCount: correctCount,
          incorrectCount: incorrectCount,
          totalTypedCharacters: totalTypedCharacters,
          selectedTime: _selectedTime,
          wpmList: wpmList,
          mistakeTimes: mistakeTimes.toList(),
        ),
      ),
    );
  }

  void _initializeLines() {
    List<String> lines = targetText.split('\n');
    while (lines.length < _linesVisible) {
      lines.add('');
    }
    setState(() {
      _lines = lines.take(_linesVisible).toList();
    });
  }

  void _updateVisibleLines() {
    int typedLength = _controller.text.length;
    String fullText = _lines.join(' ');

    // Determine if we need to replace the first line
    if (typedLength > _getEndOfLineIndex(1)) {
      setState(() {
        _currentLineIndex++;
        if (_currentLineIndex + _linesVisible - 1 <
            fullText.split('\n').length) {
          _lines = _lines.sublist(1) + [TypingTestHelper.getRandomTargetText()];
        }
      });
    }
  }

  int _getEndOfLineIndex(int lineIndex) {
    String text = _lines.take(lineIndex + 1).join(' ');
    return text.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(
              height: 30,
              child: Image.asset(
                'assets/cat.png',
                width: 30,
                height: 30,
                color: kColorScheme.primaryContainer
              ),
            ),
            const SizedBox(width: 5),
            const Text(
              "Cat Typing",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Elapsed time : ${_secondsElapsed}s',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  children: _buildTextSpans(),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Start typing...',
                ),
                style: const TextStyle(fontSize: 12, color: Colors.black),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTimeButton(7),
                  _buildTimeButton(15),
                  _buildTimeButton(30),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton.icon(
                    icon: Icon(Icons.restart_alt,color: kColorScheme.primaryContainer,),
                    onPressed: () {
                      setState(() {
                        targetText = TypingTestHelper.getRandomTargetText();
                        _initializeLines();
                        _controller.clear();
                        _timer?.cancel();
                        _wpmTimer?.cancel();
                        _selectedTime = 0;
                        wpmList = [];
                        _timerStarted = false;
                        mistakeTimes = <int>{};
                        _secondsElapsed = 0;
                        _lastMistakeLoggedAtSecond = -1;
                      });
                    },
                    label: const Text('Restart'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<TextSpan> _buildTextSpans() {
    String userInput = _controller.text;
    String visibleText = _lines.join(' ');

    List<TextSpan> spans = [];

    for (int i = 0; i < min(visibleText.length, userInput.length); i++) {
      Color color;
      if (userInput[i] == visibleText[i]) {
        color = Colors.green;
      } else {
        color = Colors.red;
      }

      spans.add(
        TextSpan(
          text: visibleText[i],
          style: TextStyle(color: color, fontSize: 18),
        ),
      );
    }

    // Add remaining text if the user input is shorter than visible text
    if (userInput.length < visibleText.length) {
      for (int i = userInput.length; i < visibleText.length; i++) {
        spans.add(
          TextSpan(
            text: visibleText[i],
            style: const TextStyle(color: Colors.grey, fontSize: 18),
          ),
        );
      }
    }

    return spans;
  }

  Widget _buildTimeButton(int seconds) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: kColorScheme.primaryContainer,
      ),
      onPressed: () {
        setState(() {
          _selectedTime = seconds;
          _timerStarted = false;
          _timer?.cancel();
          _wpmTimer?.cancel();
          _controller.clear();
          wpmList = [];
          mistakeTimes = <int>{};
          _secondsElapsed = 0;
          _lastMistakeLoggedAtSecond = -1;
          _initializeLines();
        });
      },
      child: Text(
        '$seconds seconds',
        style: TextStyle(
          color: _selectedTime == seconds ?kColorScheme.primaryContainer : Colors.grey,
        ),
      ),
    );
  }
}
