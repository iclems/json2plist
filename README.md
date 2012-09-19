json2plist
==========

Clément Wehrung @cwehrung (cwehrung@nurves.com)
Adapted from johne: http://stackoverflow.com/questions/6066350/command-line-tool-for-converting-plist-to-json
JSONKit: https://github.com/johnezang/JSONKit

*Provides json2plist and plist2json for OS X*

Recognizes the file format from extension (.plist or .json). If no destination file provided, the origin will be the destination and the file will have the new file extension

*Build:*
gcc -o plist2json plist2json.m JSONKit.m -framework Foundation

*Install:*
sudo cp plist2json /usr/local/bin/plist2json
ln -s /usr/local/bin/plist2json /usr/local/bin/json2plist

//
// 
// Adapted from johne: http://stackoverflow.com/questions/6066350/command-line-tool-for-converting-plist-to-json
//
// alternatively: plutil -convert json Data.plist
//
// usage: FILE_FROM (optional: FILE_TO)
// recognizes the file format from extension (.plist or .json)
// if no FILE_TO provided, FILE_TO is FILE_FROM with new file extension
