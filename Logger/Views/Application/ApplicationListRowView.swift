//

import SwiftUI
import JsHelper

struct ApplicationListRowView: View {
    let application: JobApplicationModel

    var body: some View {
        NavigationLink(destination: ApplicationEditorView(application: application)) {
            HStack {
                Circle()
                    .fill(application.color)
                    .frame(width: 8, height: 8)
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

                        Text(application.dateApplied.getString(with: .comma))
                            .font(.subheadline)
                            .opacity(.opacityMedium)
                    }
                }
                .padding(.trailing)
                .lineLimit(1)
            }
        }
    }
}

struct ApplicationListRowView_Previews: PreviewProvider {
    static var previews: some View {
        ApplicationListRowView(application: .empty)
    }
}
