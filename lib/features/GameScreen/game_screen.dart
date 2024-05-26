import 'package:flutter/material.dart';

import '../../final_result.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    this.player1 = "Player 1",
    this.player2 = "Player 2",
  });
  final String player1;
  final String player2;
  @override
  State<GameScreen> createState() => _GameScreenState();
}

enum Player { X, O }

class _GameScreenState extends State<GameScreen> {
  Player current = Player.X;
  var items = <Player?>[
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
  ];
  Player? winner;
  int counter = 0;
  int scorePlayer1 = 0;
  int scorePlayer2 = 0;
  int round = 1;
  int maxRounds = 3;
  bool endRound = false;
  bool endGame = false;

  @override
  void initState() {
    super.initState();
    winner = null;

    endRound = false;
    endGame = false;
    scorePlayer1 = 0;
    scorePlayer2 = 0;
    round = 1;
    maxRounds = 3;
    counter = 0;
    current = Player.X;
  }

  String endGameResult() {
    if (scorePlayer1 > scorePlayer2) {
      return "${widget.player1} won";
    } else if (scorePlayer1 < scorePlayer2) {
      return "${widget.player2} won";
    } else {
      return "No winner";
    }
  }

  Future<void> showEndRoundDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: endGame
              ? const Text(
                  'Game Over',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : Text(
                  'End of Round $round',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          content: Text(
            round <= maxRounds
                ? winner != null
                    ? "  ${winner == Player.X ? widget.player1 : widget.player2} (${winner!.name}) won"
                    : ' it\'s a Draw'
                : endGameResult(),
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (endGame) {
                  round = 1;
                  scorePlayer1 = 0;
                  scorePlayer2 = 0;
                  current = Player.X;
                  endGame = false;
                  endRound = false;
                  setState(() {});
                }
                if (round == maxRounds) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultScreen(
                        player_1: widget.player1,
                        player_2: widget.player2,
                        score_1: scorePlayer1,
                        score_2: scorePlayer2,
                      ),
                    ),
                    (route) => false,
                  );
                } else {
                  Navigator.pop(context);
                }
              },
              child: Text(
                round < maxRounds ? 'Next Round' : 'End Game',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void handleWinner() async {
    const winnerCases = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (int r = round; r <= maxRounds; r++) {
      for (var element in winnerCases) {
        final fItem = items[element[0]];
        final sItem = items[element[1]];
        final thItem = items[element[2]];

        if (fItem == sItem && sItem == thItem && fItem != null) {
          winner = fItem;
          endRound = true;
          if (winner == Player.X) {
            setState(() {
              scorePlayer1 += 3;
            });
          } else if (winner == Player.O) {
            setState(() {
              scorePlayer2 += 3;
            });
          }

          await showEndRoundDialog();

          setState(() {
            if (round <= maxRounds) {
              items = [null, null, null, null, null, null, null, null, null];
              round++;
              counter = 0;
            }
          });

          break;
        }
        if (winner == null && counter == 9) {
          endRound = true;
          setState(() {
            scorePlayer1++;
            scorePlayer2++;
          });
          await showEndRoundDialog();

          setState(() {
            if (round <= maxRounds) {
              items = [null, null, null, null, null, null, null, null, null];
              round++;
              counter = 0;
            }
          });
        }

        endRound = false;
        winner = null;
      }
      if (round > maxRounds) {
        endGame = true;
        items = [null, null, null, null, null, null, null, null, null];
        await showEndRoundDialog();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Center(
          child: Text(
            'Game Panel',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '${widget.player1} : Score $scorePlayer1 ',
                  style: const TextStyle(
                    color: Colors.purple,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${widget.player2} : Score $scorePlayer2 ',
                  style: const TextStyle(
                    color: Colors.orange,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Divider(color: Colors.black),
            Text(
              'Round $round',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Row(
                children: [
                  const Text(
                    'Turn ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    current == Player.X
                        ? '${widget.player1} (${current.name})'
                        : '${widget.player2} (${current.name})',
                    style: TextStyle(
                      color:
                          current == Player.X ? Colors.purple : Colors.orange,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.black),
            Board(
              items: items,
              onClick: (int index) {
                if (endRound) return;
                if (items[index] != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Already filled')),
                  );
                  return;
                }
                setState(() {
                  counter++;
                  items[index] = current;
                  current = current == Player.X ? Player.O : Player.X;
                });
                handleWinner();
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          title: const Text(
                            'Are you sure to reset ?',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "No",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  items = [
                                    null,
                                    null,
                                    null,
                                    null,
                                    null,
                                    null,
                                    null,
                                    null,
                                    null,
                                  ];
                                  winner = null;
                                  endRound = false;
                                  endGame = false;
                                  scorePlayer1 = 0;
                                  scorePlayer2 = 0;
                                  round = 1;
                                  maxRounds = 3;
                                  counter = 0;
                                  current = Player.X;
                                });
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Yes",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Reset',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          title: const Text(
                            'Are you sure to exit ?',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: Colors.purple,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "No",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: Colors.purple,
                              ),
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ResultScreen(
                                      player_1: widget.player1,
                                      player_2: widget.player2,
                                      score_1: scorePlayer1,
                                      score_2: scorePlayer2,
                                    ),
                                  ),
                                  (route) => false,
                                );
                              },
                              child: const Text(
                                "Yes",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[500],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Exit',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Board extends StatelessWidget {
  Board({
    super.key,
    required this.items,
    required this.onClick,
  });
  final List<Player?> items;
  void Function(int)? onClick;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GridView(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        children: [
          for (int i = 0; i < items.length; i++)
            InkWell(
              onTap: () {
                onClick!(i);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: BoardItem(item: items[i]),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class BoardItem extends StatelessWidget {
  const BoardItem({
    super.key,
    required this.item,
  });
  final Player? item;
  @override
  Widget build(BuildContext context) {
    if (item == Player.X) {
      return Text(
        item!.name,
        style: const TextStyle(
          color: Colors.purple,
          fontSize: 50,
          fontWeight: FontWeight.bold,
        ),
      );
    } else if (item == Player.O) {
      return Text(
        item!.name,
        style: const TextStyle(
          color: Colors.orange,
          fontSize: 50,
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
