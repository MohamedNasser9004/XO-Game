import 'package:flutter/material.dart';

import 'package:tic_tac_toe3/features/HomeScreen/home_screen.dart';
import 'package:tic_tac_toe3/features/PlayersScreen/players_screen.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({
    super.key,
    required this.player_1,
    required this.player_2,
    required this.score_1,
    required this.score_2,
  });
  final String player_1;
  final String player_2;
  final int score_1;
  final int score_2;
  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String showWinner() {
    if (widget.score_1 > widget.score_2) {
      return "${widget.player_1} won";
    } else if (widget.score_1 < widget.score_2) {
      return "${widget.player_2} won";
    } else {
      return "No winner";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text(
          'Result Panel',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/tic_tac_toe.png",
            height: 120,
            width: 120,
          ),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'Hero\'s list ',
              style: TextStyle(
                color: Colors.purple,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          //! >>>>>>>>>>>>>> list of herors here <<<<<<<<<<<<<<<<<
          SizedBox(
            height: 150,
            child: DismissibleItems(
              player_1_: widget.player_1,
              player_2_: widget.player_2,
              score_1_: widget.score_1,
              score_2_: widget.score_2,
            ),
          ),

          const SizedBox(
            height: 20,
          ),
          Text(
            showWinner(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const PlayersScreen(),
                ),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
            child: const Text(
              'Restart game ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DismissibleItems extends StatefulWidget {
  const DismissibleItems({
    super.key,
    required this.player_1_,
    required this.player_2_,
    required this.score_1_,
    required this.score_2_,
  });
  final String player_1_;
  final String player_2_;
  final int score_1_;
  final int score_2_;
  @override
  State<DismissibleItems> createState() => _DismissibleItemsState();
}

class _DismissibleItemsState extends State<DismissibleItems> {
  //var details = {'Player 1':'X','Player 2 ':'O'};
  late List<String> items;
  @override
  void initState() {
    super.initState();
    items = [
      widget.player_1_,
      widget.player_2_,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          background: Container(
            color: Colors.red,
            child: const Icon(
              Icons.delete_forever_outlined,
              color: Colors.white,
            ),
          ),
          key: ValueKey<String>(items[index]),
          onDismissed: (DismissDirection direction) {
            setState(() {
              items.removeAt(index);
            });
          },
          child: ListTile(
            title: Row(
              children: [
                Icon(
                  Icons.star,
                  color: Colors.yellow[500],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          items[index],
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        Text(
                          index == 0 ? "X" : "O",
                          style: TextStyle(
                              color: index == 0 ? Colors.purple : Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  index == 0
                      ? "${widget.score_1_} points"
                      : "${widget.score_2_} points",
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
