import Log;
import std.process;
import std.file;
import std.array;

class CharacterRecognition
{
  private bool existsTesseractOcr = false;
  
  this()
  {
    static if (getExistsTesseractOcr())
    {
      existsTesseractOcr = true;
    }
  }

  public void recognize(string imageFilename)
  {
    if (existsTesseractOcr)
    {
      recognizeUsingTessearctOcr(imageFilename);
    }
  }

  private static bool getExistsTesseractOcr()
  {
    bool result = false;
    const string TESSERACT_FILE = "tesseract";
    if (import(TESSERACT_FILE) != "")
    {
      result = true;
    }
    
    return result;
  }

  private string getFilenameForOcr(string imageFilename)
  {
    string result = "";
    int position = std.string.lastIndexOf(imageFilename, "/");
    if (position >= 0)
    {
      string filename = imageFilename;
      std.array.replaceInPlace(filename, position, position + 1, "/_");
      Log.info("_ name '%s'.", filename);
      result = filename;
    }
    return result;
  }

  private void recognizeUsingTessearctOcr(string imageFilename)
  {
    string imageDescriptionFilename = std.string.format("%s.txt", imageFilename);
    if (!std.file.exists(imageDescriptionFilename))
    {
      string ocrFilename = std.string.format("%s.txt", getFilenameForOcr(imageFilename));
      if (!std.file.exists(ocrFilename))
      {
      string commandLine = std.string.format("/usr/local/bin/tesseract %s %s -l ron", imageFilename, getFilenameForOcr(imageFilename));
      Log.info(commandLine);
      int resultOfSystem = system(commandLine);
      if (-1 == resultOfSystem)
      {
	Log.error("Could not run command line '%s'.", commandLine);
      }
      else if (resultOfSystem != 0)
      {
	Log.error("Process with command line '%s' failed and returned exit code %d.", 
		  commandLine, resultOfSystem);
      }
      else
      {
	Log.info("OCR successful for file '%s'.", imageFilename);
      }
      }
    }
  }

}