import Foundation

public struct Profile {
    let username: String
    let name: String?
    let loginName: String
    let bio: String?
    
    init(from profileResuit: ProfileResult) {
        username = profileResuit.username
        name = "\(profileResuit.firstName ?? "") \(profileResuit.lastName ?? "")"
        loginName = "@\(profileResuit.username)"
        bio = profileResuit.bio ?? "No bio"
    }
}
