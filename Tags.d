import std.xml;
import Tag;
import std.file;
import WebStrings;

class Tags
{ 
  private string baseDirectory;
  private Tag[] tagsList;

  this(string baseDirectory)
  {    
    this.baseDirectory = baseDirectory;
    tagsList = getTagsList();
  }

  public void createWebPages()
  {
  }

  public Tag[] getTagsList()
  {
    Tag[] result;
    string s = cast(string)std.file.read(baseDirectory ~ "/tags.xml"); // Check for well-formedness check(s);
    std.xml.check(s);
    auto xmlDocument = new DocumentParser(s); 
    xmlDocument.onStartTag["Tag"] = (ElementParser xml) 
    { 
      Tag tag;
      xml.onEndTag["Title"] = (in Element e) { tag.title = e.text(); }; 
      xml.onEndTag["Description"] = (in Element e) { tag.description = e.text(); }; 
      xml.onEndTag["Keywords"] = (in Element e) { tag.keywords = e.text(); }; 
      xml.onEndTag["Before"] = (in Element e) { tag.before = e.text(); }; 
      xml.onEndTag["After"] = (in Element e) { tag.after = e.text(); }; 
      //xml.onEndTag["Directories"] = (ElementParser xml) 
      //{
	//xml.onEndTag["Directory"] = (in Element e) { tag.directories ~= e.text(); }; 
	//};
      xml.parse(); 
      result ~= tag; 
    }; 
    xmlDocument.parse();
    return result;
  }

  public string getTagsListHtml()
  {
    string result = "";
    WebStrings webStrings = new WebStrings();
    foreach (Tag tag; tagsList)
    {
      result ~= std.string.format(" <a title=\"%s\" href=\"%s.html\">%s</a>\n ", 
				  tag.title, webStrings.convertStringToUrl( tag.title), tag.title);
    }
    return result;
  }

}