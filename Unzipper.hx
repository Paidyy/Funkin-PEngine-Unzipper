import sys.io.Process;
import sys.io.File;
import haxe.zip.Entry;
import haxe.zip.Reader;
import sys.FileSystem;

using StringTools;

class Unzipper {
    public static function print(d:Dynamic) {Sys.println(d);}
    public static function isFolder(d:Dynamic):Bool {return Std.string(d).endsWith("/");}

    static public function main() {
        if (FileSystem.exists("funkin.updat")) {
            print("Found funkin.updat");
            var file = File.read("funkin.updat", true);
            var zipFiles = Reader.readZip(file);
            for (entry in zipFiles) {
                unzip(entry);
            }
            print("Unzipped All files!");
            file.close();

            print("Deleting funkin.updat");
            FileSystem.deleteFile("funkin.updat");
            
            #if cpp
            print("Starting FNF | Windows");
            Sys.command('start "" "${getFunkinPath()}"');
            #elseif neko
            print("Starting FNF | Linux");
            Sys.command("./Funkin");
            #end
            Sys.exit(1);
        }
        else {
            print("Could not find the funkin.updat file");
        }
    }

    public static function getFunkinPath():String {
        var path = "";
        var arr = Sys.programPath().split("/");
        for (i in 0...arr.length - 1) {
            path += arr[i] + "/";
        }
        #if cpp
        path += "Funkin.exe";
        #elseif neko
        path += "Funkin";
        #end
        return path;
    }
    
    public static function unzip(entry:Entry) {
        if (isFolder(entry.fileName)) {
            unzipFolder(entry);
        } else {
            unzipFile(entry);
        }
    }
    public static function unzipFolder(entry:Entry) {
        if (entry.fileName != "PEngine/") {
            print("Unzipping Folder: " + rmvfrFileName(entry.fileName));
            FileSystem.createDirectory(rmvfrFileName(entry.fileName));
        }
    }
    public static function unzipFile(entry:Entry) {
        print("Unzipping File: " + rmvfrFileName(entry.fileName));
        File.saveBytes(rmvfrFileName(entry.fileName), Reader.unzip(entry));
    }

    static function rmvfrFileName(s:String):String {
        return s.substring(8);
    }
}