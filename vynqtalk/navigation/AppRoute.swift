import Foundation

enum AppRoute: Hashable {
    case welcome
    case login
    case register
    case main
    case chat(userId: Int, name: String)
}


