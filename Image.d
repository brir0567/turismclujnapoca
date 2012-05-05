import Thumbnailer;
import FileUtils;
import std.string;
import Log;
import WebStrings;

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
      result ~= std.string.format(`<p><a href="%s" target="_blank"><img class="dbimage" alt="%s" title="%s" src="%s" /></a></p>
`,
				  imageFilename, imageTitle, imageTitle, thumbFilename);
      if (imageDescription.length)
      {
	result ~= `<p class="img_text">` ~ imageDescription ~ `</p>`;
      }
      else
      {
	Log.info("Missing file: " ~ imageFilename ~ ".txt");
      }
    }
    return result;
  }

  private void getImageTitleAndDescription(string imageFilename, ref string imageTitle, ref string imageDescription)
  {
    imageTitle = "";
    imageDescription = "";
    FileUtils fileUtils = new FileUtils();
    imageDescription = std.string.strip(fileUtils.ReadFileContent(imageFilename ~ ".txt"));
    imageTitle = getImageTitleFromImageDescription(imageDescription);
  }

  private string getImageTitleFromImageDescription(string imageDescription)
  {
    WebStrings webStrings = new WebStrings();
    string result = webStrings.convertStringToAttributeSafeBeginningOfString(imageDescription);
    auto position = result.indexOf(".");
    if (position > -1)
    {
      result = result[0..position];
    } 
    position = result.indexOf("\r\n\r\n");
    if (position > -1)
    {
      result = result[0..position];
    } 
    else 
    {
      position = result.indexOf("\n\n");
      if (position > -1)
      {
	result = result[0..position];
      } 
    }
    return result;
  }

}