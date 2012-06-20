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
      if (!imageDescription.length)
      {
	Log.info("Missing file: " ~ imageFilename ~ ".txt");
      }
      else
      {
        const bool RENAME_IMAGES = true;
        if (RENAME_IMAGES) 
        {
	  if (std.string.indexOf(imageFilename, "IMG_") >= 0)
	  {	
	    string oldImageText = imageFilename ~ ".txt";
	    string directoryFilename = "";
	    int position = std.string.lastIndexOf(imageFilename, "/");
	    if (position >= 0)
	    {
		directoryFilename = imageFilename[0..position];
	    }
	    WebStrings webStrings = new WebStrings();
	    string shortImageFilename = webStrings.convertStringToFilename(imageTitle);
	    string newImageFilename = std.string.format("%s/%s.jpg", directoryFilename, shortImageFilename);
	    string newImageThumbnail = newImageFilename ~ "_thm.png";
	    string newImageText = newImageFilename ~ ".txt";
	    Log.info("'%s' '%s' '%s' -> '%s' '%s' '%s'", imageFilename, thumbFilename, oldImageText,
		     newImageFilename, newImageThumbnail, newImageText);
	    std.file.copy(imageFilename, newImageFilename); 
	    std.file.copy(thumbFilename, newImageThumbnail); 
	    std.file.copy(oldImageText, newImageText);
	  }
        }
        result ~= std.string.format(`<p><a href="%s" target="_blank"><img class="dbimage" alt="%s" title="%s" src="%s" /></a></p>
`,
				  imageFilename, imageTitle, imageTitle, thumbFilename);
        if (imageDescription.length)
        {
	  result ~= `<p class="img_text">` ~ imageDescription ~ `</p>`;
        }
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