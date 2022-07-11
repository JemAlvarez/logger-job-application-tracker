//

import SwiftUI
import JsHelper

struct ApplicationListRowView: View {
    let application: JobApplicationModel

    var body: some View {
        NavigationLink(destination: ApplicationEditorView(application: application, isSheet: false)) {
            HStack {
                StatusCircleView(color: application.status.color)
                    .padding(.leading, -10)

                VStack(alignment: .leading, spacing: 8) {
                    Text(application.companyName)
                        .font(.headline)

                    HStack {
                        Group {
                            if application.contacts.count == 0 {
                                Text("No contacts")
                                    .opacity(.opacityLow)
                            } else {
                                Text(application.contacts[0].name)

                                if application.contacts.count > 1 {
                                    Text("+\(application.contacts.count - 1)")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .opacity(.opacityMedium)
                        .font(.subheadline)

                        Spacer()
                    }
                }
                .padding(.trailing)

                Spacer()

                VStack(alignment: .trailing, spacing: 8) {
                    if let date = application.interviewDate {
                        Text("Interview: \(date.getString(with: .comma))")
                            .foregroundColor(JobApplicationModel.Status.interview.color)
                    }

                    Text("Applied: \(application.dateApplied.getString(with: .comma))")
                        .foregroundColor(JobApplicationModel.Status.applied.color)
                }
                .opacity(.opacityMedium)
                .font(.subheadline)
            }
            .lineLimit(1)
        }
    }
}

struct ApplicationListRowView_Previews: PreviewProvider {
    static var previews: some View {
        ApplicationListRowView(application: .empty)
    }
}
