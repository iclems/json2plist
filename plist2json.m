// plist2json / json2plist
//
// Clément Wehrung @cwehrung (cwehrung@nurves.com)
// Adapted from johne: http://stackoverflow.com/questions/6066350/command-line-tool-for-converting-plist-to-json
//
// alternatively: plutil -convert json Data.plist
//
// usage: FILE_FROM (optional: FILE_TO)
// recognizes the file format from extension (.plist or .json)
// if no FILE_TO provided, FILE_TO is FILE_FROM with new file extension

#import <Foundation/Foundation.h>
#import "JSONKit.h"

int main(int argc, char *argv[]) {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  if(argc < 2) { fprintf(stderr, "usage: %s FILE_FROM (optional: FILE_TO)\n", argv[0]); exit(5); }

    NSString *startFileNameString = [NSString stringWithUTF8String:argv[1]];
    
    BOOL convertPlistToJSON = NO;
    
    if ([startFileNameString.pathExtension isEqualToString:@"plist"])
    {
        convertPlistToJSON = YES;
    }
    else if (![startFileNameString.pathExtension isEqualToString:@"json"])
    {
        fprintf(stderr, "use .plist or .json files\n", argv[0]); exit(5);
    }
    
    NSString *endFileNameString = nil;
    
    if (argc == 3)
    {
        endFileNameString = [NSString stringWithUTF8String:argv[2]];
    } else
    {
        endFileNameString = [startFileNameString.stringByDeletingPathExtension stringByAppendingPathExtension:(convertPlistToJSON)?@"json":@"plist"];
    }

  NSError *error = NULL;

  NSData *fileData = [NSData dataWithContentsOfFile:startFileNameString options:0UL error:&error];
  if(fileData == NULL) {
    NSLog(@"Unable to read file.  Error: %@, info: %@", error, [error userInfo]);
    exit(1);
  }

    NSData *writeData = nil;
    
    if (convertPlistToJSON)
    {
          id plist = [NSPropertyListSerialization propertyListWithData:fileData options:NSPropertyListImmutable format:NULL error:&error];
          if(plist == NULL) {
            NSLog(@"Unable to deserialize property list.  Error: %@, info: %@", error, [error userInfo]);
            exit(1);
          }

          writeData = [plist JSONDataWithOptions:JKSerializeOptionPretty error:&error];
          if(writeData == NULL) {
            NSLog(@"Unable to serialize plist to JSON.  Error: %@, info: %@", error, [error userInfo]);
            exit(1);
          }
    }
    else
    {
        JSONDecoder *decoder = [JSONDecoder decoder];
        id json = [decoder objectWithData:fileData error:&error];
        
        if (json == NULL)
        {
            NSLog(@"Unable to deserialize JSON list.  Error: %@, info: %@", error, [error userInfo]);
            exit(1);
        }
        
        writeData = [NSPropertyListSerialization dataWithPropertyList:json format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
        if(writeData == NULL) {
            NSLog(@"Unable to serialize JSON to plist.  Error: %@, info: %@", error, [error userInfo]);
            exit(1);
        }
    }

  if([writeData writeToFile:endFileNameString options:NSDataWritingAtomic error:&error] == NO)
  {
        NSLog(@"Unable to write to file.  Error: %@, info: %@", error, [error userInfo]);
        exit(1);
  }

  [pool release]; pool = NULL;
  return(0);
}
