import Thumbnailer;
import FileUtils;
import std.string;
import Log;

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
    imageTitle = "";
    imageDescription = "";
    FileUtils fileUtils = new FileUtils();
    imageDescription = std.string.strip(fileUtils.ReadFileContent(imageFilename ~ ".txt"));
    imageTitle = getImageTitleFromImageDescription(imageDescription);
  }

  private string getHtmlAttributeSafeBeginningOfString(string text)
  {
    string result = imageDescription;
    auto position = imageDescription.indexOf("<");
    if (position > -1)
    {
      result = imageDescription[0..position];
    }
    return result;
  }

  private string getImageTitleFromImageDescription(string imageDescription)
  {
    string result = imageDescription;
    auto position = imageDescription.indexOf("<");
    if (position > -1)
    {
      result = imageDescription[0..position];
    }
    else
    {
      position = imageDescription.indexOf(".");
      if (position > -1)
      {
	result = imageDescription[0..position];
      } 
      else 
      {
	position = imageDescription.indexOf("\r\n\r\n");
	if (position > -1)
	{
	  result = imageDescription[0..position];
	} 
	else 
	{
	  position = imageDescription.indexOf("\n\n");
	  if (position > -1)
	  {
	    result = imageDescription[0..position];
		} 
	      else 
		{
	   
		}
	    }
	}
    }
    Log.info(result);
    return result;
}

}