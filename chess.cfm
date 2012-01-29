<cfset objChess = CreateObject('component', 'chess')>
<cfparam name="fen" default="rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR">
<cfparam name="cFen" default="rnbqkbnr/pppppppp/11111111/11111111/11111111/11111111/PPPPPPPP/RNBQKBNR">
<!--- POSITION OF THE TOP OF BOARD px --->
<cfset posTop = 8>
<!--- POSITION OF THE LEFT OF BOARD px --->
<cfset posLeft = 8>
<!--- SIZE OF A BOARD SQUARE px --->
<cfset posSq = 80>
<!--- GET THE STARTING POSITIONS ( IT'S AN ARRAY OF STRINGS - THE STRINGS ARE THE CLASSES OF THE BOARD ELEMENTS --->
<cfset aryChessboard = objChess.getStartingPositons() />
<!DOCTYPE html>
<html xmlns='http://www.w3.org/1999/xhtml'>
<head>
  <meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
  <meta http-equiv='X-UA-Compatible' content='IE=8' />
  <link rel='stylesheet' type='text/css' href='css/default.css' media='screen'/>
  <script src='scripts/jquery-1.7.1.min.js'></script>
  <script src='scripts/jquery-ui-1.8.17.custom/js/jquery-ui-1.8.17.custom.min.js'></script>
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
        var pieceMoved = '';
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
          pieceMoved = this.id;          
          xPosFrom = parseInt(((oxPos - posLeft)/posSq));
          yPosFrom = parseInt(((oyPos -posTop)/posSq));
        }
        //DRAG STOP HANDLER - RECORD THE NEW POSITION OF PIECE AND UPDATE THE BOARD POSITIONS
        function handleDragStop(event,ui){
          var oxPos = parseInt(ui.offset.left);
          var oyPos = parseInt(ui.offset.top);
          xPosTo = parseInt(((oxPos - posLeft)/posSq));
          yPosTo = parseInt(((oyPos - posTop)/posSq));
          updateBoardPositions();
        }
        //UPDATE BOARD POSITIONS
        function updateBoardPositions(){
          //CALCULATE WHETHER PIECE IS 1 OR 2 CHARS LONG
          var pLength = 1;
          if(pieceMoved.length == 6){
            pLength = 2;
          }
          //SET THE FROM POSITION TO EMPTY (I.E. 1)
          aryBoard[yPosFrom][xPosFrom] ='x' + yPosFrom + xPosFrom + 'x' + '1';
          //SET THE TO POSITION TO THE PIECE JUST MOVED
          aryBoard[yPosTo][xPosTo] ='x' + yPosTo + xPosTo + 'x' + pieceMoved.substr(4,pLength);
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
        initBoard();
        printBoardPositions();
    });
  </script>
</head>
<body>
<cfoutput>
<div id='chessboard' class='chessboard'>
  <cfloop from='1' to='8' index='iRow'>
    <cfloop from='1' to='8' index='iCol'>
      <cfset  piece = aryChessboard[iRow][iCol]>
      <div id='#piece#' class='#piece#<cfif piece neq '1'> d</cfif>' style='top:#posTop + (posSq * (iRow - 1))#px;left:#posLeft + (posSq * (iCol - 1))#px;'></div>
    </cfloop>
  </cfloop>
</div>
<!--- 
<div id='controls' class='controls'>
  <form name="frmControls" action="chess.cfm" method="post" enctype="multipart/form-data">
    <input type="hidden" name="fen" id="fen" value="<cfoutput>#fen#</cfoutput>">
    <input type="hidden" name="cFen" id="cFen" value="<cfoutput>#cFen#</cfoutput>">
    <div id="jBoard" name="jBoard"></div>
  </form>
</div>
 --->
 </cfoutput>
</body>
</html>