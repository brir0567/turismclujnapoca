import FileUtils;
import Thumbnailer;
import std.file;
import WebStrings;
import std.algorithm;
import HtmlTemplate;
import Image;
import CharacterRecognition;

class Directory
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
    string title = getTitle();
    result ~= htmlTemplate.getHeaderHtml(title, title, title);
    result ~= getMainContentHtml();
    result ~= htmlTemplate.getFooterHtml();
    std.file.write(getNameOfDestinationFile(), result);
    return result;
  }

  public string getMainContentHtml()
  {
    string result = "";
    string title = "";
    result ~= getTitleHtml(title);
    result ~= getBeforeHtml();
    result ~= getDirectory_ImagesHtml();
    result ~= getAfterHtml();
    return result;
  }

  public string getTitle()
  {
    string result = "";
    FileUtils fileUtils = new FileUtils();
    result = std.string.strip(fileUtils.ReadFileContent(baseDirectory ~ "/title.txt"));
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

  private string getTitleHtml(ref string title)
  {
    string result = "";
    title = getTitle();
    WebStrings webStrings = new WebStrings();
    string titleUrlencoded = webStrings.convertStringToUrl(title);
    result = std.string.format("<h2 id=\"%s\">%s</h2>", titleUrlencoded, title);
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

  private string getDirectory_ImagesHtml()
  {
    string result;
    string[] imagesList;
    foreach (imageFile; std.file.dirEntries(baseDirectory, "*.{JPG,jpg}", SpanMode.shallow))
    {
      imagesList ~= imageFile.name;
    }

    CharacterRecognition characterRecognition = new CharacterRecognition();
    foreach (imageFilename; imagesList.sort)
    {
      characterRecognition.recognize(imageFilename);
      Image image = new Image(imageFilename);
      result ~= image.getHtml();
    }
    return result;
  }

}