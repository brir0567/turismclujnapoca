import std.file;
import std.array;
import Log;
import std.stdio;
import std.string;

class HtmlTemplate
{
  public string getHeaderHtml(string title, string description, string keywords, bool isHomepage = false)
  {
    string result;
    result = std.file.readText("template/header.htemplate");
    result = result.replace("<title></title>", std.string.format("<title>%s</title>", title));
    result = result.replace(`<meta name="description" content="" />`, std.string.format(`<meta name="description" content="%s" />`, keywords));
    result = result.replace(`<meta name="keywords" content="" />`, std.string.format(`<meta name="keywords" content="%s" />`, keywords));
    result = result.replace(`<li class="first current_page_item"><a href="index.html">Homepage</a></li>`, getMainMenu(title, isHomepage));
    return result;
  }

  public string getFooterHtml()
  {
    string result;
    result = std.file.readText("template/footer.htemplate");
    result = result.replace(`<!-- Footer tags. -->`, getTagsTemplateHtmlContent());
    return result;
  }

  private string getMainMenu(string title, bool isHomepage)
  {
    string result;
    const string TAGS_HTEMPLATE = "tags.htemplate";
    if (isHomepage)
    {
      result ~= `<li class="first current_page_item"><a href="index.html">Homepage</a></li>` ~ "\n";
    }
    else   
    {
      result ~= `<li class="first"><a href="index.html">Homepage</a></li>` ~ "\n";
    }
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
	  if (line.indexOf(title) >= 0)
	    {
	      result ~= `<li class="current_page_item">` ~ line ~ "</li>\n";
	    }
	  else
	    {
	      result ~= "<li>" ~ line ~ "</li>\n";
	    }
	}
      }
    }
    return result;
  }

  private string getTagsTemplateHtmlContent()
  {
    return std.file.readText("tags.htemplate");
  }

}