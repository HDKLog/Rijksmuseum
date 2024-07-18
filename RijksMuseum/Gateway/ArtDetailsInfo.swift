import Foundation

struct ArtDetailsInfo: Decodable {
    struct Art: Decodable {
        struct ImageInfo: Decodable {
            let guid: String
            let offsetPercentageX: Int
            let offsetPercentageY: Int
            let width: Int
            let height: Int
            let url: String
        }

        var id: String
        var priref: String
        var objectNumber: String
        var language: String
        var title: String
        var copyrightHolder: String?
        var webImage: ImageInfo?
        var description: String
    }
    
    var artObject: Art
}
