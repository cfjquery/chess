<script type='text/javascript'>
  $(document).ready(function(){
      //GLOBAL VARS
      var posTop = <cfoutput>#posTop#</cfoutput>;
      var posLeft = <cfoutput>#posLeft#</cfoutput>;
      var posSq = <cfoutput>#posSq#</cfoutput>;
      var xPosFrom = 0;
      var yPosFrom = 0;
      var xPosTo = 0;
      var yPosTo = 0;
      var pieceMoved = '';         //i.e rk nk bk k q bq nq rq - RK NK BK K Q BQ NQ RQ
      var pMoved = '';             //i.e r n b k q p - R N B K Q P
      var pFrom = '';
      var aryValidMoves = new Array();
      var aryBoard = new Array(8);
      for(var i=0;i<=7;i++)
      {
        aryBoard[i]=new Array(8);
      }
      //DRAG HANDLER SETTINGS
      $('.d').draggable({
        grid:[posSq,posSq],
        containment:'#chessboard',
        cursor:'move',
        start:handleDragStart,
        stop:handleDragStop
      });
      //DRAG START HANDLER - RECORD POSITION OF PIECE THAT WAS MOVED
      function handleDragStart(event,ui){
        var oxPos = parseInt(ui.offset.left);
        var oyPos = parseInt(ui.offset.top);
        pieceMoved = getPieceMoved(this.id);          
        xPosFrom = parseInt(((oxPos - posLeft)/posSq));
        yPosFrom = parseInt(((oyPos -posTop)/posSq));
        computeTargetSquares();
      }
      //DRAG STOP HANDLER - RECORD THE NEW POSITION OF PIECE AND UPDATE THE BOARD POSITIONS
      function handleDragStop(event,ui){
        var oxPos = parseInt(ui.offset.left);
        var oyPos = parseInt(ui.offset.top);
        xPosTo = parseInt(((oxPos - posLeft)/posSq));
        yPosTo = parseInt(((oyPos - posTop)/posSq));
        updateBoardPositions();
      }
      //GET THE PIECE THAT WAS MOVED - COMPLETE AND SINGULAR
      function getPieceMoved(piece){
        console.log(piece);
        //CALCULATE WHETHER PIECE IS 1 OR 2 CHARS LONG
        var pLength = 1;
        if(piece.length == 6){
          pLength = 2;
        }
        pieceMoved = piece.substr(4,pLength);
        pMoved = piece.substr(4,1);
        pFrom = piece.substr(1,2);
        $('#pieceMoved').val(piece);
        $('#pMoved').val(pMoved);
        $('#pFrom').val(pFrom);
      }
      //SHOW VALID SQUARES
      function showVaildSquares(){
        //MAKE THE WHOLE BOARD UNMOVABLE BY REMOVING THE validMove CLASS AND BY DISABLING THE droppable CLASS
        $('.board').removeClass('validMove');
        $( ".board" ).droppable( "option", "disabled",true);
        //MAKE 
        for(var i=0;i<=aryValidMoves.length;i++){
          var squareToSetAsValid = 'ph' + aryValidMoves[i];
          $('.' + squareToSetAsValid).addClass('validMove');
          $('.' + squareToSetAsValid).droppable( "option","disabled",false);
        }
      }
      //PAWN - COMPUTE TARGET SQUARES
      function targetPawn(piece,x,y,who){
        console.log(piece + ' ' + x + ' ' + y + ' ' + who);  
        var noOfVaildMoves = 0;
        aryValidMoves.length = 0;
        //WHITE PAWN
         if(who == 'w'){
          //PAWN ON STARTING RANK
          if(y == 6){
            //GET THE PIECE 2 SQUARES ABOVE, IF IT'S A "1" THEN IT'S EMPTY AND THEREFORE A VALID MOVE
            if(aryBoard[y-2][x].substr(4,1) == 1){
              //aryValidMoves[noOfVaildMoves] = ((y - 2) * 10) + x;
              aryValidMoves.push(((y - 2) * 10) + x);
              noOfVaildMoves++;
            }
           }
          //GET THE PIECE 1 SQUARE ABOVE, IF IT'S A "1" THEN IT'S EMPTY AND THEREFORE A VALID MOVE
          if(aryBoard[y-1][x].substr(4,1) == 1){
            //aryValidMoves[noOfVaildMoves] = ((y - 1) * 10) + x;
            aryValidMoves.push(((y - 1) * 10) + x);
            noOfVaildMoves++;
          }
          console.log('v0 = ' + aryValidMoves[0]);  
          console.log('v1 = ' + aryValidMoves[1]);  
         }
        //BLACK PAWN
        if(who == 'b'){
          console.log('hello');
        }
        showVaildSquares();
      }
      //COMPUTE TARGET SQUARES
      function computeTargetSquares(){
        //WHAT TYPE OF PIECE IS BEING MOVED
        var piece = $('#pMoved').val();
        //SET THE FROM POSITION OF THE PIECE JUST MOVED
        var from = parseInt($('#pFrom').val());
        var y = parseInt(from/10);
        var x = from - (y*10);
        console.log('x = ' + x + ' y = ' + y);  
       //SET THE COLOR OF THE PIECE MOVED
        if(piece.charCodeAt(0) <= 90){
          var who = 'w';
        }
        else{
           var who = 'b';
        }
        //CALL CORRECT FUNCTION FOR THE CURRENT PIECE
        switch (piece.toUpperCase())
        {
          case 'P':
            targetPawn(piece,x,y,who);
            break;
          case 'R':
            targetRook(piece,x,y,who);
            break;
          case 'N':
            targetKnight(piece,x,y,who);
            break;
          case 'B':
            targetBishop(piece,x,y,who);
            break;
          case 'K':
             targetKing(piece,x,y,who);
           break;
          case 'Q':
            targetQueen(piece,x,y,who);
            break;
        }
      }
      //UPDATE BOARD POSITIONS
      function updateBoardPositions(){
        //SET THE FROM POSITION TO EMPTY (I.E. 1)
        aryBoard[yPosFrom][xPosFrom] ='x' + yPosFrom + xPosFrom + 'x' + '1';
        //SET THE TO POSITION TO THE PIECE JUST MOVED
        aryBoard[yPosTo][xPosTo] = $('#pieceMoved').val();
        //CREATE THE FEN FOR THE BOARD
        createFen();
        //PRINT THE ARRAY FOR DEBUGGING
        printBoardPositions();
      }
      //CREATE THE FORSYTH NOTATION STRING TO MAP THE BOARD LAYOUT AFTER LAST MOVE
      function createFen(){
        var strPiece = '';
        var piece = '';
        var oCount = 0;
        var fen = '';
        for(var i=0;i<=7;i++){
          for(var j=0;j<=7;j++){
            var strPiece = aryBoard[i][j];
            piece = strPiece.substr(4,1);
            fen = fen + piece;
          }
          if(i != 7){
              fen = fen + '/';
          }
        }
        //REPLACE STRINGS OF ONES WITH CORRECT NUMERAL
        for(var i=8;i>=2;i--){
          for(var j=0;j<=7;j++){
            var strOnes = '11111111'.substr(0,i);
            fen = fen.replace(strOnes,i);
          }
        }
        $('#fen').val(fen);
      }
      //ALTER BOARD TO REFLECT THE A PREVIOUS/NEXT MOVE
      function createBoardFromFen(){
        var fen = $('#fen').val();
        var piece = '';
        var oCount = 0;
        for(var i=0;i<=7;i++){
          for(var j=0;j<=7;j++){
            var strPiece = aryBoard[i][j];
            piece = strPiece.substr(4,1);
            fen = fen + piece;
          }
          if(i != 7){
              fen = fen + '/';
          }
        }
        //REPLACE STRINGS OF ONES WITH CORRECT NUMERAL
        for(var i=8;i>=2;i--){
          for(var j=0;j<=7;j++){
            var strOnes = '11111111'.substr(0,i);
            fen = fen.replace(strOnes,i);
          }
        }
        $('#fen').val(fen);
      }
      //DEBUG FUNCTION TO DISPLAY CURRENT BOARD ARRAY
      function printBoardPositions(){
        var jB = '<table>';
        for(var i=0;i<=7;i++){
          jB = jB + '<tr>';
          for(var j=0;j<=7;j++){
            jB = jB + '<td width="4">' + aryBoard[i][j] + '</td>';
          }
          jB = jB + '</tr>';
        }
        jB = jB + '</table>';
        $('#jBoard').html(jB);
      }
      //INITIALISE THE BOARD
      function initBoard(){
        aryBoard[0][0]='x00xrq';
        aryBoard[0][1]='x01xnq';
        aryBoard[0][2]='x02xbq';
        aryBoard[0][3]='x03xq';
        aryBoard[0][4]='x04xk';
        aryBoard[0][5]='x05xbk';
        aryBoard[0][6]='x06xnk';
        aryBoard[0][7]='x07xrk';
        for(var j=0;j<=7;j++)
        {
          aryBoard[1][j]='x1'+j+'xp';
        }
        for(var i=2;i<=5;i++)
        {
          for(var j=0;j<=7;j++)
          {
            aryBoard[i][j]='x'+i+j+'x1';
          }
        }
        for(var j=0;j<=7;j++)
        {
          aryBoard[6][j]='x6'+j+'xP';
        }
        aryBoard[7][0]='x70xRQ';
        aryBoard[7][1]='x71xNQ';
        aryBoard[7][2]='x72xBQ';
        aryBoard[7][3]='x73xQ';
        aryBoard[7][4]='x74xK';
        aryBoard[7][5]='x75xBK';
        aryBoard[7][6]='x76xNK';
        aryBoard[7][7]='x77xRK';
      }
      //INITIALISE TABS
      function initTabs(){
        //INITIALISE TABS  
        $(".tab_content").hide();                                                        //HIDE ALL CONTENT
        $("ul.tabs li:eq(<cfoutput>#activeTab#</cfoutput>)").addClass("active").show();  //ACTIVATE FIRST TAB
        $(".tab_content:eq(<cfoutput>#activeTab#</cfoutput>)").show();                   //SHOW FIRST TAB CONTENT
        //TABS - ON CLICK
        $("ul.tabs li").click(function(){
          $("ul.tabs li").removeClass("active");                                         //REMOVE ANY "ACTIVE" CLASS
          $(this).addClass("active");                                                    //ADD "ACTIVE" CLASS TO SELECTED TAB
          $('#activeTab').val(<cfoutput>#activeTab#</cfoutput>);
          $(".tab_content").hide();                                                      //HIDE ALL TAB CONTENT
          var activeTab = $(this).find("a").attr("href");                                //FIND THE HREF ATTRIBUTE VALUE TO IDENTIFY THE ACTIVE TAB + CONTENT
          $(activeTab).show();                                                           //FADE IN THE ACTIVE ID CONTENT
          return false;
        });
      }
      initTabs();
      initBoard();
      printBoardPositions();
  });  
</script>