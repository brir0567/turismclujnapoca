import core.vararg;
import std.utf;
import std.exception;

char[] contentOfLog;

string bug2479format1(TypeInfo[] arguments, va_list argptr)
{
    char[] s;

    void putc(dchar c)
    {
        std.utf.encode(s, c);
    }
    std.format.doFormat(&putc, arguments, argptr);
    return assumeUnique(s);
}

void info(string value)
{
  contentOfLog ~= ("info, " ~ value ~ "<br/>");
}

void info(...)
{
  contentOfLog ~= ("info, " ~ bug2479format1(_arguments, _argptr) ~ "<br/>");
}
void error(...)
{
  contentOfLog ~= ("error, " ~ bug2479format1(_arguments, _argptr) ~ "<br/>");
}