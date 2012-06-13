<%
'************************************************************************
'   File:           mailform.asp
'
'   Description:    Mails the submitted form fields to an address specified
'                   in the form's formmailto hidden field.
'					
'					Required fields in the submitted form:
'					
'					formmailto		email address to send form contents
'					formmailcc		who to copy the message to
'					formmailfrom	email address to be shown as sender 
'					formname		used in subject line
'					successpage		after the form is sent, this url is loaded
'					showfields		optional list of fields to show in the email, in order.  
'
'   Author:         Mark A. Paquette
'
'   Copyright:      (c) 2001 thedatabank, inc.
'************************************************************************

Response.Expires = "0"
Response.Buffer=true

mailto = request("formmailto")
if mailto = "" then
	response.write "You need to include a hidden field named ""formmailto"" in your form, with its value set to the email address you want to mail the form's contents to."
	response.end
end if

mailfrom = request("formmailfrom")
if mailfrom = "" then
	mailfrom = "info@thedatabank.com"
end if

formname = request("formname")
if formname = "" then
	formname = "Web Site Form"
end if

embody = ucase(formname) & vbcrlf & "Date: " & cstr(date) & vbcrlf & "Time: " & cstr(time) & vbCrlf & vbCrlf
showfields = request("showfields")
if showfields = "" then
	for each item in request.form
		embody = embody & item & ": " & request(item) & vbcrlf
	next
else
	ashow = split(showfields,",")
	for iii = 0 to ubound(ashow) 
		embody = embody & ashow(iii) & ": " & request(ashow(iii)) & vbcrlf
	next
end if


set m = createobject("cdonts.newmail")
m.from = mailfrom
m.to = mailto
m.bcc = request("formmailcc")
m.subject = "Response: " & formname
m.body = embody
m.send
set m = nothing

successpage = request("formsuccesspage")
if successpage = "" then
	response.write "<html><body><br><br><br><center>Thank you!</center></body></html>"
else
	response.redirect successpage
end if
%>