import HtmlTemplate;
import TagConfiguration;
import WebStrings;
import Directory;

class TagWebPage
{
  private string baseDirectory;
  private TagConfiguration tagConfiguration;

  this(string baseDirectory, TagConfiguration tagConfiguration)
  {    
    this.baseDirectory = baseDirectory;
    this.tagConfiguration = tagConfiguration;
  }

  string createWebPage()
  {
    string result = "";
    HtmlTemplate htmlTemplate = new HtmlTemplate();
    result ~= htmlTemplate.getHeaderHtml(tagConfiguration.title, tagConfiguration.title, tagConfiguration.title);
    result ~= getMainContentHtml();
    result ~= htmlTemplate.getFooterHtml();
    std.file.write(getNameOfDestinationFile(), result);
    return result;
  }

  private string getNameOfDestinationFile()
  {    
    string result = "";
    string title = getTitle();
    WebStrings webStrings = new WebStrings();
    string titleUrlencoded = webStrings.convertStringToUrl(title);
    result = std.string.format("%s.html", titleUrlencoded);
    return result;
  }

  public string getMainContentHtml()
  {
    string result = "";
    string title = "";
    result ~= getTitleHtml(title);
    result ~= getBeforeHtml();
    result ~= getDirectoriesAndImagesHtml();
    result ~= getAfterHtml();
    return result;
  }

  private string getDirectoriesAndImagesHtml()
  {
    string result = "";
    //result ~= getTableOfContentsHtml(tagConfiguration.directories);
    foreach (directoryFilename; tagConfiguration.directories)
    {
      Directory directory = new Directory(baseDirectory ~ "/" ~ directoryFilename);
      result ~= directory.getMainContentHtml();
      directory.getWebPage();
    }
    //result ~= getCollectionOfLinksForBottomHtml(directoriesList);
    // result ~= `<div id="sitemap">`;
    // WebStrings webStrings = new WebStrings();    
    // result ~= std.string.format(" <h2><a title=\"%s\" href=\"%s.html\">%s</a></h2><br/>\n ", 
    // 				  "Homepage", "index", "Homepage");
    // foreach (string directoryFilename; directoriesList)
    // {
    //   Directory directory = new Directory(directoryFilename);
    //   string title = directory.getTitle();
    //   string titleUrlencoded = webStrings.convertStringToUrl(title);
    //   result ~= std.string.format(" <h2><a title=\"%s\" href=\"%s.html\">%s</a></h2><br/>\n ", 
    // 				  title, titleUrlencoded, title);
    // }
    // result ~= `</div>`;
    return result;
  }

  private string getTitleHtml(ref string title)
  {
    string result = "";
    title = getTitle();
    WebStrings webStrings = new WebStrings();
    string titleUrlencoded = webStrings.convertStringToUrl(title);
    result = std.string.format("<h2 id=\"%s\">%s</h2>", titleUrlencoded, title);
    return result;
  }

  public string getTitle()
  {
    return tagConfiguration.title;
  }
 
  private string getBeforeHtml()
  {
    return tagConfiguration.before;
  }

  private string getAfterHtml()
  {
    return tagConfiguration.after;
  }

}