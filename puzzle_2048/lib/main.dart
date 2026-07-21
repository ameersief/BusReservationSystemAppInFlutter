import 'package:flutter/material.dart';
import 'board.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2048 Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late Board _board;

  @override
  void initState() {
    super.initState();
    _board = Board();
  }

  void _handleSwipe(Direction direction) {
    if (_board.move(direction)) {
      setState(() {});
    }
  }

  void _restartGame() {
    setState(() {
      _board.initBoard();
    });
  }

  Color _getTileColor(int value) {
    switch (value) {
      case 2:
        return Colors.orange[100]!;
      case 4:
        return Colors.orange[200]!;
      case 8:
        return Colors.orange[300]!;
      case 16:
        return Colors.orange[400]!;
      case 32:
        return Colors.orange[500]!;
      case 64:
        return Colors.orange[600]!;
      case 128:
        return Colors.orange[700]!;
      case 256:
        return Colors.orange[800]!;
      case 512:
        return Colors.orange[900]!;
      case 1024:
        return Colors.deepOrange[600]!;
      case 2048:
        return Colors.deepOrange[900]!;
      default:
        return Colors.grey[300]!;
    }
  }

  Color _getTextColor(int value) {
    return value <= 4 ? Colors.black87 : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: const Text('2048', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Score: ${_board.score}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: _restartGame,
                  child: const Text('Restart'),
                )
              ],
            ),
          ),
          Center(
            child: GestureDetector(
              onVerticalDragEnd: (details) {
                if (details.primaryVelocity! < 0) {
                  _handleSwipe(Direction.up);
                } else if (details.primaryVelocity! > 0) {
                  _handleSwipe(Direction.down);
                }
              },
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! < 0) {
                  _handleSwipe(Direction.left);
                } else if (details.primaryVelocity! > 0) {
                  _handleSwipe(Direction.right);
                }
              },
              child: Container(
                width: 350,
                height: 350,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.brown[300],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                  ),
                  itemCount: 16,
                  itemBuilder: (context, index) {
                    int r = index ~/ 4;
                    int c = index % 4;
                    int val = _board.grid[r][c];

                    return Container(
                      decoration: BoxDecoration(
                        color: _getTileColor(val),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Center(
                        child: Text(
                          val == 0 ? '' : '$val',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: _getTextColor(val),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (_board.isGameOver)
            const Text(
              'Game Over!',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          if (_board.isWon)
            const Text(
              'You Win!',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green),
            ),
        ],
      ),
    );
  }
}
