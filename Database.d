import FileUtils;
import Config;
import std.file;
import Directory;
import UrlEncode;

class Database
{
  private string baseDirectory;

  this(string baseDirectory)
  {
    this.baseDirectory = baseDirectory;
  }

  public string getWebPage()
  {
    string result = "";
    result ~= getHeaderHtml();
    result ~= getMainContentHtml();
    result ~= getFooterHtml();
    return result;
  }

  public string getMainContentHtml()
  {
    string result = "";
    string title = "";
    result ~= getTitleHtml(title);
    result ~= getBeforeHtml();
    result ~= getTableOfContentsHtml();
    result ~= getAllDirectoriesHtml();
    result ~= getAfterHtml();
    return result;
  }

  private string getTableOfContentsHtml()
  {
    string result = "";
    Config config = new Config();
    foreach (DirEntry e; std.file.dirEntries(config.dbDirectory, SpanMode.shallow))
    {
      if (e.isDir)
      {
	Directory directory = new Directory(e.name);
	string title = directory.getTitle();
	UrlEncode urlEncode = new UrlEncode();
	string titleUrlencoded = urlEncode.encode(title);
	result ~= std.string.format("<a href=\"%s\">%s</a><br/>", titleUrlencoded, title); //getDirectory(e.name);
      }
    }
    return result;
  }

  private string getAllDirectoriesHtml()
  {
    string result;
    foreach (DirEntry e; std.file.dirEntries(baseDirectory, SpanMode.shallow))
    {
      if (e.isDir)
      {
	Directory directory = new Directory(e.name);
	result ~= directory.getMainContentHtml();
      }
    }
    return result;
  }

  private char[] getHeaderHtml()
  {
    char[] result;
    result = std.file.readText("template/header.htemplate").dup;
    return result;
  }

  private char[] getFooterHtml()
  {
    char[] result;
    result = std.file.readText("template/footer.htemplate").dup;
    return result;
  }

  private string getTitleHtml(ref string title)
  {
    string result = "";
    FileUtils fileUtils = new FileUtils();
    title = fileUtils.ReadFileContents(baseDirectory ~ "/title.txt");
    result = std.string.format("<h1>%s</h1>", title);
    return result;
  }

  private string getBeforeHtml()
  {
    FileUtils fileUtils = new FileUtils();
    return fileUtils.ReadFileContents(baseDirectory ~ "/before.txt");
  }

  private string getAfterHtml()
  {
    FileUtils fileUtils = new FileUtils();
    return fileUtils.ReadFileContents(baseDirectory ~ "/after.txt");
  }
}