class UrlEncode
{
  public string encode(string input)
  {
    string result = "";
    foreach (character; input)
    {
      switch (character)
      {
      case 'a': .. case 'z': case 'A': .. case 'Z': case '_': case '-':
	result ~= character;
	break;
      case ' ':
	result ~= '_';
	break;
      default:
	break;
      }
    }
    return result;
  }
}