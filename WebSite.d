import std.stdio;
import std.file;
import Config;
import Log;
import Config;
import Database;

class WebSite
{
  void main()
  {
    try
    {
      string replyContent = getReplyContent();
      writeln(replyContent);
      writeln(getLogEntries());
    } 
    catch (Exception e) 
    {
      writeln("Content-type: text/html\n\n" ~ e.msg);
    }
  }

  string getReplyContent()
  {
    string result = "";
    result ~= "Content-type: text/html\n\n".dup;
    result ~= getMainContent();
    return result;
  }

  private string getMainContent()
  {
    string result;

    Config config = new Config();
    Database database = new Database(config.dbDirectory);
    result ~= database.getWebPage();
    //result ~= database.getMainContent();
    //result ~= getDBDescription().dup;
    //result ~= getAllDirectories().dup;
    return result;
  }

  //private char[] getDirectory(string directory)
  //{
  //  result ~= std.string.format("<a name=\"%s\">", directory);
  //}

  private char[] getLogEntries()
  {
    return contentOfLog;
  }

}