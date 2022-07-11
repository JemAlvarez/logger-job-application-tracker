//

import Foundation
import CoreData

class CoreDataManager: ObservableObject {
    static let shared = CoreDataManager()

    let container = NSPersistentContainer(name: "Logger")

    init() {
        container.loadPersistentStores { des, err in
            if let err {
                print("Core Data failed to load")
                print(err.localizedDescription)
            }
        }
    }

    func parseJobApplication(with jobApplication: JobApplication) -> JobApplicationModel {
        var contacts: [JobContactModel] = []
        if let jobContacts = jobApplication.contacts {
            for contact in jobContacts {
                contacts.append(parseJobContact(with: contact as! JobContact))
            }
        }

        let jobApplicationModel = JobApplicationModel(
            CD_ID: jobApplication.objectID,
            companyName: jobApplication.companyName ?? "",
            dateApplied: jobApplication.dateApplied ?? .now,
            dateModified: jobApplication.dateModified ?? .now,
            jobLink: jobApplication.jobLink ?? "",
            jobTitle: jobApplication.jobTitle ?? "",
            location: jobApplication.location ?? "",
            notes: jobApplication.notes ?? "",
            recruitingCompany: jobApplication.recruitingCompany ?? "",
            salary: Int(jobApplication.salary),
            status: JobApplicationModel.Status.getStatus(from: jobApplication.status ?? ""),
            contacts: contacts
        )
        return jobApplicationModel
    }

    func parseJobContact(with jobContact: JobContact) -> JobContactModel {
        let jobContactModel = JobContactModel(
            CD_ID: jobContact.objectID,
            email: jobContact.email ?? "",
            name: jobContact.name ?? "",
            number: jobContact.number ?? "",
            role: JobContactModel.Role.getRole(from: jobContact.role ?? "")
        )
        return jobContactModel
    }

    func createJobApplication(with applicationModel: JobApplicationModel) {
        let jobApplication = JobApplication(context: container.viewContext)
        jobApplication.companyName = applicationModel.companyName
        jobApplication.dateApplied = applicationModel.dateApplied
        jobApplication.dateModified = applicationModel.dateModified
        jobApplication.jobLink = applicationModel.jobLink
        jobApplication.jobTitle = applicationModel.jobTitle
        jobApplication.location = applicationModel.location
        jobApplication.notes = applicationModel.notes
        jobApplication.recruitingCompany = applicationModel.recruitingCompany
        jobApplication.salary = Int16(applicationModel.salary)
        jobApplication.status = applicationModel.status.rawValue

        for contact in applicationModel.contacts {
            if let contacts = jobApplication.contacts {
                contacts.adding(createJobContact(with: contact, and: jobApplication))
            } else {
                jobApplication.contacts = NSSet(object: createJobContact(with: contact, and: jobApplication))
            }
        }
    }

    func createJobContact(with contactModel: JobContactModel, and application: JobApplication) -> JobContact {
        let jobContact = JobContact(context: container.viewContext)
        jobContact.email = contactModel.email
        jobContact.number = contactModel.number
        jobContact.name = contactModel.name
        jobContact.role = contactModel.role.rawValue
        jobContact.jobApplication = application
        return jobContact
    }

    func updateJobContact(with contactModel: JobContactModel) -> JobContact? {
        if let id = contactModel.CD_ID, let contact = try? container.viewContext.existingObject(with: id) as? JobContact {
            contact.email = contactModel.email
            contact.number = contactModel.number
            contact.name = contactModel.name
            contact.role = contactModel.role.rawValue
            return contact
        }

        return nil
    }

    func updateApplication(with applicationModel: JobApplicationModel) {
        if let id = applicationModel.CD_ID, let application = try? container.viewContext.existingObject(with: id) as? JobApplication {
            application.companyName = applicationModel.companyName
            application.dateApplied = applicationModel.dateApplied
            application.dateModified = applicationModel.dateModified
            application.jobLink = applicationModel.jobLink
            application.jobTitle = applicationModel.jobTitle
            application.location = applicationModel.location
            application.notes = applicationModel.notes
            application.recruitingCompany = applicationModel.recruitingCompany
            application.salary = Int16(applicationModel.salary)
            application.status = applicationModel.status.rawValue

            for contact in applicationModel.contacts {
                if let contacts = application.contacts {
                    let exists = application.contacts?.contains(where: { jobContact in
                        if let jobContact = jobContact as? JobContact {
                            return contact.CD_ID == jobContact.objectID
                        }
                        return false
                    })

                    if let exists {
                        if exists {
                            let _ = updateJobContact(with: contact)
                        } else {
                            contacts.adding(createJobContact(with: contact, and: application))
                        }
                    }
                } else {
                    application.contacts = NSSet(object: createJobContact(with: contact, and: application))
                }
            }
        }
    }

    func save() {
        try? container.viewContext.save()
    }

    func delete(with objectId: NSManagedObjectID) {
        if let object = try? container.viewContext.existingObject(with: objectId) {
            container.viewContext.delete(object)
        } else {
            print("Unable to find object with given ID")
        }
    }
}
