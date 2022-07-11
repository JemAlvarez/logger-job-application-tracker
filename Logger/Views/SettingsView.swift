//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 99)
                .fill(.gray)
                .opacity(.opacityLow)
                .frame(width: 80, height: 3)

            HStack {
                Spacer()

                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal)

            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

            Form {
                contact()

                donate()
            }

            Text("Made with ❤️ by Jem")
                .font(.footnote)
                .opacity(.opacityMedium)
        }
        .padding(.top)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

extension SettingsView {
    func donate() -> some View {
        Section(content: {
            HStack {
                makeRow(
                    leftImage: "heart.fill",
                    color: .red,
                    text: "Donate and support",
                    rightImage: nil
                ) {
                    // TODO: Process IAP
                }

                Spacer()

                Text("$0.99")
                    .foregroundColor(.blue)
            }
        }) {
            Text("Support")
        } footer: {
            Text("If you choose to donate you'll be supporting me and only me :)")
        }
    }

    func contact() -> some View {
        Section("Contact") {
            makeRow(
                leftImage: "person.crop.square.filled.and.at.rectangle.fill",
                color: .cyan,
                text: "Follow me on twitter",
                rightImage: "arrow.up.right"
            ) {
                // TODO: Open twitter link
            }

            makeRow(
                leftImage: "envelope.fill",
                color: .green,
                text: "Send me an email",
                rightImage: "arrow.up.right"
            ) {
                // TODO: Send email
            }

            makeRow(
                leftImage: "star.fill",
                color: .yellow,
                text: "Review on the App Store",
                rightImage: "arrow.up.right"
            ) {
                // TODO: Review on App Store
            }
        }
    }

    func makeRow(leftImage: String, color: Color, text: String, rightImage: String?, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Group {
                    Image(systemName: leftImage)
                        .foregroundColor(color)
                    Text(text)
                }
                .foregroundColor(.primary)

                Spacer()

                if let rightImage {
                    Image(systemName: rightImage)
                }
            }
        }
    }
}
