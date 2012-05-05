import Thumbnailer;
import FileUtils;

class Image
{
  private string imageFilename;

  this(string imageFilename)
  {
    this.imageFilename = imageFilename;
  }

  public string getHtml()
  {
    string result;
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