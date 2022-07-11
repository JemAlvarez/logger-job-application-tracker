//

import Foundation
import CoreData

struct JobContactModel: Identifiable {
    let id = UUID()
    let CD_ID: NSManagedObjectID?
    let email: String
    let name: String
    let number: String
    let role: Role

    static let empty = JobContactModel(
        CD_ID: nil,
        email: "",
        name: "",
        number: "",
        role: .none
    )

    enum Role: String, CaseIterable {
        case interviewer, developer, recruiter, none
        case hiringManager = "Hiring Manager"
        case other

        static func getRole(from string: String) -> Role {
            switch string {
            case "interviewer":
                return interviewer
            case "developer":
                return developer
            case "recruiter":
                return recruiter
            case "other":
                return other
            case "hiringManager":
                return hiringManager
            default:
                return none
            }
        }
    }
}
