clas FileUtils
{
  public string ReadFileContents(string filename)
  {
    string result = "";
    if (std.file.exists(filename))
    {
      result = std.file.readText(filename);
    }
    return result;
  }
}