import std.file;
import std.array;
import Log;
import std.stdio;

class HtmlTemplate
{
  public string getHeaderHtml(string title, string description, string keywords)
  {
    string result;
    result = std.file.readText("template/header.htemplate");
    result = result.replace("<title></title>", std.string.format("<title>%s</title>", title));
    result = result.replace(`<meta name="description" content="" />`, std.string.format(`<meta name="description" content="%s" />`, keywords));
    result = result.replace(`<meta name="keywords" content="" />`, std.string.format(`<meta name="keywords" content="%s" />`, keywords));
    result = result.replace(`<li class="first current_page_item"><a href="index.html">Homepage</a></li>`, getMainMenu(title));
    return result;
  }

  public string getFooterHtml()
  {
    string result;
    result = std.file.readText("template/footer.htemplate");
    return result;
  }

  private string getMainMenu(string title)
  {
    string result;
    const string TAGS_HTEMPLATE = "tags.htemplate"; //current_page_item
    result ~= `<li class="first"><a href="index.html">Homepage</a></li>` ~ "\n";
    if (std.file.exists(TAGS_HTEMPLATE))
    {
      auto file = File(TAGS_HTEMPLATE);
      char[] buf;
      while (file.readln(buf))
      {
	string line = buf.idup;
	std.string.strip(line);
	if (line != "")
	{
	  result ~= "<li>" ~ line ~ "</li>\n";
	}
      }
    }
    return result;
  }

}