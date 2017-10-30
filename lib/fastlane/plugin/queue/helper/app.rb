require 'sinatra/base'
require 'resque'

STYLESHEET = <<-STYLESHEET
<style>
p {
  text-align: center;
  font-family: arial, sans-serif;
  font-size: 18px;
}
a {
  font-family: arial, sans-serif;
  font-size: 22px;
  color: #000000;
}
a:hover {
  color: #999999;
}
textarea {
  width: 100%;
  font-family: arial, sans-serif;
  font-size: 22px;
  padding: 10px;
}
form {
  text-align: center;
}
input[type="submit"] {
  margin-top: 20px;
  
  -webkit-border-radius: 28;
  -moz-border-radius: 28;
  border-radius: 28px;
  font-family: Arial;
  color: #ffffff;
  font-size: 20px;
  background: #34b2d9;
  padding: 10px 20px 10px 20px;
  text-decoration: none;
  border-width: 1px;
  border-style: solid;
}
input[type="submit"]:hover {
  background: #3cb0fd;
  background-image: -webkit-linear-gradient(top, #3cb0fd, #3498db);
  background-image: -moz-linear-gradient(top, #3cb0fd, #3498db);
  background-image: -ms-linear-gradient(top, #3cb0fd, #3498db);
  background-image: -o-linear-gradient(top, #3cb0fd, #3498db);
  background-image: linear-gradient(to bottom, #3cb0fd, #3498db);
  text-decoration: none;
}
#main {
  max-width: 600px;
  margin: auto;
  text-align: center;
}
#instructions-title {
  font-size: 22px;
  font-weight: bold;
  margin-bottom: 10px;
}
#instructions {
  font-size: 16px;
  color: #999999;
  margin-top: 0px;
  padding-top: 0px;
}
</style>
STYLESHEET

FASTLANE_IMAGE = ""

class App < Sinatra::Base
  get '/' do
    info = Resque.info
    out = "<html><head><title>Resque Demo</title>#{STYLESHEET}</head><body>"
    
    out << '<div id="main">'
    out << '<img src="data:image/png;base64,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" />'
    out << "<p>"
    out << "There are #{info[:pending]} pending and "
    out << "#{info[:processed]} processed jobs across #{info[:queues]} queue(s)"
    out << "</p>"
    out << "<p>"
    out << '<a id="view-rescue" target="_blank">Manage Queue</a>'
    out << "</p>"
    out << '<form method="POST">'
    out << '<textarea rows="10" name="runs" placeholder="fastlane ios build"></textarea>'
    out << '<input type="submit" value="Queue Job(s)"/>'
    out << '</form>'
    out << '<p id="instructions-title">'
    out << 'Instructions'
    out << '</p>'
    out << '<p id="instructions">'
    out << 'Enter one fastlane command per line<br/>'
    out << 'Example: "fastlane ios build environment:staging"<br/>'
    out << '</p>'
    out << '</div>'
    
    out << "</body>"
    out << "<script>"
    out << 'document.getElementById("view-rescue").href = window.location.protocol + "//" + window.location.hostname + ":5678";'
    out << "</script>"
    out << "</html>"
    out
  end

  post '/' do
    runs = params[:runs]
    runs.split("\n").each do |run|
      Resque.enqueue(Job, {run: run})
    end
    redirect "/"
  end
end
