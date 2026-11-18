import Foundation

struct HealthMilestone: Identifiable, Equatable {
    let id: UUID = UUID()
    let title: String
    let description: String
    let duration: TimeInterval

    var isCompleted: Bool = false
    var progress: Double = 0.0
}

extension HealthMilestone {
    static let all: [HealthMilestone] = [
        HealthMilestone(title: "20 Minutes", description: "Your heart rate and blood pressure drop.", duration: 20 * 60),
        HealthMilestone(title: "12 Hours", description: "The carbon monoxide level in your blood drops to normal.", duration: 12 * 3600),
        HealthMilestone(title: "24 Hours", description: "The nicotine level in your blood drops to zero.", duration: 24 * 3600),
        HealthMilestone(title: "48 Hours", description: "Your senses of taste and smell start to improve.", duration: 48 * 3600),
        HealthMilestone(title: "72 Hours", description: "Breathing starts to feel easier and you have more energy.", duration: 72 * 3600),
        HealthMilestone(title: "2 Weeks", description: "Your circulation starts to improve.", duration: 14 * 24 * 3600),
        HealthMilestone(title: "6 Weeks", description: "You may start to feel less anxious and stressed.", duration: 42 * 24 * 3600),
        HealthMilestone(title: "3 Months", description: "Your circulation and lung function have improved. Physical activity feels easier.", duration: 90 * 24 * 3600),
        HealthMilestone(title: "9 Months", description: "Coughing and shortness of breath have decreased.", duration: 270 * 24 * 3600),
        HealthMilestone(title: "1 Year", description: "Your risk of coronary heart disease is about half that of a smoker.", duration: 365 * 24 * 3600),
        HealthMilestone(title: "5 Years", description: "Within 5 to 15 years, your stroke risk falls to that of a non-smoker.", duration: 5 * 365 * 24 * 3600),
        HealthMilestone(title: "10 Years", description: "Your risk of lung cancer is about half that of a smoker.", duration: 10 * 365 * 24 * 3600),
        HealthMilestone(title: "15 Years", description: "Your risk of coronary heart disease is that of a non-smoker.", duration: 15 * 365 * 24 * 3600)
    ]
}

struct HealthSource: Identifiable {
    let organization: String
    let title: String
    let url: URL

    var id: URL { url }

    static let all: [HealthSource] = [
        HealthSource(
            organization: "World Health Organization",
            title: "Tobacco: Health benefits of smoking cessation",
            url: URL(string: "https://www.who.int/news-room/questions-and-answers/item/tobacco-health-benefits-of-smoking-cessation")!
        ),
        HealthSource(
            organization: "Centers for Disease Control and Prevention",
            title: "Benefits of Quitting Smoking",
            url: URL(string: "https://www.cdc.gov/tobacco/about/benefits-of-quitting.html")!
        ),
        HealthSource(
            organization: "NHS",
            title: "Benefits of quitting smoking",
            url: URL(string: "https://www.nhs.uk/better-health/quit-smoking/benefits-of-quitting-smoking/")!
        )
    ]
}
