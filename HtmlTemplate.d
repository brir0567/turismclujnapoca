import std.file;

class HtmlTemplate
{
  public char[] getHeaderHtml()
  {
    char[] result;
    result = std.file.readText("template/header.htemplate").dup;
    return result;
  }

  public char[] getFooterHtml()
  {
    char[] result;
    result = std.file.readText("template/footer.htemplate").dup;
    return result;
  }

}