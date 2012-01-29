<cfparam  name="errorMessage" default="">
<cfif IsDefined("buttonLogin")>
  <cfquery name="qryVerify" datasource="userLogin">
    SELECT userid, email, password
    FROM chess_users
    WHERE email = '#email#'
    AND password = '#password#'
  </cfquery>
  <cfif qryVerify.recordcount neq 0>
      <cfset session.allow = "True" />
      <cfset session.userid = qryVerify.userid />
      <cflocation template="chess.cfm";
  <cfelse>
    <cfset errorMessage = 'Your credentials could not be verified, please try again'>;
  </cfif>
</cfif>
<cfif errorMessage neq ''>
  <cfoutput>#errorMessage#</cfoutput><br>
</cfif>
<form action="login_process.cfm" method="post">
  Username: <input type="text" name="email" value=""><BR />
  Password: <input type="password" name="password" value=""><BR />
  <input type="submit" name="buttonLogin" value="Log In"><BR />
</form>