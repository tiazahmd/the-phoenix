import SwiftUI

struct CheckInView: View {
    @State private var moodLevel: Double = 5
    @State private var urgeLevel: Double = 0
    @State private var triggerContext = ""
    @State private var note = ""
    @State private var showingSuccessMessage = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("How are you feeling?")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Take a moment to check in with yourself")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top)
                    
                    // Mood Slider
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Mood Level")
                            .font(.headline)
                        
                        VStack(spacing: 8) {
                            HStack {
                                Text("😔")
                                    .font(.title2)
                                Spacer()
                                Text("😐")
                                    .font(.title2)
                                Spacer()
                                Text("😊")
                                    .font(.title2)
                            }
                            
                            Slider(value: $moodLevel, in: 1...10, step: 1)
                                .tint(.blue)
                            
                            Text("Level: \(Int(moodLevel))/10")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 2)
                    
                    // Urge Level Slider
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Urge Intensity")
                            .font(.headline)
                        
                        VStack(spacing: 8) {
                            HStack {
                                Text("🟢")
                                    .font(.title2)
                                Spacer()
                                Text("🟡")
                                    .font(.title2)
                                Spacer()
                                Text("🔴")
                                    .font(.title2)
                            }
                            
                            Slider(value: $urgeLevel, in: 0...10, step: 1)
                                .tint(.orange)
                            
                            Text("Intensity: \(Int(urgeLevel))/10")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 2)
                    
                    // Trigger Context
                    VStack(alignment: .leading, spacing: 12) {
                        Text("What triggered this feeling?")
                            .font(.headline)
                        
                        TextField("e.g., work stress, social situation, boredom...", text: $triggerContext)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 2)
                    
                    // Additional Notes
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Additional Notes (Optional)")
                            .font(.headline)
                        
                        TextEditor(text: $note)
                            .frame(minHeight: 80)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 2)
                    
                    // Submit Button
                    Button {
                        submitCheckIn()
                    } label: {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Submit Check-In")
                        }
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.indigo)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(triggerContext.isEmpty)
                    
                    // Quick Actions
                    if urgeLevel > 5 {
                        VStack(spacing: 12) {
                            Text("Need immediate help?")
                                .font(.headline)
                                .foregroundStyle(.orange)
                            
                            HStack(spacing: 12) {
                                NavigationLink(destination: UrgeBusterView()) {
                                    QuickActionButton(
                                        title: "Urge Buster",
                                        icon: "shield.fill",
                                        color: .red
                                    )
                                }
                                
                                NavigationLink(destination: AudioExerciseView()) {
                                    QuickActionButton(
                                        title: "Audio Exercise",
                                        icon: "headphones",
                                        color: .blue
                                    )
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 2)
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Check-In")
            .alert("Check-In Submitted", isPresented: $showingSuccessMessage) {
                Button("Continue") {
                    resetForm()
                }
            } message: {
                Text("Your check-in has been recorded. Keep up the great work!")
            }
        }
    }
    
    private func submitCheckIn() {
        // TODO: Implement API call to POST /checkins
        showingSuccessMessage = true
    }
    
    private func resetForm() {
        moodLevel = 5
        urgeLevel = 0
        triggerContext = ""
        note = ""
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    CheckInView()
} 