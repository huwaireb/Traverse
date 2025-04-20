import struct Foundation.Date
import struct Foundation.Locale

struct Manifest: Codable {
    let version: IMDFVersion
    let created: String
    let generatedBy: String?
    let language: Locale.LanguageCode
    let extensions: [String]?
}

enum IMDFVersion: String, Codable {
    case v1_0_0 = "1.0.0"
}

