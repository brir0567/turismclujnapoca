import FileUtils;
import Config;
import std.file;
import Directory;
import WebStrings;
import HtmlTemplate;
import SearchEngine;
import SiteMap;

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
    HtmlTemplate htmlTemplate = new HtmlTemplate();
    result ~= htmlTemplate.getHeaderHtml();
    result ~= getMainContentHtml();
    result ~= htmlTemplate.getFooterHtml();
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
    WebStrings webStrings = new WebStrings();
    foreach (directoryFilename; directoriesList)
    {
      Directory directory = new Directory(directoryFilename);
      string title = directory.getTitle();
      string titleUrlencoded = webStrings.convertStringToUrl(title);
      result ~= std.string.format("<h2><a title=\"%s\" class=\"new-page\" href=\"%s.html\">%s</a></h2><br/>", 
				  title, titleUrlencoded, title);
    }
    result ~= `</div>`;
    return result;
  }

  private string getCollectionOfLinksForBottomHtml(string[] directoriesList)
  {
    string result = "";
    result ~= `<div id="bottom-links">`;
    bool isFirstLink = true;
    WebStrings webStrings = new WebStrings();
    foreach (directoryFilename; directoriesList)
    {
      Directory directory = new Directory(directoryFilename);
      string title = directory.getTitle();
      string titleUrlencoded = webStrings.convertStringToUrl(title);
      if (isFirstLink)
      {
	isFirstLink = false;
      }
      else
      {
	result ~= "|";
      }
      result ~= std.string.format(" <a title=\"%s\" href=\"%s.html\">%s</a>\n ", 
				  title, titleUrlencoded, title);
    }
    result ~= std.string.format(" <br/>\n<a title=\"%s\" href=\"%s.html\">%s</a>\n ", 
				"Sitemap", "sitemap", "Sitemap");
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
    SearchEngine searchEngine = new SearchEngine("http://www.scs.ubbcluj.ro/~brir0567/");
    searchEngine.generateFilesForCrawler(directoriesList);
    SiteMap siteMap = new SiteMap();
    siteMap.createWebPage(directoriesList);
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