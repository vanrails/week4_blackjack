Week 3 Quiz

What is HTML? What is CSS? What is Javascript?
HTML - Hyper Text Markup Language is used to markup content to let a
       browser know how it should be displayed.
CSS  - Cascading Style Sheets is a way of abstracting styling information
       from HTML documents.
Javascript - A scripting language that allows dynamic interactions at 
             the client side by instructing the web browser.

What are the major parts of an HTTP request?
URL, Verb/Method and Parameters.

What are the major parts of an HTTP response?
Status code and Payload.

How do you submit an HTTP POST request, with a "username" attribute set to 
"bob"? What if we wanted a GET request instead?
_POST
To submit this request using the POST method one would place a querry
string in the body of the request. 
In this case one might use a form object:
<form action='/setuser' method='post'>
  <input type='text' name='username' value='bob'>

_GET
some.url/document.rb?username=bob

Why is it important for us, as web developers, to understand that HTTP is a "stateless" protocol?
Because it defines the interactions between the client and the server.
A "stateless" protocol means the server does not 'remember' the user
and must rebuild the entire web view on request.

If the internet is just HTTP requests/responses, why do we only use browsers to interface with web applications? Are there any other options?
It turns out there are many ways in which one interfaces with web
applications i.e. via FTP, POP3.

What is MVC, and why is it important?
Model-View-Controller is a pattern for implementing applications.
MVC is important because it seperates data storage interactions(controller),
program logic(model) and display(view) thus allowing comprehension and
improved testability.

The below questions are about Sinatra:

At a high level, how are requests processed?
The server looks for a corresponding route (method/url) match in a designated file(main.rb) and executes it.

In the controller/action, what's the difference between rendering and redirecting?
Rendering returns a view to the client while redirecting returns an
alternate url to request.

In the ERB view template, how do you show dynamic content?
Displaying dynamic content in the ERB view template relies on instance
variables stored in the session.

Given what you know about ERB templates, when do you suppose the ERB template is turned into HTML?
When the response is triggered.

What's the role of instance variables in Sinatra?
To store data for dynamic web interactions.