class Address: Feature<Address.Properties> {
    struct Properties: Codable {
        let address: String
        let unit: String?
        let locality: String
        let province: String?
        let country: String
        let postalCode: String?
        let postalCodeExt: String?
        let postalCodeVanity: String?
    }
}
