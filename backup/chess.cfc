<cfcomponent>
  <cffunction name="getStartingPositons" access="remote" returntype="array" output="true">
    <!--- BOARD ARRAY --->
    <cfset aryBoard = ArrayNew(2)>
    <cfset aryBoard[1][1] = "rq">
    <cfset aryBoard[1][2] = "nq">
    <cfset aryBoard[1][3] = "bq">
    <cfset aryBoard[1][4] = "q">
    <cfset aryBoard[1][5] = "k">
    <cfset aryBoard[1][6] = "bk">
    <cfset aryBoard[1][7] = "nk">
    <cfset aryBoard[1][8] = "rk">

    <cfset aryBoard[2][1] = "p">
    <cfset aryBoard[2][2] = "p">
    <cfset aryBoard[2][3] = "p">
    <cfset aryBoard[2][4] = "p">
    <cfset aryBoard[2][5] = "p">
    <cfset aryBoard[2][6] = "p">
    <cfset aryBoard[2][7] = "p">
    <cfset aryBoard[2][8] = "p">
    
    <cfloop from="3" to="6" index="iRow">
      <cfloop from="1" to="8" index="iCol">
        <cfset aryBoard[iRow][iCol] = "e"> 
      </cfloop>
    </cfloop>

    <cfset aryBoard[7][1] = "P">
    <cfset aryBoard[7][2] = "P">
    <cfset aryBoard[7][3] = "P">
    <cfset aryBoard[7][4] = "P">
    <cfset aryBoard[7][5] = "P">
    <cfset aryBoard[7][6] = "P">
    <cfset aryBoard[7][7] = "P">
    <cfset aryBoard[7][8] = "P">

    <cfset aryBoard[8][1] = "RQ">
    <cfset aryBoard[8][2] = "NQ">
    <cfset aryBoard[8][3] = "BQ">
    <cfset aryBoard[8][4] = "Q">
    <cfset aryBoard[8][5] = "K">
    <cfset aryBoard[8][6] = "BK">
    <cfset aryBoard[8][7] = "NK">
    <cfset aryBoard[8][8] = "RK">
    <cfreturn aryBoard />
  </cffunction>
</cfcomponent>
