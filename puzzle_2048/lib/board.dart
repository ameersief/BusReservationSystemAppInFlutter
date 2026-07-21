import 'dart:math';

enum Direction { up, down, left, right }

class Board {
  late List<List<int>> grid;
  int score = 0;
  bool isGameOver = false;
  bool isWon = false;
  final int size = 4;
  final Random _random = Random();

  Board() {
    initBoard();
  }

  void initBoard() {
    grid = List.generate(size, (_) => List.generate(size, (_) => 0));
    score = 0;
    isGameOver = false;
    isWon = false;
    _addRandomTile();
    _addRandomTile();
  }

  void _addRandomTile() {
    List<Point<int>> emptyCells = [];
    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        if (grid[r][c] == 0) {
          emptyCells.add(Point(r, c));
        }
      }
    }

    if (emptyCells.isEmpty) return;

    Point<int> randomCell = emptyCells[_random.nextInt(emptyCells.length)];
    // 90% chance of 2, 10% chance of 4
    grid[randomCell.x][randomCell.y] = _random.nextInt(10) < 9 ? 2 : 4;
  }

  bool move(Direction direction) {
    if (isGameOver || isWon) return false;

    bool moved = false;

    List<List<int>> newGrid = List.generate(size, (r) => List.from(grid[r]));
    int pointsEarned = 0;

    List<int> slideAndMerge(List<int> line) {
      List<int> nonZero = line.where((val) => val != 0).toList();

      for (int i = 0; i < nonZero.length - 1; i++) {
        if (nonZero[i] == nonZero[i + 1]) {
          nonZero[i] *= 2;
          pointsEarned += nonZero[i];
          if (nonZero[i] == 2048) {
            isWon = true;
          }
          nonZero.removeAt(i + 1);
        }
      }

      while (nonZero.length < size) {
        nonZero.add(0);
      }
      return nonZero;
    }

    if (direction == Direction.left || direction == Direction.right) {
      for (int r = 0; r < size; r++) {
        List<int> row = newGrid[r];
        if (direction == Direction.right) {
          row = row.reversed.toList();
        }

        List<int> newRow = slideAndMerge(row);

        if (direction == Direction.right) {
          newRow = newRow.reversed.toList();
        }

        for (int c = 0; c < size; c++) {
          if (newGrid[r][c] != newRow[c]) {
            moved = true;
            newGrid[r][c] = newRow[c];
          }
        }
      }
    } else if (direction == Direction.up || direction == Direction.down) {
      for (int c = 0; c < size; c++) {
        List<int> col = [];
        for (int r = 0; r < size; r++) {
          col.add(newGrid[r][c]);
        }

        if (direction == Direction.down) {
          col = col.reversed.toList();
        }

        List<int> newCol = slideAndMerge(col);

        if (direction == Direction.down) {
          newCol = newCol.reversed.toList();
        }

        for (int r = 0; r < size; r++) {
          if (newGrid[r][c] != newCol[r]) {
            moved = true;
            newGrid[r][c] = newCol[r];
          }
        }
      }
    }

    if (moved) {
      grid = newGrid;
      score += pointsEarned;
      _addRandomTile();
      _checkGameOver();
    }

    return moved;
  }

  void _checkGameOver() {
    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        if (grid[r][c] == 0) return;
      }
    }

    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        if (r < size - 1 && grid[r][c] == grid[r + 1][c]) return;
        if (c < size - 1 && grid[r][c] == grid[r][c + 1]) return;
      }
    }

    isGameOver = true;
  }
}
