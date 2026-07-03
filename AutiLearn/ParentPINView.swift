import SwiftUI

// MARK: - Portail d'accès parents (PIN 4 chiffres)
struct ParentPINView: View {
    let child: ChildProfile
    @AppStorage("parentPIN") private var storedPIN: String = ""
    @State private var enteredPIN: String = ""
    @State private var confirmPIN: String = ""
    @State private var isSettingPIN: Bool = false
    @State private var isAuthenticated: Bool = false
    @State private var wrongAttempt: Bool = false
    @State private var phase: Phase = .checking

    enum Phase { case checking, setting, confirming, entering, authenticated }

    var body: some View {
        Group {
            if phase == .authenticated {
                ParentDashboardView(child: child)
            } else {
                pinGateBody
            }
        }
        .onAppear {
            phase = storedPIN.isEmpty ? .setting : .entering
        }
    }

    private var pinGateBody: some View {
        ZStack {
            Color("backgroundSoft").ignoresSafeArea()
            VStack(spacing: 32) {
                Spacer()

                VStack(spacing: 12) {
                    Text("🔒")
                        .font(.system(size: 52))
                    Text(phase == .setting || phase == .confirming
                         ? "Créer un code parents"
                         : "Espace Parents")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(Color("textPrimary"))
                    Text(phase == .setting
                         ? "Choisissez un code à 4 chiffres\npour protéger cet espace."
                         : phase == .confirming
                             ? "Confirmez votre code à 4 chiffres."
                             : "Entrez votre code à 4 chiffres.")
                        .font(.system(size: 15))
                        .foregroundColor(Color("textSecondary"))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }

                // Affichage des pastilles
                let currentPIN = (phase == .confirming) ? confirmPIN : enteredPIN
                HStack(spacing: 18) {
                    ForEach(0..<4, id: \.self) { i in
                        Circle()
                            .fill(i < currentPIN.count
                                  ? Color("accentPurple")
                                  : Color("borderLight"))
                            .frame(width: 18, height: 18)
                            .scaleEffect(wrongAttempt ? 1.3 : 1.0)
                            .animation(.spring(response: 0.2), value: wrongAttempt)
                    }
                }

                if wrongAttempt {
                    Text("Code incorrect, réessayez.")
                        .font(.system(size: 14))
                        .foregroundColor(.red)
                        .transition(.opacity)
                }

                // Clavier numérique
                VStack(spacing: 12) {
                    ForEach([[1,2,3],[4,5,6],[7,8,9]], id: \.self) { row in
                        HStack(spacing: 20) {
                            ForEach(row, id: \.self) { digit in
                                PINKey(label: "\(digit)") { append(digit: "\(digit)") }
                            }
                        }
                    }
                    HStack(spacing: 20) {
                        PINKey(label: "⌫", isAction: true) { deleteLast() }
                        PINKey(label: "0") { append(digit: "0") }
                        PINKey(label: "✓", isAction: true, disabled: currentPIN.count < 4) { confirm() }
                    }
                }

                Spacer()

                if phase == .entering {
                    Button("Code oublié ? Réinitialiser") {
                        storedPIN = ""
                        enteredPIN = ""
                        confirmPIN = ""
                        phase = .setting
                    }
                    .font(.system(size: 13))
                    .foregroundColor(Color("textSecondary"))
                    .padding(.bottom, 24)
                }
            }
            .padding(.horizontal, 40)
        }
        .navigationBarHidden(true)
    }

    private func append(digit: String) {
        let pin = phase == .confirming ? confirmPIN : enteredPIN
        guard pin.count < 4 else { return }
        if phase == .confirming { confirmPIN += digit } else { enteredPIN += digit }
        if (phase == .confirming ? confirmPIN : enteredPIN).count == 4 { confirm() }
    }

    private func deleteLast() {
        if phase == .confirming {
            if !confirmPIN.isEmpty { confirmPIN.removeLast() }
        } else {
            if !enteredPIN.isEmpty { enteredPIN.removeLast() }
        }
    }

    private func confirm() {
        let pin = phase == .confirming ? confirmPIN : enteredPIN
        guard pin.count == 4 else { return }

        switch phase {
        case .setting:
            phase = .confirming
        case .confirming:
            if confirmPIN == enteredPIN {
                storedPIN = confirmPIN
                withAnimation { phase = .authenticated }
            } else {
                wrongAttempt = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation { wrongAttempt = false; confirmPIN = "" }
                }
            }
        case .entering:
            if enteredPIN == storedPIN {
                withAnimation { phase = .authenticated }
            } else {
                wrongAttempt = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation { wrongAttempt = false; enteredPIN = "" }
                }
            }
        default: break
        }
    }
}

struct PINKey: View {
    let label: String
    var isAction: Bool = false
    var disabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: isAction ? 20 : 24, weight: .medium))
                .foregroundColor(disabled ? Color("textSecondary").opacity(0.4) : Color("textPrimary"))
                .frame(width: 72, height: 72)
                .background(
                    Circle()
                        .fill(Color("cardBackground"))
                        .overlay(Circle().stroke(Color("borderLight"), lineWidth: 0.5))
                )
        }
        .disabled(disabled)
    }
}
