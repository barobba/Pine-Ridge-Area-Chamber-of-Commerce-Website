<%
'************************************************************************
'   File:           aaglobs.asp
'
'   Description:    Include file for all public pages on action alert site
'
'   Author:         Mark A. Paquette
'
'   Copyright:      (c) 2001 thedatabank, inc.
'************************************************************************

Dim conn
Dim rs

' DOMAIN CHECK - WHICH SITE ARE WE ON.  GET DB CONNECTION INFO.
Dim LOCAL_ADDR
Dim HTTP_HOST
Dim HTTP_USER_AGENT

LOCAL_ADDR = request.servervariables("LOCAL_ADDR")
HTTP_HOST = request.servervariables("HTTP_HOST")
HTTP_USER_AGENT = request.servervariables("HTTP_USER_AGENT")

	'response.write LOCAL_ADDR & "<br>" & HTTP_HOST & "<br>"
if (LOCAL_ADDR = "209.46.123.177") then 'we're on the production box
	if instr(HTTP_HOST, "sierraclubaction") > 0 then
		DB_ConnectionString = "Provider=SQLOLEDB.1;Persist Security Info=False;Initial Catalog=dbank02;Data Source=AHCNTAPP005"
	else
		DB_ConnectionString = "Provider=SQLOLEDB.1;Persist Security Info=False;Initial Catalog=databank;Data Source=AHCNTAPP005"
	end if
	DB_ConnectionStringDataBank = "Provider=SQLOLEDB.1;Persist Security Info=False;Initial Catalog=databank;Data Source=AHCNTAPP005"
	DB_RuntimeUserName = "databank"
	DB_RuntimePassword = "bango"
else	'assume we're on the development server
	DB_ConnectionString = "Provider=SQLOLEDB.1;Persist Security Info=False;Initial Catalog=dbankdemo;Data Source=protector"
	DB_ConnectionStringDataBank = "Provider=SQLOLEDB.1;Persist Security Info=False;Initial Catalog=databank;Data Source=protector"
	DB_RuntimeUserName = "dbankdemo"
	DB_RuntimePassword = "bamoo"
end if
DB_ConnectionTimeout = 15
DB_CommandTimeout = 30



' SET UP GENERAL PURPOSE DB CONNECTION & RECORDSET
Set conn = Server.CreateObject("ADODB.Connection")
conn.ConnectionTimeout = DB_ConnectionTimeout
conn.CommandTimeout = DB_CommandTimeout
conn.Open DB_ConnectionString, DB_RuntimeUserName, DB_RuntimePassword
Set rs = Server.CreateObject("ADODB.Recordset")




' LOAD SETTINGS FOR SITE FROM AASETTINGS TBL, SAVE TO SESSION VARS
if isempty(session("aasetid")) or (not isnumeric(session("aasetid"))) then
	sSQL = "SELECT aasetid, clientid, orgid, orgname, aamodel, aafromemail, headimage, headalttext, " _
		& "sitestyle from aasettings where actionurl like '" & HTTP_HOST & "'"
	rs.Open sSQL, conn, adOpenStatic
	if not rs.eof then
		session("aasetid") = rs("aasetid")
		session("client_id") = rs("clientid")
		session("orgid") = rs("orgid")
		session("orgname") = rs("orgname")
		session("aamodel") = rs("aamodel")
		session("client_email") = rs("aafromemail")
		session("headimage") = rs("headimage")
		session("headalttext") = rs("headalttext")
		session("sitestyle") = rs("sitestyle")
		session("url") = HTTP_HOST
	end if
	rs.Close
end if

if Request.QueryString("orgid") <> "" then
	session("orgid") = Request.QueryString("orgid")
end if

sAaid = Request.QueryString("aaid")
client_id = Session("client_id")
member_id = session("member_id")


Sub LoginCheck
	If session("member_id") = "" then
		LoggedIn = false
	else
		LoggedIn = true
	end if
end Sub



' SET UP HORIZONTAL LINES FOR DIFFERENT BROWSERS
dim hr
dim vr
dim hrtype
hrtype = "1"
if (instr(HTTP_USER_AGENT, "MSIE") > 0) and (instr(HTTP_USER_AGENT, "Windows") > 0) then hrtype="2"
select case hrtype
	case "1"
		hr = "<td width=""2"" colspan=""5"" background=""/images/greentableborder.gif"" height=""1"">" _
		& "<img src=""/images/greentableborder.gif"" width=""100%"" height=""1"" border=0 alt=""""></td>"

	case "2"
		hr = "<td colspan=""5"" background=""/images/greentableborder.gif"" width=""2""></td>"
end select
vr = "<td background=""/images/greentableborder.gif"" width=""2""><img src=""/images/greentableborder.gif"" width=""2"" border=""0"" alt="""" height=""1""></td>"
td3 = "<td colspan=""3"" width=""570"" valign=""top"">"





SUB pagetop(title)
%>
<HTML>
	<HEAD>
		<TITLE><%= title %></TITLE>
		<META content="text/html; charset=windows-1252" http-equiv=Content-Type>
		<link rel="STYLESHEET" type="text/css" href="inc/external.css">	
		<script Language="JavaScript">
		<!--
			if (document.images) {
			  image1on = new Image();
			  image1on.src = "images/nav_h_home.gif";

			  image2on = new Image();
			  image2on.src = "images/nav_h_actionalerts.gif";

			  image3on = new Image();
			  image3on.src = "images/nav_h_join.gif";

			  image4on = new Image();
			  image4on.src = "images/nav_h_contactus.gif";

			  image5on = new Image();
			  image5on.src = "images/nav_h_sponsors.gif";

			  image1off = new Image();
			  image1off.src = "images/nav_home.gif";

			  image2off = new Image();
			  image2off.src = "images/nav_actionalerts.gif";

			  image3off = new Image();
			  image3off.src = "images/nav_join.gif";

			  image4off = new Image();
			  image4off.src = "images/nav_contactus.gif";

			  image5off = new Image();
			  image5off.src = "images/nav_sponsors.gif";

			}

			function changeImages() {
			  if (document.images) {
			    for (var i=0; i<changeImages.arguments.length; i+=2) {
			      document[changeImages.arguments[i]].src = eval(changeImages.arguments[i+1] + ".src");
			    }
			  }
			}
		-->
		</script>
	</HEAD>
	<BODY bgColor=#ffffff>
		<center>
		<table WIDTH="575" BORDER="0" CELLSPACING="0" CELLPADDING="0">
			<tr>
				<%= vr %>
				<td colspan=5><img height="65" width="571" src="/images/<%= session("headimage") %>" border=0 alt="<%= session("headalttext") %>"></td>
				<%= vr %>
			</tr>
			<tr>
				<%= vr %>
				<td width=81><a href="default.asp" onMouseOver="changeImages('image1', 'image1on')" onMouseOut="changeImages('image1', 'image1off')"><img name="image1" src="images/nav_home.gif" border=0 onMouseOver="changeImages('image1', 'image1on')" onMouseOut="changeImages('image1', 'image1off')"></a></td>
				<td width=162><a href="alertlist.asp"><img name="image2" src="images/nav_h_actionalerts.gif" border=0></a></td>
				<td width=80><a href="signup.asp" onMouseOver="changeImages('image3', 'image3on')" onMouseOut="changeImages('image3', 'image3off')"><img name="image3" src="images/nav_join.gif" border=0></a></td>
				<td width=141><a href="contact.asp" onMouseOver="changeImages('image4', 'image4on')" onMouseOut="changeImages('image4', 'image4off')"><img name="image4" src="images/nav_contactus.gif" border=0></a></td>
				<td width=107><a href="sponsors.asp" onMouseOver="changeImages('image5', 'image5on')" onMouseOut="changeImages('image5', 'image5off')"><img name="image5" src="images/nav_sponsors.gif" border=0></a></td>				
				<%= vr %>
			</tr>
		</table>
		<table WIDTH="575" BORDER="0" CELLSPACING="0" CELLPADDING="0">
			<tr>
				<%= vr %>
				<td align=left colspan=2>&nbsp;&nbsp;<%if session("fname") <> "" then%><FONT FACE=arial SIZE=2><b>Welcome <% = session("fname")%></b> [<a href="changeinfo.asp">Update Profile</a>] | [<a href="logout.asp">Log Out</a>]</font><%else%><FONT FACE=arial SIZE=2><% = session("url")%></font><%end if%></td>
				<td align=right><FONT FACE=arial SIZE=2><% = FormatDateTime(Now, 1)%></font>&nbsp;&nbsp;</td>
				<%= vr %>
			</tr>
			<tr><%= hr %></tr>

				<% 'Show feedback at top of page
				if session("aafb") > "" then
					Response.Write "<tr>" & vr & "<td colspan=""3"" align=""center""><hr width=""50%"" color=""#FF0000"" size=""1"" noshade>" _
						& "<font color=ff0000 class=HEADtitle><b>" & session("aafb") & "</b></font>" _
						& "<hr width=""50%"" size=""1""  color=""#FF0000"" noshade></td>" & vr & "</tr>"
					session("aafb") = ""
				end if
				%>
			<tr><%= vr %>

<% end sub




SUB pagebottom ()
 	%>				
			<%= vr %>
			</tr>
			<tr><%= hr %></tr>
			<tr>
				<%= vr %>
				<td colspan=3 valign=middle height=25><center>
					<font class=TOPSTORYcaption>
					<a href="default.asp">Action Center</a> | <a href="alertlist.asp">Act Now</a> | <a href="signup.asp">Sign Up</a> | <a href="myactions.asp">My Actions</a> | <a href="contact.asp">How To...</a>
					</font></center>
				</td>
				<%= vr %>
			</tr>
			<tr><%= hr %></tr>
			<tr>
				<%= vr %>
				<td colspan=3>
					<center>
					<font class=TOPSTORYcaption><br>
					Copyright &copy; <%
					theyear = cstr(year(date)) 
					if theyear > "2001" then theyear = "2001-" & theyear
					response.write theyear & " " & session("orgname") %>.  
					<a href="privacy.asp">Privacy Policy</a><br>
					</font><br>
					<a href="http://www.thedatabank.com">
					<img src="images/powered-thedatabank.gif" alt="" width="90" height="33" border="0">
					</a>
					</center>
				</td>
				<%= vr %>
			</tr>
			<tr><%= hr %></tr>
		</table><br>
		</center>
	</BODY>
	</HTML>
	<% 
	conn.Close
	set rs = nothing
	set conn = nothing

end sub
%>