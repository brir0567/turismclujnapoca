
class Directory
{
  private string baseDirectory;

  public Directory(string baseDirectory)
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
    //result ~= getAllDirectoriesHtml();
    result ~= getAfterHtml();
    return result;
  }

  private string getTitleHtml(ref string title)
  {
    string result = "";
    FileUtils fileUtils = new FileUtils();
    title = fileutils.ReadFileContents(baseDirectory ~ "/title.txt");
    result = title;
    return result;
  }

  private string getBeforeHtml()
  {
    FileUtils fileUtils = new FileUtils();
    return fileutils.ReadFileContents(baseDirectory ~ "/before.txt");
  }

  private string getAfterHtml()
  {
    FileUtils fileUtils = new FileUtils();
    return fileutils.ReadFileContents(baseDirectory ~ "/after.txt");
  }
}