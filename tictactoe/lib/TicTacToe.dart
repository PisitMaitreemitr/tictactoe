enum TileState {EMPTY,CROSS,CIRLE}
class _TicTacToeGame{

  
  _TicTacToeGame(){
    var table = createTable();
    
  }

  List<int> createTable(){
    var ticTable = <int>[];
    for(int i=0;i<9;i++){
      ticTable.add(0);
    }
    return ticTable;
  }



}

