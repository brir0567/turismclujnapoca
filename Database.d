import FileUtils;

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
    return result;
  }

  public string getMainContentHtml()
  {
    string result = "";
    string title = "";
    result ~= getTitleHtml(title);
    result ~= getBeforeHtml();
    //result ~= getAllDirectoriesHtml();
    result ~= getAfterHtml();
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
    title = fileUtils.ReadFileContents(baseDirectory ~ "/title.txt");
    result = title;
    return result;
  }

  private string getBeforeHtml()
  {
    FileUtils fileUtils = new FileUtils();
    return fileUtils.ReadFileContents(baseDirectory ~ "/before.txt");
  }

  private string getAfterHtml()
  {
    FileUtils fileUtils = new FileUtils();
    return fileUtils.ReadFileContents(baseDirectory ~ "/after.txt");
  }
}