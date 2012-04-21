import std.stdio;
import std.file;
import Config;

class WebSite
{
  void main()
  {
    try
    {
      string replyContent = getReplyContent();
      writeln(replyContent);
    } 
    catch (Exception e) 
    {
      writeln("Content-type: text/html\n\n" ~ e.msg);
    }
  }

  string getReplyContent()
  {
    string result = "";
    char[] content;

    content ~= "Content-type: text/html\n\n".dup;
    content ~= getHeader().dup;
    content ~= "test".dup;
    content ~= getMainContent();
    content ~= getFooter().dup;

    result = content.idup;
    return result;
  }

  private char[] getHeader()
  {
    char[] result;
    result = std.file.readText("template/header.htemplate").dup;
    return result;
  }

  private char[] getFooter()
  {
    char[] result;
    result = std.file.readText("template/footer.htemplate").dup;
    return result;
  }

  private char[] getMainContent()
  {
    char[] result;

    result ~= getDBDescription().dup;
    result ~= getAllDirectories().dup;
    return result;
  }

  private char[] getDBDescription()
  {
    char[] result;
    Config config = new Config();
    char[] filename = config.dbDirectory.dup ~ "before.txt";
    if (std.file.exists(filename))
    {
      result = std.file.readText(filename).dup;
    }
    return result;
  }

  private char[] getAllDirectories()
  {
    char[] result;

    return result;
  }

}