//
//  ECSLogger.swift
//  RimWorld
//
//  Created by wu on 2025/4/25.
//

import Foundation

enum LogLevel: String {
    case info = "ℹ️ INFO"
    case warning = "⚠️ WARNING"
    case error = "❌ ERROR"

    var colorCode: String {
        switch self {
        case .info: return "\u{001B}"    // 青色
        case .warning: return "\u{001B}" // 黄色
        case .error: return "\u{001B}"   // 红色
        }
    }
}

struct ECSLogger {
    static var isLoggingEnabled = true
    static var logToFile = true

    private static let logFileName = "ecs_log.txt"

    // MARK: - 打印日志
    static func log(_ message: String,
                    level: LogLevel = .info,
                    file: String = #file,
                    line: Int = #line,
                    function: String = #function) {
        guard isLoggingEnabled else { return }

        let filename = (file as NSString).lastPathComponent
        let timestamp = currentTime()
//        let logText = "[\(level.rawValue)] [\(timestamp)] [\(filename):\(line)] \(function) ➜ \(message)"
        let logText = "[\(timestamp)] \(function) ➜ \(message)"


        // 控制台输出（带颜色）
        print("\(level.colorCode)\(logText)\u{001B}")

        // 写入文件
        if logToFile {
            writeToFile(logText)
        }
    }

    // MARK: - 读取日志内容
    static func readLog() -> String? {
        guard let url = logFileURL else { return nil }
        return try? String(contentsOf: url, encoding: .utf8)
    }

    // MARK: - 清空日志
    static func clearLog() {
        guard let url = logFileURL else { return }
        try? "".write(to: url, atomically: true, encoding: .utf8)
    }

    // MARK: - 工具方法
    private static var logFileURL: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(logFileName)
    }

    private static func currentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter.string(from: Date())
    }

    private static func writeToFile(_ text: String) {
        guard let url = logFileURL else { return }
        let logEntry = text + "\n"

        if FileManager.default.fileExists(atPath: url.path) {
            if let handle = try? FileHandle(forWritingTo: url) {
                handle.seekToEndOfFile()
                if let data = logEntry.data(using: .utf8) {
                    handle.write(data)
                }
                handle.closeFile()
            }
        } else {
            try? logEntry.write(to: url, atomically: true, encoding: .utf8)
        }
    }
}
