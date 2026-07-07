import SwiftUI
import PDFKit

// MARK: - Génération PDF rapport de progression
struct CollegePDFReport {

    static func generate(for student: CollegeProfile) -> Data {
        let pageRect = CGRect(x: 0, y: 0, width: 595, height: 842) // A4
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)

        return renderer.pdfData { ctx in
            ctx.beginPage()
            drawPage(ctx: ctx.cgContext, pageRect: pageRect, student: student)
        }
    }

    private static func drawPage(ctx: CGContext, pageRect: CGRect, student: CollegeProfile) {
        let margin: CGFloat = 48
        var y: CGFloat = margin

        // En-tête violet
        ctx.setFillColor(UIColor(red: 0.42, green: 0.27, blue: 0.82, alpha: 1).cgColor)
        ctx.fill(CGRect(x: 0, y: 0, width: pageRect.width, height: 100))

        // Titre
        let titleAttr: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 22, weight: .semibold),
            .foregroundColor: UIColor.white
        ]
        "ABA Homeschooling Ado — Rapport de progression".draw(at: CGPoint(x: margin, y: 22), withAttributes: titleAttr)

        let subAttr: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 13),
            .foregroundColor: UIColor.white.withAlphaComponent(0.85)
        ]
        let dateStr = DateFormatter.localizedString(from: Date(), dateStyle: .long, timeStyle: .none)
        "Élève : \(student.firstName)  •  Niveau : \(student.level.rawValue)  •  \(dateStr)".draw(
            at: CGPoint(x: margin, y: 52), withAttributes: subAttr)

        y = 120

        // Résumé global
        y = drawSection(ctx: ctx, title: "Résumé global", y: y, margin: margin, pageWidth: pageRect.width)

        let totalSessions = student.sessions.count
        let totalMinutes = student.sessions.reduce(0) { $0 + $1.durationSeconds } / 60
        let avgSuccess = student.sessions.isEmpty ? 0 :
            student.sessions.reduce(0.0) { $0 + $1.successRate } / Double(student.sessions.count)
        let mastered = student.exerciseProgresses.filter { $0.masteryLevel == "mastered" }.count
        let inProgress = student.exerciseProgresses.filter { $0.masteryLevel != "new" && $0.masteryLevel != "mastered" }.count

        let summaryLines = [
            ("Sessions totales", "\(totalSessions)"),
            ("Temps total d'apprentissage", "\(totalMinutes) min"),
            ("Taux de réussite moyen", "\(Int(avgSuccess * 100)) %"),
            ("Étoiles gagnées", "\(student.totalStars) ⭐️"),
            ("Série actuelle", "\(student.currentStreak) jours 🔥"),
            ("Exercices maîtrisés", "\(mastered) ⭐️"),
            ("Exercices en cours", "\(inProgress) 📚"),
        ]
        for (label, value) in summaryLines {
            y = drawRow(ctx: ctx, label: label, value: value, y: y, margin: margin, pageWidth: pageRect.width)
        }

        y += 16

        // Progression par matière
        y = drawSection(ctx: ctx, title: "Progression par matière", y: y, margin: margin, pageWidth: pageRect.width)

        for subject in CollegeSubject.allCases {
            let subSessions = student.sessions.filter { $0.subject == subject.rawValue }
            guard !subSessions.isEmpty else { continue }
            let correct = subSessions.reduce(0) { $0 + $1.correctAnswers }
            let total   = subSessions.reduce(0) { $0 + $1.totalAnswers }
            let rate    = total > 0 ? Int(Double(correct) / Double(total) * 100) : 0
            let masteredCount = student.exerciseProgresses.filter {
                $0.subject == subject.rawValue && $0.masteryLevel == "mastered"
            }.count
            let label = "\(subject.emoji) \(subject.rawValue)"
            let value = "\(subSessions.count) sessions • \(rate)% réussite • \(masteredCount) maîtrisés"
            y = drawRow(ctx: ctx, label: label, value: value, y: y, margin: margin, pageWidth: pageRect.width)
        }

        y += 16

        // Dernières sessions (max 10)
        y = drawSection(ctx: ctx, title: "Dernières sessions", y: y, margin: margin, pageWidth: pageRect.width)

        let recentSessions = student.sessions.sorted { $0.date > $1.date }.prefix(10)
        for session in recentSessions {
            let dateStr = DateFormatter.localizedString(from: session.date, dateStyle: .short, timeStyle: .short)
            let rate = session.totalAnswers > 0 ? Int(session.successRate * 100) : 0
            let label = "\(session.subject) — \(dateStr)"
            let value = "\(session.correctAnswers)/\(session.totalAnswers) (\(rate)%) • \(session.durationSeconds/60) min"
            y = drawRow(ctx: ctx, label: label, value: value, y: y, margin: margin, pageWidth: pageRect.width)
            if y > 780 { break }
        }

        // Pied de page
        let footerAttr: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 10),
            .foregroundColor: UIColor.gray
        ]
        "Rapport généré par ABA Homeschooling Ado — Méthode ABA adaptée TSA".draw(
            at: CGPoint(x: margin, y: 810), withAttributes: footerAttr)
    }

    @discardableResult
    private static func drawSection(ctx: CGContext, title: String, y: CGFloat,
                                    margin: CGFloat, pageWidth: CGFloat) -> CGFloat {
        ctx.setFillColor(UIColor(red: 0.95, green: 0.93, blue: 1.0, alpha: 1).cgColor)
        ctx.fill(CGRect(x: margin - 8, y: y, width: pageWidth - margin * 2 + 16, height: 26))
        let attr: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 13, weight: .semibold),
            .foregroundColor: UIColor(red: 0.42, green: 0.27, blue: 0.82, alpha: 1)
        ]
        title.draw(at: CGPoint(x: margin, y: y + 6), withAttributes: attr)
        return y + 36
    }

    @discardableResult
    private static func drawRow(ctx: CGContext, label: String, value: String, y: CGFloat,
                                margin: CGFloat, pageWidth: CGFloat) -> CGFloat {
        let labelAttr: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.darkGray
        ]
        let valueAttr: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12, weight: .medium),
            .foregroundColor: UIColor.black
        ]
        label.draw(at: CGPoint(x: margin, y: y), withAttributes: labelAttr)
        let valueX = pageWidth - margin - CGFloat(value.count) * 6.5
        value.draw(at: CGPoint(x: max(valueX, margin + 200), y: y), withAttributes: valueAttr)

        ctx.setStrokeColor(UIColor.lightGray.withAlphaComponent(0.4).cgColor)
        ctx.setLineWidth(0.4)
        ctx.move(to: CGPoint(x: margin, y: y + 18))
        ctx.addLine(to: CGPoint(x: pageWidth - margin, y: y + 18))
        ctx.strokePath()
        return y + 24
    }
}

// MARK: - Bouton partage PDF (utilisé dans le dashboard)
struct CollegePDFShareButton: View {
    let student: CollegeProfile

    private var pdfURL: URL {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("rapport_\(student.firstName).pdf")
        let data = CollegePDFReport.generate(for: student)
        try? data.write(to: url)
        return url
    }

    var body: some View {
        ShareLink(item: pdfURL) {
            HStack(spacing: 10) {
                Image(systemName: "doc.richtext")
                    .font(.system(size: 16))
                Text("Exporter rapport PDF")
                    .font(.system(size: 15, weight: .medium))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(Color("accentPurple"))
            .cornerRadius(14)
        }
    }
}
