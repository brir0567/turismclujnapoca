import HtmlTemplate;
import WebStrings;
import Directory;
import Log;
import std.stdio;

class SiteMap
{  
  public string createWebPage (string[] directoriesList)
  {
    string result = "";
    HtmlTemplate htmlTemplate = new HtmlTemplate();
    result ~= htmlTemplate.getHeaderHtml("Sitemap", "Sitemap", "Sitemap");
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
    result ~= `<div id="sitemap">`;
    WebStrings webStrings = new WebStrings();    
    result ~= std.string.format(" <h2><a title=\"%s\" href=\"%s.html\">%s</a></h2><br/>\n ", 
				  "Homepage", "index", "Homepage");
    result ~= getTagsHtml();
    foreach (string directoryFilename; directoriesList)
    {
      Directory directory = new Directory(directoryFilename);
      string title = directory.getTitle();
      string titleUrlencoded = webStrings.convertStringToUrl(title);
      result ~= std.string.format(" <h2><a title=\"%s\" href=\"%s.html\">%s</a></h2><br/>\n ", 
				  title, titleUrlencoded, title);
    }
    result ~= `</div>`;
    return result;
  }

  private string getTagsHtml()
  {
    string result = "";
    const string TAGS_HTEMPLATE = "tags.htemplate";
    if (std.file.exists(TAGS_HTEMPLATE))
    {
      auto file = File(TAGS_HTEMPLATE);
      char[] buf;
      while (file.readln(buf))
      {
	string line = buf.idup;
	std.string.strip(line);
	if (line != "")
	{
	  if (result == "")
	  {
	    result ~= "<br/>\n";
	  }
	  result ~= ` <h2>` ~ line ~ "</h2><br/>\n";
	}
      }
      if (result <> "")
      {
	result ~= "<br/>\n";
      }
    }
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