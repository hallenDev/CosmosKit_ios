import Foundation

public struct CosmosTimeFormatter {

    public static func timeAgo(for date: Date, shortened: Bool) -> String? {
        let dateDiff = Calendar.current.dateComponents(
            [.second, .minute, .hour, .day, .month],
            from: date, to: Date())
        var plural: String?
        var amount: Int?
        if let months = dateDiff.month, months > 0 {
            plural = months > 1 ? "months" : "month"
            amount = months
        } else if let days = dateDiff.day, days > 0 {
            plural = days > 1 ? "days" : "day"
            amount = days
        } else if let hours = dateDiff.hour, hours > 0 {
            plural = hours > 1 ? (shortened ? "hrs" : "hours") : (shortened ? "hr" : "hour")
            amount = hours
        } else if let minutes = dateDiff.minute, minutes > 0 {
            plural = minutes > 1 ? (shortened ? "mins" : "minutes") : (shortened ? "min" : "minute")
            amount = minutes
        } else if let seconds = dateDiff.second, seconds > 0 {
            plural = seconds > 1 ? (shortened ? "secs" : "seconds") : (shortened ? "sec" : "second")
            amount = seconds
        }
        if let value = amount, let pluralRule = plural {
            return String(format: "%d %@ ago", value, pluralRule)
        }
        return nil
    }
}
