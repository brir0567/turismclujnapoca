import std.file;
import std.array;

class HtmlTemplate
{
  public string getHeaderHtml(string title, string description, string keywords)
  {
    string result;
    result = std.file.readText("template/header.htemplate");
    result = result.replace("<title></title>", std.string.format("<title>%s</title>", title));
    result = result.replace(`<meta name="description" content="" />`, std.string.format(`<meta name="description" content="%s" />`, keywords));
    result = result.replace(`<meta name="keywords" content="" />`, std.string.format(`<meta name="keywords" content="%s" />`, keywords));
    return result;
  }

  public string getFooterHtml()
  {
    string result;
    result = std.file.readText("template/footer.htemplate");
    return result;
  }

}