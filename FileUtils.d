import std.file;

class FileUtils
{
  public string ReadFileContent(string filename)
  {
    string result = "";
    if (std.file.exists(filename))
    {
      result = std.file.readText(filename);
    }
    return result;
  }

  public void WriteContentToFile(string filename, string content)
  {
    if (std.file.exists(filename))
    {
      std.file.remove(filename);
    }
    std.file.write(filename, content);
  }

}