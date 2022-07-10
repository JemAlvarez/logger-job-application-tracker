//

import SwiftUI
import CoreData

class ApplicationEditorViewModel: ObservableObject {
    let coreDataManager = CoreDataManager.shared
    var application: JobApplicationModel?

    @Published var companyName = ""

    func populateInfo() {
        if let application {
            companyName = application.companyName
        }
    }

    func save() {
        let newApplication = JobApplicationModel(
            CD_ID: application?.CD_ID,
            companyName: companyName,
            dateApplied: .now,
            dateModified: .now,
            jobLink: "",
            jobTitle: "",
            location: "",
            notes: "",
            recruitingCompany: nil,
            salary: 0,
            status: .applied,
            contacts: []
        )

        if newApplication.CD_ID != nil {
            coreDataManager.updateApplication(with: newApplication)
        } else {
            coreDataManager.createJobApplication(with: newApplication)
        }

        coreDataManager.save()
    }

    func delete() {
        if let id = application?.CD_ID {
            coreDataManager.deleteAndSave(with: id)
        }
    }
}
