import SwiftUI

struct DomainSelectionView: View {
    let onDomainSelected: (QuizDomain) -> Void
    
    private let domains = QuizDomain.allCases
    
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.xl) {
                VStack(spacing: Spacing.lg) {
                    Text("🧠")
                        .font(.system(size: 80))
                    
                    VStack(spacing: Spacing.sm) {
                        Text("Choose Your Challenge")
                            .font(.phoenixTitle2)
                            .foregroundColor(.phoenixTextPrimary)
                        
                        Text("Select a topic to test your knowledge")
                            .font(.phoenixBody)
                            .foregroundColor(.phoenixTextSecondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.top, Spacing.lg)
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: Spacing.lg) {
                    ForEach(domains) { domain in
                        DomainCard(domain: domain) {
                            onDomainSelected(domain)
                        }
                    }
                }
                .padding(.horizontal, Spacing.lg)
                
                Spacer(minLength: 100)
            }
            .padding(.vertical, Spacing.md)
        }
    }
}

#Preview {
    DomainSelectionView { _ in }
} 