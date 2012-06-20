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

  public void recognize(string filename)
  {
    static if (getExistsTesseractOcr())
    {
      recognizeUsingTessearctOcr(filename);
    }
  }

  private static bool getExistsTesseractOcr()
  {
    bool result = false;
    
    return result;
  }

  private void recognizeUsingTessearctOcr(string filename)
  {
    //a
  }

}