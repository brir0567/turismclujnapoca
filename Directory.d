import FileUtils;
import Thumbnailer;
import std.file;
import UrlEncode;
import std.algorithm;
import HtmlTemplate;

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
    result ~= htmlTemplate.getHeaderHtml();
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
    UrlEncode urlEncode = new UrlEncode();
    string titleUrlencoded = urlEncode.encode(title);
    result = std.string.format("%s.html", titleUrlencoded);
    return result;
  }

  private string getTitleHtml(ref string title)
  {
    string result = "";
    title = getTitle();
    UrlEncode urlEncode = new UrlEncode();
    string titleUrlencoded = urlEncode.encode(title);
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
    foreach (imageFilename; imagesList.sort)
    {
      result ~= getImageHtml(imageFilename);
    }
    return result;
  }

  private char[] getImageHtml(string imageFilename)
  {
    char[] result;
    string imageTitle;
    string imageDescription;
    getImageTitleAndDescription(imageFilename, imageTitle, imageDescription);
string thumbFilename = imageFilename ~ "_thm.png";
    if (!std.file.exists(thumbFilename))
    {
      Thumbnailer thumbnailer = new Thumbnailer();
      thumbnailer.generateThumbnail(imageFilename, thumbFilename);
    }
    if (std.file.exists(thumbFilename))
    {
      result ~= std.string.format(`<p><a href="%s" target="_blank"><img class="dbimage" src="%s" /></a></p>
`,
				  imageFilename, thumbFilename);
      string textFilename = imageFilename ~ ".txt";
      if (imageDescription.length)
      {
	result ~= `<p class="img_text">` ~ imageDescription ~ `</p>`;
      }
    }
    return result;
  }

  private void getImageTitleAndDescription(string imageFilename, ref string imageTitle, ref string imageDescription)
  {
    FileUtils fileUtils = new FileUtils();
    imageDescription = std.string.strip(fileUtils.ReadFileContent(imageFilename ~ ".txt"));
  }

}