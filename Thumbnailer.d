import std.file;
import Log;

class Thumbnailer
{
  void generateThumbnail(string imageFilename, string thumbnailFilename)
  {
    if (std.file.exists(imageFilename))
    {
      string commandLines = std.string.format(`convert -define jpeg:size=800x800  %s  -auto-orient \
          -thumbnail 400x400   -unsharp 0x.5  %s.gif && \
convert -page +4+4 %s.gif -matte \
          \( +clone -background black -shadow 60x4+4+4 \) +swap \
          -background none -mosaic     %s`, 
					     imageFilename, imageFilename, imageFilename, thumbnailFilename);
      std.process.system(commandLines);
      info(commandLines);
    }
  }
}