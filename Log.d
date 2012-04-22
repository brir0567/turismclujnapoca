char[] contentOfLog;

void info(string value)
{
  contentOfLog ~= ("info, " ~ value ~ "<br/>");
}
