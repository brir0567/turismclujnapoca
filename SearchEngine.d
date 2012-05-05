import FileUtils;

class SearchEngine
{  
  public void generateFilesForCrawler(string[] directoriesList)
  {
    generateSiteMapXml(directoriesList);
    generateRobotsTxt();
  }

  public void generateSiteMapXml(string[] directoriesList)
  {

  }

  public void generateRobotsTxt()
  {
    string content = "Sitemap: http://www.scs.ubbcluj.ro/~brir0567/sitemap.xml";
    FileUtils fileUtils = new FileUtils();
    fileUtils.WriteContentToFile("robots.txt", content);
  }

}