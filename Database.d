
class Database
{
  private string baseDirectory;
  public Database(string baseDirectory)
  {
    this.baseDirectory = baseDirectory;
  }

  public string getWebPage()
  {
    string result = "";
    return result;
  }

  public string getMainContentHtml()
  {
    string result = "";
    result ~= getTitleHtml();
    result ~= getBeforeHtml();
    result ~= getAllDirectoriesHtml();
    result ~= getAfterHtml();
    rturn result;
}

  private string getBeforeHtml()
  {
    FileUtils fileUtils = new FileUtils();
    return fileutils.ReadFileContents(baseDirectory ~ "/before.txt");
  }
}