import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PuzzlePage extends StatefulWidget {
  const PuzzlePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PuzzlePageState();
}

class _PuzzlePageState extends State<PuzzlePage> {
  // 現在のタイルの状態
  var tileNumbers = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    0,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('スライドパズル'),
        actions: [
          IconButton(
            onPressed: () => loadTileNumbers(),
            icon: const Icon(
              Icons.play_arrow,
            ),
          ),
          IconButton(
            onPressed: () => saveTileNumbers(),
            icon: const Icon(
              Icons.save,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: TilesView(
                  numbers: tileNumbers,
                  correctMap: calcCorrectMap(tileNumbers),
                  onPressed: (number) => swapTitle(number),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => setState(() {
                  tileNumbers.shuffle();
                }),
                icon: const Icon(Icons.shuffle),
                label: const Text('シャッフル'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<int, bool> calcCorrectMap(List<int> numbers) {
    Map<int, bool> m = {};
    final correctNumbers = [
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      0,
    ];

    for (var i = 0; i < correctNumbers.length; i++) {
      if (numbers[i] != correctNumbers[i]) {
        m[correctNumbers[i]] = false;
      } else {
        m[correctNumbers[i]] = true;
      }
    }
    return m;
  }

  void swapTitle(int number) {
    if (canSwapTile(number)) {
      setState(() {
        final indexOfTile = tileNumbers.indexOf(number);
        final indexOfEmpty = tileNumbers.indexOf(0);
        tileNumbers[indexOfTile] = 0;
        tileNumbers[indexOfEmpty] = number;
      });
    }
  }

  bool canSwapTile(int number) {
    final indexOfTile = tileNumbers.indexOf(number);
    final indexOfEmpty = tileNumbers.indexOf(0);
    switch (indexOfEmpty) {
      case 0:
        return [1, 3].contains(indexOfTile);
      case 1:
        return [0, 2, 4].contains(indexOfTile);
      case 2:
        return [1, 5].contains(indexOfTile);
      case 3:
        return [0, 4, 6].contains(indexOfTile);
      case 4:
        return [1, 3, 5, 7].contains(indexOfTile);
      case 5:
        return [2, 4, 8].contains(indexOfTile);
      case 6:
        return [3, 7].contains(indexOfTile);
      case 7:
        return [4, 6, 8].contains(indexOfTile);
      case 8:
        return [5, 7].contains(indexOfTile);
      default:
        return false;
    }
  }

  void saveTileNumbers() async {
    final value = jsonEncode(tileNumbers);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("TILE_NUMBERS", value);
  }

  void loadTileNumbers() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString("TILE_NUMBERS");
    if (value != null) {
      final numbers =
          (jsonDecode(value) as List<dynamic>).map((v) => v as int).toList();
      setState(() {
        tileNumbers = numbers;
      });
    }
  }
}

class TilesView extends StatelessWidget {
  //const TilesView({Key? key}) : super(key: key);
  final List<int> numbers;
  final Map<int, bool> correctMap;
  final void Function(int number) onPressed;
  //var cnt;
  const TilesView({
    Key? key,
    required this.numbers,
    required this.correctMap,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      crossAxisSpacing: 24,
      mainAxisSpacing: 24,
      padding: const EdgeInsets.symmetric(vertical: 24),
      children: numbers.map((number) {
        if (number == 0) {
          return Container();
        }

        return TileView(
          number: number,
          color: correctMap[number]! ? Colors.green : Colors.blue,
          onPressed: () => onPressed(number),
        );
      }).toList(),
    );
  }
}

class TileView extends StatelessWidget {
  final int number;
  final Color color;
  final void Function() onPressed;

  const TileView({
    Key? key,
    required this.number,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: color,
        textStyle: const TextStyle(fontSize: 32),
      ),
      child: Center(
        child: Text(number.toString()),
      ),
    );
  }
}
