import std.string;

class WebStrings
{
  public string convertStringToUrl(string input)
  {
    string result = "";
    foreach (character; input)
    {
      switch (character)
      {
      case 'a': .. case 'z': case 'A': .. case 'Z': case '-':
	result ~= character;
	break;
      case ' ':
	result ~= '-';
	break;
      case '_':
	result ~= '-';
	break;
      default:
	break;
      }
    }
    return result;
  }

  public string convertStringToFilename(string input, int maximumLength = 120)
  {
    string result = "";
    result = convertStringToUrl(input);
    if (result.length > maximumLength)
    {
      result = result[0..maximumLength];
    }
    return result;
  }

  public string convertStringToAttributeSafeBeginningOfString(string text)
  {
    string result = text;
    auto position = result.indexOf("<");
    if (position > -1)
    {
      result = result[0..position];
    }
    position = result.indexOf("\"");
    if (position > -1)
    {
      result = result[0..position];
    }    
    position = result.indexOf("'");
    if (position > -1)
    {
      result = result[0..position];
    }
    return result;
  }
}