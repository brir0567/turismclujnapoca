import Log;
import std.process;
import std.file;
import std.array;

  static if (getExistsTesseractOcr())
  {
    enum int existsTesseractOcr = 1;
  }
  else
  {
    enum int existsTesseractOcr = 0;
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

class CharacterRecognition
{
  public void recognize(string imageFilename)
  {
    if (1 == existsTesseractOcr)
    {
      recognizeUsingTessearctOcr(imageFilename);
      Log.info("Tesseract binary was found.");
    }
    else
    {
      Log.error("Could not find tesseract binary file.");
    }
  }

  private string getFilenameForOcr(string imageFilename)
  {
    string result = "";
    int position = std.string.lastIndexOf(imageFilename, ".");
    if (position >= 0)
    {
      string filename = imageFilename;
      std.array.replaceInPlace(filename, position, position + 1, "_.");
      Log.info("dot name '%s'.", filename);
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