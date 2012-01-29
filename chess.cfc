<cfcomponent>
  <cffunction name='getStartingPositons' access='remote' returntype='array' output='true'>
    <cfset strPiece = 'rq,nq,bq,q,k,bk,nk,rk'>
    <cfset aryBoard = ArrayNew(2)>
    <cfloop from='1' to='8' index='iCol'>
      <cfset aryBoard[1][iCol] = 'x0' & (iCol - 1) & 'x' & ListGetAt(strPiece,iCol)> 
    </cfloop>
    <cfloop from='1' to='8' index='iCol'>
      <cfset aryBoard[2][iCol] = 'x1' & (iCol - 1) & 'xp'> 
    </cfloop>
    <cfloop from='3' to='6' index='iRow'>
      <cfloop from='1' to='8' index='iCol'>
        <cfset aryBoard[iRow][iCol] = 'x' & (iRow - 1) & (iCol - 1) & 'x1'> 
      </cfloop>
    </cfloop>
    <cfloop from='1' to='8' index='iCol'>
      <cfset aryBoard[7][iCol] = 'x6' & (iCol - 1) & 'xP'> 
    </cfloop>
    <cfloop from='1' to='8' index='iCol'>
      <cfset aryBoard[8][iCol] = 'x7' & (iCol - 1) & 'x' & Ucase(ListGetAt(strPiece,iCol))> 
    </cfloop>
    <cfreturn aryBoard />
  </cffunction>
</cfcomponent>
