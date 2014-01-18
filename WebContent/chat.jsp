<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import="servlets.SessionCounter" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Comet chat demo</title>      
	<script type="text/javascript">
	/*global window, document, newRequest, send, receive, alert, XMLHttpRequest, ActiveXObject*/
	var request, ie;
	
	function newRequest() {
		var httpRequest;
		if (window.XMLHttpRequest) { // Mozilla, Safari, ...
			ie = 0;
			httpRequest = new XMLHttpRequest();
			if (httpRequest.overrideMimeType) {
				httpRequest.overrideMimeType('text/xml');
			}
		}
		else { // IE
			ie = 1;
			try {
				httpRequest = new ActiveXObject("Msxml2.XMLHTTP");
			}
			catch (e) {}
			
			if ( typeof httpRequest == 'undefined' ) {
			
				try {
					httpRequest = new ActiveXObject("Microsoft.XMLHTTP");
				}
				catch (f) {}
			}
		}
		if (!httpRequest) {
			alert('Giving up :( Cannot create an XMLHTTP instance');
			return false;
		}
		else {
			return httpRequest ;
		}

	}

	/* this function receives the chat message and writes it to the text area */
	function receive(request) {
		var txt=document.getElementById("history");
		txt.innerHTML=txt.innerHTML+request.responseText;		
		send('connect');	/* current request is dead, must create a new one */
	}


	/* this function initiates a request, either to send a message or to connect */
	function send(arg) {
		var url = 'Chat';
		
		if ( typeof request == 'undefined' ) {
		/* create new request */
			request =  newRequest() ;
		}

		request.open("POST", url, true);
		request.setRequestHeader("Content-Type", "application/x-javascript;");
		
		request.onreadystatechange = function() {
			/* we are interested only in a complete response */
			if (request.readyState >= 4 && request.status == 200) {				
				if (request.responseText) {
					receive(request);
				}	      
			}
		};

		if ( arg.substring(0,4)=="send") {
			arg = document.messageForm.message.value;
			document.messageForm.message.value="";
			document.messageForm.message.focus();
		
			request.send(arg);
		}
		else if (arg.substring(0,7)=="connect") {
			
			request.send();
		}
	}
	
	
	</script>
</head>

<body onload = "send('connect');">

<form name="messageForm">

<textarea name="history" id="history" readonly cols=80 rows=10 ></textarea><br />
<textarea name="message" id="message" cols=80 rows=2></textarea><br />

<input type="button" value="Send" onclick="send('send');" />

</form>

   <%
    SessionCounter counter = (SessionCounter) session
            .getAttribute("counter");
%>
Number of online user(s): <%= counter.getActiveSessionNumber() %>

</body>
</html>