import Dependencies
import Foundation
import XCTestDynamicOverlay
import FirebaseFirestore

struct AssetsApiClient {
    var fetchAllAssets: () async throws -> [Asset]
    var saveFavourite: (User, Asset) async throws -> Void
    var fetchFavourites: (User) async throws -> [String]
    var fetchAsset: (String) async throws -> Asset
}

enum NetworkingError: Error {
    case invalidURL
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        }
    }
}

extension AssetsApiClient: DependencyKey {
    static var liveValue: AssetsApiClient {
        let db = Firestore.firestore().collection("favourites")
        let urlSession = URLSession.shared
        let apiKey = "b658780c36366042da97d87e23bd6bf41ad905cf4305dad1f9ce68c27501ea4d"
        let baseUrl = "https://rest.coincap.io/v3"
        
        return .init(
            fetchAllAssets: {
                guard let url = URL(string: "\(baseUrl)/assets?apiKey=\(apiKey)") else {
                    throw NetworkingError.invalidURL
                }
                let (data, _) = try await urlSession.data(for: URLRequest(url: url))
                let assetsResponse = try JSONDecoder().decode(AssetsResponse.self, from: data)
                
                return assetsResponse.data
            },
            saveFavourite: { user, asset in
                try await db.document(user.id).setData(
                    ["favourites": FieldValue.arrayUnion([asset.id])],
                    merge: true
                )
            },
            
            fetchFavourites: { user in
                let doc = try await db.document(user.id).getDocument()
                let favourites = doc.get("favourites") as? [String]
                return favourites ?? []
            },
            
            fetchAsset: { assetId in
                guard let url = URL(string: "\(baseUrl)/assets/\(assetId)?apiKey=\(apiKey)") else {
                    throw NetworkingError.invalidURL
                }
                let (data, _) = try await urlSession.data(for: URLRequest(url: url))
                let asset = try JSONDecoder().decode(Asset.self, from: data)
                
                return asset
                
            }
            
        )
    }
    
    static var previewValue: AssetsApiClient {
        .init(
            fetchAllAssets: {[
                .init(
                    id: "bitcoin",
                    name: "Bitcoin",
                    symbol: "BTC",
                    priceUsd: "89111121.2828",
                    changePercent24Hr: "8.992929292"
                ),
                .init(
                    id: "ethereum",
                    name: "Ethereum",
                    symbol: "ETH",
                    priceUsd: "1289.282828",
                    changePercent24Hr: "-1.2323232323"
                ),
                .init(
                    id: "solana",
                    name: "Solana",
                    symbol: "SOL",
                    priceUsd: "500.29292929",
                    changePercent24Hr: "9.2828282"
                )
            ]},
            saveFavourite: { _, _ in },
            fetchFavourites: {_ in []},
            fetchAsset: { _ in .init(
                id: "solana",
                name: "Solana",
                symbol: "SOL",
                priceUsd: "500.292929",
                changePercent24Hr: "9.2828282"
            )}
        )
    }
    
    static var testValue: AssetsApiClient {
        .init(
            fetchAllAssets: {
                XCTFail("AssetsApiClient.fetchAllAssets is unimplemented")
                //            reportIssue("AssetsApiClient.fetchAllAssets is unimplemented")
                return []
            },
            saveFavourite: { _, _ in
                XCTFail("AssetsApiClient.saveFavourite is unimplemented")
            },
            fetchFavourites: { _ in
                XCTFail("AssetsApiClient.fetchAsset is unimplemented")
                return[]
            },
            fetchAsset: { _ in
                XCTFail("AssetsApiClient.fetchAsset is unimplemented")
                return .init(
                    id: "solana",
                    name: "Solana",
                    symbol: "SOL",
                    priceUsd: "500.292929",
                    changePercent24Hr: "9.2828282"
                )
            }
        )
    }
}

extension DependencyValues {
    var assetsApiClient: AssetsApiClient {
        get { self[AssetsApiClient.self] }
        set { self[AssetsApiClient.self] = newValue }
    }
}


//
//
//protocol AssetsApiProtocol {
//    func getAssets() async throws -> [Asset]
//}
//
//
//struct AssetsApiService: AssetsApiProtocol {
//    func getAssets() async throws -> [Asset] {
//        let urlSession = URLSession.shared
//        
//        guard let url = URL(string: "https://4ff399d1-53e9-4a28-bc99-b7735bad26bd.mock.pstmn.io/v3/assets") else {
//            throw NetworkingError.invalidURL
//        }
//        
//        let (data, _) = try await urlSession.data(for: URLRequest(url: url))
//        let assetsResponse = try JSONDecoder().decode(AssetsResponse.self, from: data)
//        
//        return assetsResponse.data
//    }
//}
//
//struct AssetsApiServicePreview: AssetsApiProtocol {
//    func getAssets() async throws -> [Asset] {
//        [
//            .init(
//                id: "bitcoin",
//                name: "Bitcoin",
//                symbol: "BTC",
//                priceUsd: "89111121.2828",
//                changePercent24Hr: "8.992929292"
//            ),
//            .init(
//                id: "ethereum",
//                name: "Ethereum",
//                symbol: "ETH",
//                priceUsd: "1289.282828",
//                changePercent24Hr: "-1.2323232323"
//            ),
//            .init(
//                id: "solana",
//                name: "Solana",
//                symbol: "SOL",
//                priceUsd: "500.29292929",
//                changePercent24Hr: "9.2828282"
//            )
//        ]
//    }
//}
