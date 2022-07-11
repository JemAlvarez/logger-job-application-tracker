//

import SwiftUI
import CoreData

class ApplicationEditorViewModel: ObservableObject {
    let coreDataManager = CoreDataManager.shared
    var application: JobApplicationModel?

    var isFirstTimeOpen = true

    @Published var contactsToRemove: [JobContactModel] = [] {
        didSet {
            for contact in contactsToRemove {
                contacts.removeAll { $0.id == contact.id }
            }
        }
    }
    @Published var status: JobApplicationModel.Status = .applied
    @Published var date: Date = .now

    @Published var companyName = ""
    @Published var hasInterviewDate = false
    @Published var interviewDate: Date = .now
    @Published var jobTitle = ""
    @Published var location = ""
    @Published var salary: Int = 0
    @Published var link = ""
    @Published var recruiter = ""

    @Published var contacts: [JobContactModel] = []

    @Published var notes = ""

    func populateInfo() {
        if let application {
            status = application.status
            date = application.dateApplied
            companyName = application.companyName
            hasInterviewDate = application.interviewDate == nil ? false : true
            if let date = application.interviewDate {
                interviewDate = date
            }
            jobTitle = application.jobTitle
            location = application.location
            salary = application.salary
            link = application.jobLink
            recruiter = application.recruitingCompany
            notes = application.notes
            contacts = application.contacts
        }
    }

    func save() {
        let newApplication = JobApplicationModel(
            CD_ID: application?.CD_ID,
            companyName: companyName,
            dateApplied: date,
            dateModified: .now,
            interviewDate: hasInterviewDate ? interviewDate : nil,
            jobLink: link,
            jobTitle: jobTitle,
            location: location,
            notes: notes,
            recruitingCompany: recruiter,
            salary: salary,
            status: status,
            contacts: contacts
        )

        if newApplication.CD_ID != nil {
            coreDataManager.updateApplication(with: newApplication)
        } else {
            coreDataManager.createJobApplication(with: newApplication)
        }

        for contact in contactsToRemove {
            if let id = contact.CD_ID {
                coreDataManager.delete(with: id)
            }
        }

        coreDataManager.save()
    }

    func delete() {
        if let id = application?.CD_ID {
            coreDataManager.delete(with: id)
            coreDataManager.save()
        }
    }
}

