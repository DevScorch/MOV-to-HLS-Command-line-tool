//
//  main.swift
//  HLS Converter
//
//  Created by Johan Sas on 29/03/2021.
//

import Foundation


// MARK: Change the path to the path where you want to save the export
let path: String = "/Volumes/LaCie/Devscorch Platform/Exports/Courses/Learn Swift 5 and UIKit/Section 2 Swift for beginners/"


@discardableResult
func run(_ cmd: String) -> String? {
    let pipe = Pipe()
    let process = Process()
    process.launchPath = "/usr/local/bin/ffmpeg"
    process.arguments = ["-c", String(format:"%@", cmd)]
    process.standardOutput = pipe
    let fileHandle = pipe.fileHandleForReading
    process.launch()
    return String(data: fileHandle.readDataToEndOfFile(), encoding: .utf8)
}

func convertToHLS() {
    do {
        let content = try FileManager.default.contentsOfDirectory(atPath: path)
        let videos = content.filter { $0.hasSuffix(".mov")}
        
        for vid in videos {
            let vidprefix = vid.deletingSufix(".mov")
            print(vidprefix)
            
             run("ffmpeg -i /\(vidprefix).mov  -c:a aac -ar 48000 -c:v h264 -profile:v main -crf 20 -sc_threshold 0 -g 48 -keyint_min 48 -hls_time 4 -hls_playlist_type vod -b:v 5000k -maxrate 5350k -bufsize 7500k -b:a 192k HLS/\(vidprefix)/index.m3u8")
        }
    } catch  {
        // Do something
    }
}

convertToHLS()


extension String {
    func deletingSufix(_ sufix: String) -> String {
        guard self.hasSuffix(sufix) else { return self }
        return String(self.dropLast(sufix.count))
    }
}





