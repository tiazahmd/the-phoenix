 import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = "John Doe"
    @State private var title = "Mindfulness Explorer"
    @State private var bio = "On a journey to discover inner peace and personal growth through mindfulness and reflection."
    @State private var email = "john.doe@example.com"
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    // Profile Image
                    HStack {
                        Spacer()
                        
                        VStack {
                            if let selectedImageData,
                               let uiImage = UIImage(data: selectedImageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person.crop.circle.fill")
                                    .font(.system(size: 100))
                                    .foregroundStyle(.indigo)
                            }
                            
                            PhotosPicker(
                                selection: $selectedItem,
                                matching: .images,
                                photoLibrary: .shared()
                            ) {
                                Text("Change Photo")
                                    .font(.caption)
                                    .foregroundStyle(.indigo)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical)
                }
                
                Section("Basic Information") {
                    TextField("Name", text: $name)
                    TextField("Title", text: $title)
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                }
                
                Section("Bio") {
                    TextEditor(text: $bio)
                        .frame(minHeight: 100)
                }
                
                Section("Preferences") {
                    NavigationLink {
                        NotificationPreferencesView()
                    } label: {
                        HStack {
                            Image(systemName: "bell.fill")
                                .foregroundStyle(.indigo)
                            Text("Notification Preferences")
                        }
                    }
                    
                    NavigationLink {
                        PrivacySettingsView()
                    } label: {
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundStyle(.indigo)
                            Text("Privacy Settings")
                        }
                    }
                }
                
                Section("Account") {
                    Button(role: .destructive) {
                        // Handle delete account
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete Account")
                        }
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveProfile()
                    }
                }
            }
            .onChange(of: selectedItem) { oldValue, newValue in
                Task {
                    if let data = try? await newValue?.loadTransferable(type: Data.self) {
                        selectedImageData = data
                    }
                }
            }
        }
    }
    
    private func saveProfile() {
        // TODO: Implement save functionality
        dismiss()
    }
}

struct NotificationPreferencesView: View {
    @State private var dailyReminders = true
    @State private var weeklyDigest = true
    @State private var achievementAlerts = true
    @State private var communityUpdates = false
    
    var body: some View {
        Form {
            Section {
                Toggle("Daily Reminders", isOn: $dailyReminders)
                Toggle("Weekly Digest", isOn: $weeklyDigest)
                Toggle("Achievement Alerts", isOn: $achievementAlerts)
                Toggle("Community Updates", isOn: $communityUpdates)
            } footer: {
                Text("Control which notifications you receive from Phoenix.")
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PrivacySettingsView: View {
    @State private var profileVisibility = 0
    @State private var showActivityStatus = true
    @State private var shareProgress = true
    @State private var allowMentions = true
    
    var body: some View {
        Form {
            Section {
                Picker("Profile Visibility", selection: $profileVisibility) {
                    Text("Public").tag(0)
                    Text("Friends Only").tag(1)
                    Text("Private").tag(2)
                }
            }
            
            Section {
                Toggle("Show Activity Status", isOn: $showActivityStatus)
                Toggle("Share Progress", isOn: $shareProgress)
                Toggle("Allow Mentions", isOn: $allowMentions)
            } footer: {
                Text("Control who can see your activity and interact with you.")
            }
        }
        .navigationTitle("Privacy")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    EditProfileView()
}