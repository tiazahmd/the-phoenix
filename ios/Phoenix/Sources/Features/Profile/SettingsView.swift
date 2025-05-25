import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("useSystemTheme") private var useSystemTheme = true
    @State private var showingLogoutAlert = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Appearance") {
                    Toggle("Use System Theme", isOn: $useSystemTheme)
                    
                    if !useSystemTheme {
                        Toggle("Dark Mode", isOn: $isDarkMode)
                    }
                }
                
                Section("App") {
                    NavigationLink {
                        NotificationSettingsView()
                    } label: {
                        SettingsRow(
                            icon: "bell.fill",
                            title: "Notifications",
                            color: .indigo
                        )
                    }
                    
                    NavigationLink {
                        PrivacySettingsView()
                    } label: {
                        SettingsRow(
                            icon: "lock.fill",
                            title: "Privacy",
                            color: .indigo
                        )
                    }
                    
                    NavigationLink {
                        DataSettingsView()
                    } label: {
                        SettingsRow(
                            icon: "externaldrive.fill",
                            title: "Data & Storage",
                            color: .indigo
                        )
                    }
                }
                
                Section("Support") {
                    NavigationLink {
                        HelpCenterView()
                    } label: {
                        SettingsRow(
                            icon: "questionmark.circle.fill",
                            title: "Help Center",
                            color: .indigo
                        )
                    }
                    
                    Button {
                        // Open feedback form
                    } label: {
                        SettingsRow(
                            icon: "envelope.fill",
                            title: "Send Feedback",
                            color: .indigo
                        )
                    }
                }
                
                Section("About") {
                    NavigationLink {
                        AboutView()
                    } label: {
                        SettingsRow(
                            icon: "info.circle.fill",
                            title: "About Phoenix",
                            color: .indigo
                        )
                    }
                    
                    Link(destination: URL(string: "https://phoenix.com/terms")!) {
                        SettingsRow(
                            icon: "doc.text.fill",
                            title: "Terms of Service",
                            color: .indigo
                        )
                    }
                    
                    Link(destination: URL(string: "https://phoenix.com/privacy")!) {
                        SettingsRow(
                            icon: "hand.raised.fill",
                            title: "Privacy Policy",
                            color: .indigo
                        )
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        showingLogoutAlert = true
                    } label: {
                        HStack {
                            Spacer()
                            Text("Log Out")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .alert("Log Out", isPresented: $showingLogoutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Log Out", role: .destructive) {
                    // Handle logout
                }
            } message: {
                Text("Are you sure you want to log out?")
            }
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(color)
                .frame(width: 24)
            
            Text(title)
        }
    }
}

struct NotificationSettingsView: View {
    @State private var pushEnabled = true
    @State private var soundEnabled = true
    @State private var badgesEnabled = true
    @State private var reminderTime = Date()
    
    var body: some View {
        Form {
            Section {
                Toggle("Push Notifications", isOn: $pushEnabled)
                Toggle("Sounds", isOn: $soundEnabled)
                Toggle("Badges", isOn: $badgesEnabled)
            }
            
            Section {
                DatePicker(
                    "Daily Reminder",
                    selection: $reminderTime,
                    displayedComponents: .hourAndMinute
                )
            }
            
            Section("Categories") {
                Toggle("Exercises", isOn: .constant(true))
                Toggle("Journal Reminders", isOn: .constant(true))
                Toggle("Progress Updates", isOn: .constant(true))
                Toggle("Community", isOn: .constant(false))
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DataSettingsView: View {
    @State private var offlineMode = false
    @State private var syncOnWifiOnly = true
    @State private var downloadQuality = 1
    @State private var showingClearDataAlert = false
    
    var body: some View {
        Form {
            Section {
                Toggle("Offline Mode", isOn: $offlineMode)
                Toggle("Sync on Wi-Fi Only", isOn: $syncOnWifiOnly)
            }
            
            Section {
                Picker("Download Quality", selection: $downloadQuality) {
                    Text("Low").tag(0)
                    Text("Medium").tag(1)
                    Text("High").tag(2)
                }
            }
            
            Section {
                Button(role: .destructive) {
                    showingClearDataAlert = true
                } label: {
                    Text("Clear App Data")
                }
            }
        }
        .navigationTitle("Data & Storage")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Clear App Data", isPresented: $showingClearDataAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Clear", role: .destructive) {
                // Handle clear data
            }
        } message: {
            Text("This will clear all cached data. Your account data will not be affected.")
        }
    }
}

struct HelpCenterView: View {
    let faqs = [
        "How do I start a meditation?",
        "How to track progress?",
        "Can I download exercises?",
        "How to set reminders?",
        "What are achievement points?"
    ]
    
    var body: some View {
        List {
            Section("Frequently Asked Questions") {
                ForEach(faqs, id: \.self) { question in
                    NavigationLink {
                        Text("Answer to: \(question)")
                            .padding()
                    } label: {
                        Text(question)
                    }
                }
            }
            
            Section {
                Button {
                    // Contact support
                } label: {
                    Text("Contact Support")
                }
                
                Link(destination: URL(string: "https://phoenix.com/support")!) {
                    Text("Visit Help Center")
                }
            }
        }
        .navigationTitle("Help Center")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AboutView: View {
    var body: some View {
        List {
            Section {
                VStack(spacing: 16) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 60))
                        .foregroundStyle(.indigo)
                    
                    Text("Phoenix")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Version 1.0.0 (42)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
            
            Section("About") {
                Text("Phoenix is your personal mindfulness and growth companion, designed to help you develop healthy habits and achieve inner peace through guided exercises and reflective practices.")
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
            
            Section {
                Link(destination: URL(string: "https://phoenix.com")!) {
                    Text("Visit Website")
                }
                
                Link(destination: URL(string: "https://twitter.com/phoenix")!) {
                    Text("Follow us on Twitter")
                }
                
                Link(destination: URL(string: "https://instagram.com/phoenix")!) {
                    Text("Follow us on Instagram")
                }
            }
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SettingsView()
} 