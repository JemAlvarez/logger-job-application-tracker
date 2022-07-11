//

import SwiftUI

struct ContactEditView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: ApplicationEditorViewModel
    let contact: JobContactModel

    @State var id = UUID()
    @State var name = ""
    @State var number = ""
    @State var email = ""
    @State var role: JobContactModel.Role = .other

    var body: some View {
        Form {
            Section {
                TextField("Contact name", text: $name)
                    .keyboardType(.namePhonePad)
                    .textContentType(.name)

                HStack {
                    TextField("Phone number", text: $number)
                        .keyboardType(.phonePad)
                        .textContentType(.telephoneNumber)

                    Spacer()

                    Button(action: {
                        // TODO: Call
                    }) {
                        Image(systemName: "phone.fill")
                            .foregroundColor(.green)
                    }
                }

                TextField("Contact email", text: $email)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)

                Picker("Role", selection: $role.animation()) {
                    ForEach(JobContactModel.Role.allCases, id: \.self.rawValue) { role in
                        if role != .none {
                            Text(role.rawValue.capitalized)
                                .tag(role)
                        }
                    }
                }
            }

            Section {
                Button("Save") {
                    let newContact = JobContactModel(
                        CD_ID: contact.CD_ID,
                        email: email,
                        name: name,
                        number: number,
                        role: role
                    )

                    let index = viewModel.contacts.firstIndex { $0.id == id }

                    if let index {
                        viewModel.contacts[index] = newContact
                    } else {
                        viewModel.contacts.append(newContact)
                    }

                    dismiss()
                }
            }

            Section {
                Button("Delete") {
                    viewModel.contactsToRemove.append(contact)

                    dismiss()
                }
                .tint(.red)
            }
        }
        .navigationTitle("Contact ")
        .onAppear {
            populate()
        }
    }

    func populate() {
        name = contact.name
        number = contact.number
        email = contact.email
        role = contact.role
        id = contact.id
    }
}

struct ContactEditView_Previews: PreviewProvider {
    static var previews: some View {
        ContactEditView(contact: .empty)
    }
}
