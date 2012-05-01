import std.stdio;
import std.file;
import Config;
import Thumbnailer;
import Log;
import Directory;

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
    char[] content;

    content ~= "Content-type: text/html\n\n".dup;
    content ~= getHeader().dup;
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

  private string getMainContent()
  {
    string result;

    Database database = new Database();
    result ~= database.getMainContent();
    result ~= getDBDescription().dup;
    result ~= getAllDirectories().dup;
    return result;
  }


  private string getTableOfContents()
  {
    string result = "";
    foreach (DirEntry e; std.file.dirEntries(config.dbDirectory, SpanMode.shallow))
    {
      if (e.isDir)
      {
	result ~= std.string.format("<a href=\"%s\">%s</a>", e.name, e.name); //getDirectory(e.name);
      }
    }
  }

  private char[] getAllDirectories()
  {
    char[] result;
    Config config = new Config();
    

    foreach (DirEntry e; std.file.dirEntries(config.dbDirectory, SpanMode.shallow))
    {
      if (e.isDir)
      {
	result ~= getDirectory(e.name);
      }
    }
    return result;
  }

  private char[] getDirectory(string directory)
  {
    char[] result;
    result ~= std.string.format("<a name=\"%s\">", directory);
    result ~= getDirectory_Before(directory);
    result ~= getDirectory_Images(directory);
    result ~= getDirectory_After(directory);
    return result;
  }

  private char[] getDirectory_Before(string directory)
  {
    char[] result;
    string filename = directory ~ "/before.txt";
    if (std.file.exists(filename))
    {
      result = std.file.readText(filename).dup;
    }
    return result;
  } 

  private char[] getDirectory_After(string directory)
  {
    char[] result;
    string filename = directory ~ "/after.txt";
    if (std.file.exists(filename))
    {
      result = std.file.readText(filename).dup;
    }
    return result;
  }  

  private char[] getDirectory_Images(string directory)
  {
    char[] result;
    foreach (string imageFilename; std.file.dirEntries(directory, "*.{JPG,jpg}", SpanMode.shallow))
    {
      result ~= getImage(imageFilename);
    }
    return result;
  }  

  private char[] getImage(string imageFilename)
  {
    char[] result;
    string thumbFilename = imageFilename ~ "_thm.png";
    if (!std.file.exists(thumbFilename))
    {
      Thumbnailer thumbnailer = new Thumbnailer();
      thumbnailer.generateThumbnail(imageFilename, thumbFilename);
    }
    if (std.file.exists(thumbFilename))
    {
      result ~= std.string.format(`<p><a href="%s" target="_blank"><img class="dbimage" src="%s" /></a></p>
`,
				  imageFilename, thumbFilename);
      string textFilename = imageFilename ~ ".txt";
      if (std.file.exists(textFilename))
      {
	result ~= `<p>` ~ std.file.readText(textFilename).dup ~ `</p>`;
      }
    }
    return result;
  }

  private char[] getLogEntries()
  {
    return contentOfLog;
  }

}