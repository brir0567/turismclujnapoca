import FileUtils;
import WebStrings;
import Directory;
import TagConfiguration;

class SearchEngine
{    
  /// E.g. "http://www.scs.ubbcluj.ro/~brir0567/".
  /// Notice the trailing "/".
  private string webSiteRootUrl;
  private TagConfiguration[] tagConfigurations;

  this(string webSiteRootUrl, TagConfiguration[] tagConfigurations)
  {
    this.webSiteRootUrl = webSiteRootUrl;
    this.tagConfigurations = tagConfigurations;
  }

  public void generateFilesForCrawler(string[] directoriesList)
  {
    generateSiteMapXml(directoriesList);
    generateRobotsTxt();
  }

  private void generateSiteMapXml(string[] directoriesList)
  {
    /*<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>http://www.example.com/?id=who</loc>
    <lastmod>2009-09-22</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.8</priority>
  </url>
  <url>
    <loc>http://www.example.com/?id=what</loc>
    <lastmod>2009-09-22</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.5</priority>
  </url>
</urlset>*/
    string content = "";
    content ~= `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">`;
    WebStrings webStrings = new WebStrings();
    content ~= std.string.format("<url>\n<loc>%s%s.html</loc>\n<priority>0.5</priority>\n</url>\n ", 
				   webSiteRootUrl, "index");
    content ~= getTagsXml();
    foreach (string directoryFilename; directoriesList)
    {
      Directory directory = new Directory(directoryFilename);
      string title = directory.getTitle();
      string titleUrlencoded = webStrings.convertStringToUrl(title);
      content ~= std.string.format("<url>\n<loc>%s%s.html</loc>\n<priority>0.5</priority>\n</url>\n ", 
				   webSiteRootUrl, titleUrlencoded);
    }

    content ~= std.string.format("<url>\n<loc>%s%s.html</loc>\n<priority>0.5</priority>\n</url>\n ", 
				   webSiteRootUrl, "sitemap");
    content ~= `</urlset>`;
    FileUtils fileUtils = new FileUtils();
    fileUtils.WriteContentToFile("sitemap.xml", content);
  }

  private void generateRobotsTxt()
  {
    string content = std.string.format("Sitemap: %ssitemap.xml", webSiteRootUrl);
    FileUtils fileUtils = new FileUtils();
    fileUtils.WriteContentToFile("robots.txt", content);
  }

  private string getTagsXml()
  {
    string result = "";
    foreach (TagConfiguration tagConfiguration; tagConfigurations)
    {
      WebStrings webStrings = new WebStrings;
      string title = tagConfiguration.title;
      string titleUrlencoded = webStrings.convertStringToUrl(title);
      result ~= std.string.format("<url>\n<loc>%s%s.html</loc>\n<priority>0.5</priority>\n</url>\n ", 
				   webSiteRootUrl, titleUrlencoded);
    }
    return result;
  }

}