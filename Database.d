import FileUtils;
import Config;
import std.file;
import Directory;


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
	result ~= std.string.format("<a href=\"%s\">%s</a>", e.name, e.name); //getDirectory(e.name);
      }
    }
    return result;
  }

  private char[] getAllDirectoriesHtml()
  {
    char[] result;
    foreach (DirEntry e; std.file.dirEntries(baseDirectory, SpanMode.shallow))
    {
      if (e.isDir)
      {
	//result ~= getDirectory(e.name);
	Directory directory = new Directory(e.name);
	directory.getMainContentHtml();
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