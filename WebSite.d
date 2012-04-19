import std.stdio;
import std.file;

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
}