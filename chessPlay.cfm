<cfoutput>
<div id='chessboard' class='chessboard'>
  <cfloop from='1' to='8' index='iRow'>
    <cfloop from='1' to='8' index='iCol'>
      <cfset  piece = aryChessboard[iRow][iCol]>
      <div id='#piece#' class='board ph#iRow - 1##iCol - 1# #piece#<cfif mid(piece,5,1) neq '1'> d</cfif>' style='top:#posTop + (posSq * (iRow - 1))#px;left:#posLeft + (posSq * (iCol - 1))#px;'></div>
    </cfloop>
  </cfloop>
</div>
</cfoutput>
