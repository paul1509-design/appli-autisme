import Foundation

// MARK: - Couche de persistance JSON (compatible iOS 16+)
@MainActor
class DataStore: ObservableObject {
    @Published var children: [ChildProfile] = []

    private var fileURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("children.json")
    }

    init() { load() }

    func addChild(_ child: ChildProfile) {
        children.append(child)
        save()
    }

    func updateChild(_ child: ChildProfile) {
        if let idx = children.firstIndex(where: { $0.id == child.id }) {
            children[idx] = child
        } else {
            children.append(child)
        }
        save()
    }

    func save() {
        if let data = try? JSONEncoder().encode(children) {
            try? data.write(to: fileURL, options: .atomicWrite)
        }
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([ChildProfile].self, from: data)
        else { return }
        children = decoded
    }
}
