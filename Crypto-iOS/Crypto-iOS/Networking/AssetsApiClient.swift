import Dependencies
import Foundation

struct AssetsApiClient{
    var fetchAllAssets: () async throws -> [Asset]
}

enum NetworkingError: Error{
    case invalidURL
        
        var localizedDescription: String {
            switch self {
            case .invalidURL:
                return "Invalid URL"
            }
        }
}

extension AssetsApiClient: DependencyKey{
    static var liveValue: AssetsApiClient{
        .init(
            fetchAllAssets: {
                let urlSession = URLSession.shared
                
                guard let url = URL(string: "https://rest.coincap.io/v3/assets?apiKey=b658780c36366042da97d87e23bd6bf41ad905cf4305dad1f9ce68c27501ea4d") else {
                    throw NetworkingError.invalidURL
                }
                
                let (data, _) = try await urlSession.data(for: URLRequest(url: url))
                let assetsResponse = try JSONDecoder().decode(AssetsResponse.self, from: data)
                
                return assetsResponse.data
                
            }
        )
    }
    
    static var previewValue: AssetsApiClient{
        .init(
            fetchAllAssets: {
                [
                .init(
                    id: "bitcoin",
                    name: "Bitcoin",
                    symbol: "BTC",
                    priceUsd: "98789789.123132",
                    changePercent24Hr: "8.54656465"
                ),
                .init(
                    id: "ethereum",
                    name: "Ethereum",
                    symbol: "ETH",
                    priceUsd: "97889.123132",
                    changePercent24Hr: "-8.54656465"
                ),
                .init(
                    id: "solana",
                    name: "Solana",
                    symbol: "SOL",
                    priceUsd: "987879.1232",
                    changePercent24Hr: "8.54656465"
                )
            ]
        })
    }
    
    static var testValue: AssetsApiClient{
        .init(fetchAllAssets: {
            XCTFail("AssetsApiClient.fetchAllAssets is unimplemented")
            //reportIssue("AssetsApiClient.fetchAllAssets is unimplemented")
            return []
        })
    }
}

extension DependencyValues{
    var assetsApiClient: AssetsApiClient{
        get { self[AssetsApiClient.self] }
        set { self[AssetsApiClient.self] = newValue }
    }
}
