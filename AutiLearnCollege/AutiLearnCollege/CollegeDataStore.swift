import Foundation

@MainActor
class CollegeDataStore: ObservableObject {
    @Published var students: [CollegeProfile] = []

    private var fileURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("college_students.json")
    }

    init() { load() }

    func addStudent(_ student: CollegeProfile) {
        students.append(student)
        save()
    }

    func updateStudent(_ student: CollegeProfile) {
        if let idx = students.firstIndex(where: { $0.id == student.id }) {
            students[idx] = student
        } else {
            students.append(student)
        }
        save()
    }

    func save() {
        if let data = try? JSONEncoder().encode(students) {
            try? data.write(to: fileURL, options: .atomicWrite)
        }
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([CollegeProfile].self, from: data)
        else { return }
        students = decoded
    }
}
