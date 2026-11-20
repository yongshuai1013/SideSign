//
//  SRPCapture.swift
//  SideSign
//
//  Diagnostic capture for the GrandSlam 503 investigation (branch body-capture).
//
//  Records every GrandSlam authentication request this build sends — method,
//  URL, headers and the exact body bytes — to `srp-capture.log` in the app's
//  Documents directory, so the log can be retrieved on-device (Files app)
//  without a computer and compared byte-for-byte against a working stack.
//
//  Capture is strictly read-only: it reads the already-built URLRequest and
//  never modifies the request, the headers, the body, or the auth flow.
//  SRP requests never contain the password, and nothing else is recorded.
//

import Foundation

enum SRPCapture {
    private static let lock = NSLock()
    private static var counter = 0

    static var fileURL: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?
            .appendingPathComponent("srp-capture.log")
    }

    /// Records one outgoing GrandSlam request. `step` is the GrandSlam
    /// operation name ("init", "complete", "apptokens", ...).
    static func record(step: String, request: URLRequest) {
        let method = request.httpMethod ?? "GET"
        let url = request.url?.absoluteString ?? "<nil url>"
        // NOTE: URLRequest does not preserve header insertion order, so the
        // headers are emitted sorted by field name; name casing and values
        // are exactly as stored on the request.
        let headerLines = (request.allHTTPHeaderFields ?? [:])
            .sorted { $0.key.localizedLowercase < $1.key.localizedLowercase }
            .map { "\($0.key): \($0.value)" }
            .joined(separator: "\n")
        let body = request.httpBody ?? Data()
        let bodyText = String(data: body, encoding: .utf8)
        let bodyBase64 = body.base64EncodedString()
        let timestamp = ISO8601DateFormatter().string(from: Date())

        lock.lock()
        counter += 1
        let number = counter
        var text = "\n===SRP-REQ #\(number) step=\(step) \(timestamp)===\n"
        text += "\(method) \(url)\n"
        text += "\(headerLines)\n"
        text += "===SRP-REQ \(step) body begin===\n"
        text += (bodyText ?? "<body is not valid UTF-8; use the base64 block below>")
        text += "\n===SRP-REQ \(step) body end===\n"
        text += "===SRP-REQ \(step) body base64 begin===\n"
        text += "\(bodyBase64)\n"
        text += "===SRP-REQ \(step) body base64 end===\n"
        append(text)
        lock.unlock()

        debugLog("[SideSign] [SRPCapture] recorded \(step) request (#\(number), \(body.count) body bytes) to srp-capture.log")
    }

    private static func append(_ text: String) {
        guard let url = fileURL, let data = text.data(using: .utf8) else { return }
        if let handle = try? FileHandle(forWritingTo: url) {
            defer { handle.closeFile() }
            handle.seekToEndOfFile()
            handle.write(data)
        } else {
            try? data.write(to: url, options: .atomic)
        }
    }
}
