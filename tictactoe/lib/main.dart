import 'package:flutter/material.dart';
import 'package:tictactoe/tile_state.dart';
import 'package:tictactoe/board_tile.dart';
void main() {
  runApp(const BackGround());
}

class BackGround extends StatefulWidget{
  const BackGround({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GameState();
}

class _GameState extends State<BackGround>{
  
  final navigatorKey = GlobalKey<NavigatorState>();
  var _boardState = List.filled(9,TileState.EMPTY);
  var _currentTurn = TileState.CROSS;
  @override
  Widget build(BuildContext contxt){
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: Scaffold(
        body:Center(
          child:
            Stack(children: [Image.asset('images/board.png'), _boardTiles()]),
        ),
      ),
      // body:_buildSuggestions(),
    );
  }

  Widget _boardTiles(){
    return Builder(
      builder:(context){
        final boardDimension = MediaQuery.of(context).size.width;
        final tileDimension = boardDimension/3;
        return SizedBox(
          width: boardDimension,
          height: boardDimension,
          child: Column(
            children: chunk(_boardState,3).asMap().entries.map((entry){
              final chunkIndex = entry.key;
              final tileStateChunk = entry.value;

             return Row(
              children: tileStateChunk.asMap().entries.map((innerEntry) {
                final innerIndex = innerEntry.key;
                final tileState = innerEntry.value;
                final tileIndex = (chunkIndex * 3) + innerIndex;

                return BoardTile(
                  tileState: tileState,
                  dimension: tileDimension,
                  onPressed: () => _updateTileStateForIndex(tileIndex),
                );
              }).toList(),
            );
          }).toList()));
    });
  }

  void _updateTileStateForIndex(int selectIndex){
    if (_boardState[selectIndex] == TileState.EMPTY){
      setState((){
        _boardState[selectIndex] = _currentTurn;
        _currentTurn = _currentTurn == TileState.CROSS
          ?TileState.CIRCLE
          :TileState.CROSS;
      });

      TileState winner = _findWinner();
      if (winner != TileState.EMPTY){
        _showWinnerDialog(winner);
      }

      if (!_boardState.contains(TileState.EMPTY)){
        winner = TileState.EMPTY;
        _showDrawDialog(winner);
      }
    } 
  }
  TileState winnerForMatch(int a,int b,int c){
    if (_boardState[a] != TileState.EMPTY){
      if((_boardState[a] == _boardState[b]) && 
        (_boardState[b] == _boardState[c])){
        return _boardState[a];
      }
    }
    return TileState.EMPTY;
  }

  TileState _findWinner(){
    final checks = [
      winnerForMatch(0,1,2),
      winnerForMatch(3,4,5),
      winnerForMatch(6,7,8),
      winnerForMatch(0,3,6),
      winnerForMatch(1,4,7),
      winnerForMatch(2,5,8),
      winnerForMatch(0,4,8),
      winnerForMatch(2,4,6),
    ];

    TileState winner = TileState.EMPTY;
    for (int i = 0; i < checks.length; i++) {
      if (checks[i] != TileState.EMPTY) {
        winner = checks[i];
        break;
      }
    }

    return winner;
  }

  void _showWinnerDialog(TileState tileState){
    final context = navigatorKey.currentState!.overlay!.context;
    showDialog(
      context:context,
      builder:(_){
        return AlertDialog(
          title:const Text('Winner'),
          content:Image.asset(
            tileState == TileState.CROSS ? 'images/x.png' : 'images/o.png'
          ),
          actions: [
              TextButton(
                  onPressed: () {
                    _resetGame();
                    Navigator.of(context).pop();
                  },
                  child: const Text('New Game')),
            ],
          );
        });
  }
   void _showDrawDialog(TileState tileState){
    final context = navigatorKey.currentState!.overlay!.context;
    showDialog(
      context:context,
      builder:(_){
        return AlertDialog(
          title:const Text('Tie'),
          actions: [
              TextButton(
                  onPressed: () {
                    _resetGame();
                    Navigator.of(context).pop();
                  },
                  child: const Text('New Game')),
            ],
          );
        });
  }

  void _resetGame(){
    setState((){
      _boardState = List.filled(9,TileState.EMPTY);
      _currentTurn = TileState.CROSS;
    });
  }
}

// Icons.close_outlined
// Icons.brightness_1_outlined


