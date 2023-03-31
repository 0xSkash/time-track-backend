import Swiftgger
import Vapor

struct OpenAPIGenerator: Command {
    struct Signature: CommandSignature {}

    static let outputFileName = "openapi"
    static let outputFilePathExtension = "json"
    static let outputDirectory = FileManager.default.currentDirectoryPath

    var help: String {
        "Generates OpenAPI Docs JSON File"
    }

    func run(using context: CommandContext, signature: Signature) throws {
        let docs = OpenAPIBuilder(
            title: "Time Track API Docs",
            version: "1.0.0",
            description: "API Docs for the Time Track Backend",
            contact: APIContact(
                name: "Skash",
                url: URL(string: "https://github.com/0xSkash")
            )
        )
        .appendClientDocs()
        .built()

        guard let fileURL = try? createJSONOutputFileFromDocs(docs: docs) else {
            fatalError(
                "failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding"
            )
        }

        context.console.print("OpenAPI file written to \(fileURL)")
    }

    private func createJSONOutputFileFromDocs(docs: OpenAPIDocument) throws -> URL {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        let jsonData = try! encoder.encode(docs)
        let jsonOptionalString = String(bytes: jsonData, encoding: .utf8)

        let jsonString = jsonOptionalString ?? "empty"

        let fileURL = URL(fileURLWithPath: OpenAPIGenerator.outputDirectory)
            .appendingPathComponent(OpenAPIGenerator.outputFileName)
            .appendingPathExtension(OpenAPIGenerator.outputFilePathExtension)

        try jsonString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)

        return fileURL
    }
}
