import Foundation

struct TimestampFormatter {
    static var shared: Self = .init()

    func string(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm ss.SSS"
        return dateFormatter.string(from: date)
    }
}
