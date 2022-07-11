//

import SwiftUI
import JsHelper

struct ApplicationEditorView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL
    @StateObject private var viewModel = ApplicationEditorViewModel()
    let application: JobApplicationModel
    let isSheet: Bool

    var body: some View {
        Group {
            if isSheet {
                NavigationView {
                    mainView()
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button("Cancel") {
                                    dismiss()
                                }
                                .tint(.red)
                            }
                        }
                }
            } else {
                mainView()
            }
        }
        .onAppear {
            if viewModel.isFirstTimeOpen {
                viewModel.application = application
                viewModel.populateInfo()
                viewModel.isFirstTimeOpen = false
            }
        }
    }
}

struct ApplicationEditorView_Previews: PreviewProvider {
    static var previews: some View {
        ApplicationEditorView(application: .empty, isSheet: true)
    }
}

// MARK: - extensions
extension ApplicationEditorView {
    func mainView() -> some View {
        Form {
            statusSection()

            jobInfoSection()

            contactsSection()

            notes()

            delete()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    viewModel.save()
                    dismiss()
                }
            }
        }
        .navigationTitle("Job Application")
    }

    func statusSection() -> some View {
        Section("Status") {
            HStack {
                StatusCircleView(color: viewModel.status.color)

                Text("Status of application")

                Spacer()

                Picker("", selection: $viewModel.status.animation()) {
                    ForEach(JobApplicationModel.Status.allCases, id: \.self.rawValue) { status in
                        if status != .none {
                            Text(status.rawValue.capitalized)
                                .tag(status)
                        }
                    }
                }

                Image(systemName: "chevron.up.chevron.down")
                    .foregroundColor(.secondary)
            }

            DatePicker("Date of application", selection: $viewModel.date, displayedComponents: .date)
        }
    }

    func jobInfoSection() -> some View {
        Section("Job information") {
            TextField("Company name", text: $viewModel.companyName)
                .textContentType(.organizationName)

            TextField("Job title", text: $viewModel.jobTitle)

            Toggle("Add interview date?", isOn: $viewModel.hasInterviewDate)

            if viewModel.hasInterviewDate {
                DatePicker("Interview date", selection: $viewModel.interviewDate, displayedComponents: .date)
            }

            TextField("Location", text: $viewModel.location)
                .textContentType(.location)

            HStack {
                TextField("Link to job", text: $viewModel.link)
                    .keyboardType(.URL)
                    .textContentType(.URL)

                Spacer()

                Button(action: {
                    var link = viewModel.link

                    if link.prefix(8) != "https://" {
                        link = "https://" + link
                    }

                    openLink(link, with: openURL)
                }) {
                    Image(systemName: "arrow.up.right")
                }
            }

            TextField("Recruiting firm", text: $viewModel.recruiter)
                .textContentType(.organizationName)

            Stepper("Salary: $ \(viewModel.salary)k") {
                if viewModel.salary + 10 < 1000 {
                    viewModel.salary += 10
                }
            } onDecrement: {
                if viewModel.salary - 10 >= 0 {
                    viewModel.salary -= 10
                }
            }

        }
    }

    func contactsSection() -> some View {
        Section("Contact") {
            ForEach(viewModel.contacts) { contact in
                NavigationLink(destination:
                                ContactEditView(contact: contact)
                    .environmentObject(viewModel)
                ) {
                    HStack {
                        Text(contact.name)

                        Spacer()

                        Text(contact.role.rawValue.capitalized)
                            .foregroundColor(.green)
                            .opacity(.opacityMedium)
                    }
                }
            }

            NavigationLink(destination:
                            ContactEditView(contact: .empty)
                .environmentObject(viewModel)
            ) {
                Label("Add contact", systemImage: "plus")
                    .foregroundColor(.blue)
            }

        }
    }

    func notes() -> some View {
        Section("Notes") {
            NavigationLink("Notes") {
                VStack {
                    TextEditor(text: $viewModel.notes)
                        .padding()
                        .navigationTitle("Notes")
                        .background(Color.secondary.opacity(.opacityLow))
                        .cornerRadius(.cornerRadius)
                        .padding()
                }
            }
        }
    }

    func delete() -> some View {
        Section(footer: Text("Last modified: \(viewModel.application?.dateModified.getString(with: .comma) ?? "-")")) {
            Button(action: {
                withAnimation {
                    viewModel.delete()
                }
            }) {
                Label("Delete", systemImage: "trash.fill")
                    .foregroundColor(.red)
            }
        }
    }

    init(application: JobApplicationModel, isSheet: Bool) {
        UITextView.appearance().backgroundColor = .clear

        self.application = application
        self.isSheet = isSheet
    }
}
