class SiteMap
{  
  private string baseDirectory;

  this(string baseDirectory)
  {
    this.baseDirectory = baseDirectory;
  }

  public string createWebPage (string[] directoriesList)
  {
    string result = "";
    HtmlTemplate htmlTemplate = new HtmlTemplate();
    result ~= htmlTemplate.getHeaderHtml();
    result ~= getMainContentHtml();
    result ~= htmlTemplate.getFooterHtml();
    std.file.write(getNameOfDestinationFile(), result);
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
    result ~= getBeforeHtml();
    result ~= getDirectory_ImagesHtml();
    result ~= getAfterHtml();
    return result;
  }
}