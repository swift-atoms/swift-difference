#if os(macOS)
import Foundation
import Testing

@Suite struct `Count conversion requires the same domain` {
    @Test(arguments: [false, true])
    func `the compiler enforces the count domain`(mismatched: Bool) throws {
        var products = Bundle.module.bundleURL
        while !FileManager.default.fileExists(
            atPath: products.appendingPathComponent("Difference.swiftmodule").path
        ) {
            let parent = products.deletingLastPathComponent()
            products = try #require(parent != products ? parent : nil)
        }
        let source = try #require(Bundle.module.resourceURL)
            .appendingPathComponent("Fixtures/Count domain.swift")
        let process = Process()
        let errors = Pipe()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/xcrun")
        process.arguments = [
            "swiftc", "-typecheck", "-swift-version", "6",
            "-enable-experimental-feature", "Lifetimes",
            "-module-name", "Client", "-I", products.path, source.path,
        ] + (mismatched ? ["-D", "MISMATCH_DOMAIN"] : [])
        process.standardError = errors
        try process.run()
        let diagnostic = String(
            decoding: errors.fileHandleForReading.readDataToEndOfFile(), as: UTF8.self
        )
        process.waitUntilExit()
        #expect((process.terminationStatus != 0) == mismatched, "\(diagnostic)")
        if mismatched {
            #expect(diagnostic.contains("First") && diagnostic.contains("Second"))
        }
        #expect(!diagnostic.contains("no such module"))
    }
}
#endif
