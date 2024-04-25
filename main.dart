import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2048 Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('2048 Game'),
        ),
        body: Game2048(),
      ),
    );
  }
}

class Game2048 extends StatefulWidget {
  @override
  _Game2048State createState() => _Game2048State();
}

class _Game2048State extends State<Game2048> {
  late List<List<int>> grid;
  late Random random;
  int score = 0;
  bool isGameWon = false;
  bool isGameOver = false;
  int gridSize = 4; // Default grid size

  @override
  void initState() {
    super.initState();
    random = Random();
    initGame();
  }

  void initGame() {
    grid =
        List.generate(gridSize, (i) => List<int>.generate(gridSize, (j) => 0));
    score = 0;
    isGameWon = false;
    isGameOver = false;
    addNumber();
    addNumber();
  }

  void addNumber() {
    List<int> emptyCells = [];
    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[i].length; j++) {
        if (grid[i][j] == 0) {
          emptyCells.add(i * grid.length + j);
        }
      }
    }
    if (emptyCells.isNotEmpty) {
      int index = emptyCells[random.nextInt(emptyCells.length)];
      int value = random.nextInt(10) < 9 ? 2 : 4;
      int i = index ~/ grid.length;
      int j = index % grid.length;
      grid[i][j] = value;
    }
  }

  void swipeLeft() {
    setState(() {
      if (!isGameWon && !isGameOver) {
        for (int i = 0; i < grid.length; i++) {
          for (int j = 0; j < grid[i].length - 1; j++) {
            if (grid[i][j] == 0) continue;
            for (int k = j + 1; k < grid[i].length; k++) {
              if (grid[i][k] == 0) continue;
              if (grid[i][j] == grid[i][k]) {
                grid[i][j] *= 2;
                score += grid[i][j];
                grid[i][k] = 0;
                break;
              } else if (grid[i][k] != grid[i][j]) {
                break;
              }
            }
          }
          shiftLeft(i);
        }
        addNumber();
        checkGameWon();
        checkGameOver();
      }
    });
  }

  void swipeRight() {
    setState(() {
      if (!isGameWon && !isGameOver) {
        for (int i = 0; i < grid.length; i++) {
          for (int j = grid[i].length - 1; j > 0; j--) {
            if (grid[i][j] == 0) continue;
            for (int k = j - 1; k >= 0; k--) {
              if (grid[i][k] == 0) continue;
              if (grid[i][j] == grid[i][k]) {
                grid[i][j] *= 2;
                score += grid[i][j];
                grid[i][k] = 0;
                break;
              } else if (grid[i][k] != grid[i][j]) {
                break;
              }
            }
          }
          shiftRight(i);
        }
        addNumber();
        checkGameWon();
        checkGameOver();
      }
    });
  }

  void swipeUp() {
    setState(() {
      if (!isGameWon && !isGameOver) {
        for (int j = 0; j < grid[0].length; j++) {
          for (int i = 0; i < grid.length - 1; i++) {
            if (grid[i][j] == 0) continue;
            for (int k = i + 1; k < grid.length; k++) {
              if (grid[k][j] == 0) continue;
              if (grid[i][j] == grid[k][j]) {
                grid[i][j] *= 2;
                score += grid[i][j];
                grid[k][j] = 0;
                break;
              } else if (grid[k][j] != grid[i][j]) {
                break;
              }
            }
          }
          shiftUp(j);
        }
        addNumber();
        checkGameWon();
        checkGameOver();
      }
    });
  }

  void swipeDown() {
    setState(() {
      if (!isGameWon && !isGameOver) {
        for (int j = 0; j < grid[0].length; j++) {
          for (int i = grid.length - 1; i > 0; i--) {
            if (grid[i][j] == 0) continue;
            for (int k = i - 1; k >= 0; k--) {
              if (grid[k][j] == 0) continue;
              if (grid[i][j] == grid[k][j]) {
                grid[i][j] *= 2;
                score += grid[i][j];
                grid[k][j] = 0;
                break;
              } else if (grid[k][j] != grid[i][j]) {
                break;
              }
            }
          }
          shiftDown(j);
        }
        addNumber();
        checkGameWon();
        checkGameOver();
      }
    });
  }

  void shiftLeft(int row) {
    List<int> newRow = [];
    for (int i = 0; i < grid[row].length; i++) {
      if (grid[row][i] != 0) {
        newRow.add(grid[row][i]);
      }
    }
    while (newRow.length < grid[row].length) {
      newRow.add(0);
    }
    for (int i = 0; i < grid[row].length; i++) {
      grid[row][i] = newRow[i];
    }
  }

  void shiftRight(int row) {
    List<int> newRow = [];
    for (int i = grid[row].length - 1; i >= 0; i--) {
      if (grid[row][i] != 0) {
        newRow.add(grid[row][i]);
      }
    }
    while (newRow.length < grid[row].length) {
      newRow.add(0);
    }
    newRow = newRow.reversed.toList();
    for (int i = 0; i < grid[row].length; i++) {
      grid[row][i] = newRow[i];
    }
  }

  void shiftUp(int col) {
    List<int> newCol = [];
    for (int i = 0; i < grid.length; i++) {
      if (grid[i][col] != 0) {
        newCol.add(grid[i][col]);
      }
    }
    while (newCol.length < grid.length) {
      newCol.add(0);
    }
    for (int i = 0; i < grid.length; i++) {
      grid[i][col] = newCol[i];
    }
  }

  void shiftDown(int col) {
    List<int> newCol = [];
    for (int i = grid.length - 1; i >= 0; i--) {
      if (grid[i][col] != 0) {
        newCol.add(grid[i][col]);
      }
    }
    while (newCol.length < grid.length) {
      newCol.add(0);
    }
    newCol = newCol.reversed.toList();
    for (int i = 0; i < grid.length; i++) {
      grid[i][col] = newCol[i];
    }
  }

  void checkGameWon() {
    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[i].length; j++) {
        if (grid[i][j] == 2048) {
          setState(() {
            isGameWon = true;
          });
          break;
        }
      }
    }
  }

  void checkGameOver() {
    bool hasEmptyCell = false;
    bool canMove = false;
    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[i].length; j++) {
        if (grid[i][j] == 0) {
          hasEmptyCell = true;
          break;
        }
      }
    }
    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[i].length - 1; j++) {
        if (grid[i][j] == grid[i][j + 1]) {
          canMove = true;
          break;
        }
      }
    }
    for (int j = 0; j < grid.length; j++) {
      for (int i = 0; i < grid.length - 1; i++) {
        if (grid[i][j] == grid[i + 1][j]) {
          canMove = true;
          break;
        }
      }
    }
    if (!hasEmptyCell && !canMove) {
      setState(() {
        isGameOver = true;
      });
    }
  }

  void resetGame() {
    setState(() {
      initGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            DropdownButton<int>(
              value: gridSize,
              onChanged: (value) {
                setState(() {
                  gridSize = value!;
                  initGame();
                });
              },
              items: <int>[4, 5].map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('Grid Size: $value x $value'),
                );
              }).toList(),
            ),
            Text(
              'Score: $score',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey[300],
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridSize,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: grid.length * grid.length,
                itemBuilder: (context, index) {
                  int i = index ~/ grid.length;
                  int j = index % grid.length;
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: getTileColor(grid[i][j]),
                    ),
                    child: Center(
                      child: Text(
                        grid[i][j] == 0 ? '' : grid[i][j].toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Transform.rotate(
                  angle: pi / 2,
                  child: ElevatedButton(
                    onPressed: swipeUp,
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    ),
                    child: Icon(Icons.arrow_back_ios),
                  ),
                ),
                ElevatedButton(
                  onPressed: swipeLeft,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  ),
                  child: Icon(Icons.arrow_back_ios),
                ),
                ElevatedButton(
                  onPressed: swipeRight,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  ),
                  child: Icon(Icons.arrow_forward_ios),
                ),
                Transform.rotate(
                  angle: -pi / 2,
                  child: ElevatedButton(
                    onPressed: swipeDown,
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    ),
                    child: Icon(Icons.arrow_back_ios),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: resetGame,
              child: Text('New Game'),
            ),
            Visibility(
              visible: isGameWon,
              child: Text(
                'You Win!',
                style: TextStyle(fontSize: 24, color: Colors.green),
              ),
            ),
            Visibility(
              visible: isGameOver,
              child: Text(
                'Game Over!',
                style: TextStyle(fontSize: 24, color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color getTileColor(int value) {
    switch (value) {
      case 2:
        return Colors.orange;
      case 4:
        return Colors.deepOrange;
      case 8:
        return Colors.red;
      case 16:
        return Colors.purple;
      case 32:
        return Colors.deepPurple;
      case 64:
        return Colors.indigo;
      case 128:
        return Colors.blue;
      case 256:
        return Colors.lightBlue;
      case 512:
        return Colors.green;
      case 1024:
        return Colors.lightGreen;
      case 2048:
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }
}
