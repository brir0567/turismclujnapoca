import std.xml;
import Tag;
import std.file;

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
      //xml.onEndTag["title"] = (in Element e) { book.title = e.text(); };
      xml.parse(); 
      result ~= tag; 
    }; 
    xmlDocument.parse();
    return result;
  }

  public string getTagsListHtml()
  {
    string result = "";
    foreach (Tag tag; tagsList)
    {
      result ~= tag.title ~ "  eee  ";
    }
    return result;
  }

}