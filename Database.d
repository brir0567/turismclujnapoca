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
    std.file.write("index.html", result);
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

  private string getTableOfContentsHtml(string[] directoriesList)
  {
    string result = "";
    result ~= `<div id="toc">`;
    Config config = new Config();
    foreach (directoryFilename; directoriesList)
    {
      Directory directory = new Directory(directoryFilename);
      string title = directory.getTitle();
      UrlEncode urlEncode = new UrlEncode();
      string titleUrlencoded = urlEncode.encode(title);
      result ~= std.string.format("<a href=\"#%s\">%s</a><a class=\"new-page\" href=\"%s.html\"></a><br/>", 
				  titleUrlencoded, title, titleUrlencoded);
    }
    result ~= `</div>`;
    return result;
  }

  private string getCollectionOfLinksForBottomHtml(string[] directoriesList)
  {
    string result = "";
    result ~= `<div id="bottom-links">`;
    Config config = new Config();
    bool isFirstLink = true;
    foreach (directoryFilename; directoriesList)
    {
      Directory directory = new Directory(directoryFilename);
      string title = directory.getTitle();
      UrlEncode urlEncode = new UrlEncode();
      string titleUrlencoded = urlEncode.encode(title);
      if (isFirstLink)
      {
	isFirstLink = false;
      }
      else
      {
	result ~= "|";
      }
      result ~= std.string.format(" <a href=\"%s.html\">%s</a> ", titleUrlencoded, title);
    }
    result ~= `</div>`;
    return result;
  }

  private string getAllDirectoriesHtml()
  {
    string result;
    string[] directoriesList;
    foreach (DirEntry e; std.file.dirEntries(baseDirectory, SpanMode.shallow))
    {
      if (e.isDir)
      {
	directoriesList ~= e.name;
      }
    }
    directoriesList.sort;
    result ~= getTableOfContentsHtml(directoriesList);
    foreach (directoryFilename; directoriesList)
    {
      Directory directory = new Directory(directoryFilename);
      result ~= directory.getMainContentHtml();
      directory.getWebPage();
    }
    result ~= getCollectionOfLinksForBottomHtml(directoriesList);
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
    title = fileUtils.ReadFileContent(baseDirectory ~ "/title.txt");
    title = std.string.strip(title);
    result = std.string.format("<h1>%s</h1>", title);
    return result;
  }

  private string getBeforeHtml()
  {
    FileUtils fileUtils = new FileUtils();
    return fileUtils.ReadFileContent(baseDirectory ~ "/before.txt");
  }

  private string getAfterHtml()
  {
    FileUtils fileUtils = new FileUtils();
    return fileUtils.ReadFileContent(baseDirectory ~ "/after.txt");
  }
}