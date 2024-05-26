import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../GameScreen/game_screen.dart';

// ignore: must_be_immutable
class PlayersScreen extends StatefulWidget {
  const PlayersScreen({
    super.key,
  });

  @override
  State<PlayersScreen> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  @override
  void dispose() {
    super.dispose();
    player1.dispose();
    player2.dispose();
  }

  TextEditingController player1 = TextEditingController();
  TextEditingController player2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.purple,
        leading: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        title: const Center(
          child: Text(
            'Players Panel',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            height: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.65),
                    spreadRadius: 5,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // changes position of shadow
                  )
                ]),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: player1,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person, size: 20),
                      labelText: 'Player 1',
                      labelStyle: TextStyle(
                        fontSize: 13,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.purple,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            height: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.65),
                    spreadRadius: 5,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // changes position of shadow
                  )
                ]),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: player2,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person, size: 20),
                      labelText: 'Player 2',
                      labelStyle: TextStyle(
                        fontSize: 13,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.orange,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 50.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GameScreen(
                          player1: player1.text.isNotEmpty
                              ? player1.text.trim()
                              : "Player 1",
                          player2: player2.text.isNotEmpty
                              ? player2.text.trim()
                              : "Player 2",
                        )),
              );
            },
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'Start Game',
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
