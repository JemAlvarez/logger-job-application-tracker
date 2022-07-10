//

import SwiftUI
import CoreData

struct JobApplicationModel: Identifiable {
    let id = UUID()
    let CD_ID: NSManagedObjectID?
    let companyName: String
    let dateApplied: Date
    let dateModified: Date
    let jobLink: String
    let jobTitle: String
    let location: String
    let notes: String
    let recruitingCompany: String?
    let salary: Float
    let status: Status
    let contacts: [JobContactModel]

    var color: Color {
        switch status {
        case .applied:
            return .cyan
        case .rejected:
            return .red
        case .offer:
            return .green
        case .waiting:
            return .yellow
        case .call:
            return .orange
        case .interview:
            return .purple
        case .none:
            return .gray
        }
    }

    static let empty = JobApplicationModel(
        CD_ID: nil,
        companyName: "",
        dateApplied: .now,
        dateModified: .now,
        jobLink: "",
        jobTitle: "",
        location: "",
        notes: "",
        recruitingCompany: nil,
        salary: 0,
        status: .none,
        contacts: []
    )

    enum Status: String, CaseIterable {
        case applied, rejected, offer, waiting, call, interview, none

        static func getStatus(from string: String) -> Status {
            switch string {
            case "applied":
                return applied
            case "rejected":
                return rejected
            case "offer":
                return offer
            case "waiting":
                return waiting
            case "call":
                return call
            case "interviewing":
                return interview
            default:
                return none
            }
        }
    }
}
