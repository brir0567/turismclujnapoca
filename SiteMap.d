import HtmlTemplate;
import WebStrings;

class SiteMap
{  
  public string createWebPage (string[] directoriesList)
  {
    string result = "";
    HtmlTemplate htmlTemplate = new HtmlTemplate();
    result ~= htmlTemplate.getHeaderHtml();
    result ~= getMainContentHtml(directoriesList);
    result ~= htmlTemplate.getFooterHtml();
    std.file.write(getNameOfDestinationFile(), result);
    return result;
  }

  private string getNameOfDestinationFile()
  {
    return "sitemap.html";
  }

  public string getMainContentHtml(string[] directoriesList)
  {
    string result = "";
    string title = "";
    result ~= getTitleHtml(title);
    result ~= getSitemapProperHtml(directoriesList);
    return result;
  }

  private string getSitemapProperHtml(string[] directoriesList)
  {
    string result = "";
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
    return "Sitemap";
  }

}