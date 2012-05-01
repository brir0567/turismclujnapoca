import FileUtils;
import Thumbnailer;
import std.file;

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
    result = fileUtils.ReadFileContents(baseDirectory ~ "/title.txt");
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

  private char[] getDirectory_ImagesHtml()
  {
    char[] result;
    foreach (string imageFilename; std.file.dirEntries(baseDirectory, "*.{JPG,jpg}", SpanMode.shallow))
    {
      result ~= getImageHtml(imageFilename);
    }
    return result;
  }  

  private char[] getImageHtml(string imageFilename)
  {
    char[] result;
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
      if (std.file.exists(textFilename))
      {
	result ~= `<p>` ~ std.file.readText(textFilename).dup ~ `</p>`;
      }
    }
    return result;
  }
}