import Foundation

struct MotivationalMessages {

    static func message(forDaysElapsed days: Double, isTurkish: Bool) -> String {
        let bracket = timeBracket(forDays: days)
        let messages = isTurkish ? turkishMessages[bracket]! : englishMessages[bracket]!

        let hoursSinceEpoch = Int(Date().timeIntervalSince1970 / 10800)
        let index = hoursSinceEpoch % messages.count
        return messages[index]
    }

    enum TimeBracket: Int, CaseIterable {
        case minutes
        case firstHours
        case firstDay
        case twoDays
        case firstWeek
        case twoWeeks
        case firstMonth
        case twoMonths
        case threeMonths
        case sixMonths
        case oneYear
        case beyondYear
    }

    static func timeBracket(forDays days: Double) -> TimeBracket {
        let hours = days * 24
        if hours < 1       { return .minutes }
        if hours < 8       { return .firstHours }
        if hours < 24      { return .firstDay }
        if days < 3        { return .twoDays }
        if days < 7        { return .firstWeek }
        if days < 14       { return .twoWeeks }
        if days < 30       { return .firstMonth }
        if days < 60       { return .twoMonths }
        if days < 90       { return .threeMonths }
        if days < 180      { return .sixMonths }
        if days < 365      { return .oneYear }
        return .beyondYear
    }

    static let turkishMessages: [TimeBracket: [String]] = [
        .minutes: [
            "Yolculuk başladı! İlk adım en zoru, sen başardın.",
            "Her saniye önemli. Şu an vücudun iyileşmeye başlıyor.",
            "Cesur bir karar verdin. Kendini kutla!",
            "Kalbin 20 dakika içinde yavaşlamaya başlayacak."
        ],
        .firstHours: [
            "Kanındaki karbon monoksit düşmeye başladı.",
            "İlk saatler en zor ama sen güçlüsün!",
            "Vücudun temizlenmeye başladı, harika gidiyorsun.",
            "Bu anları atlatırsan gerisi kolay! Devam et.",
            "Nikotinin etkisi azalıyor, özgürleşiyorsun."
        ],
        .firstDay: [
            "İlk gününü tamamlıyorsun! Bu büyük bir başarı.",
            "Kanındaki karbonmonoksit normale dönüyor.",
            "Duman yerine temiz hava soluyorsun, ciğerlerin teşekkür ediyor.",
            "24 saat! Vücudun nikotin bağımlılığını yenmeye başladı.",
            "Her nefes artık daha temiz, daha derin."
        ],
        .twoDays: [
            "Koku ve tat duyuların geri geliyor! Fark ettin mi?",
            "2. gün — en zor dönem bitmek üzere!",
            "Sinir uçların yenilenmeye başladı.",
            "Nikotinsiz 48 saat! İrade gücün muazzam.",
            "Her geçen saat vücudun daha da güçleniyor."
        ],
        .firstWeek: [
            "Bir hafta neredeyse tamam! Bu çok ciddi bir başarı.",
            "Nefes almak her gün biraz daha kolaylaşıyor.",
            "Vücudun kendini onarmaya devam ediyor.",
            "Nefes almak kolaylaşmaya başladı, değil mi?",
            "Bir hafta sigarasız — bunu çok az kişi başarabilir!"
        ],
        .twoWeeks: [
            "2 hafta! Kan dolaşımın iyileşmeye başlıyor.",
            "Merdiven çıkmak artık daha kolay.",
            "Akciğer kapasiten artıyor, derin nefes al ve hisset!",
            "Sevdiğin şeyler için daha çok enerjin var."
        ],
        .firstMonth: [
            "1 AY! Akciğerlerin ciddi şekilde onarılıyor.",
            "Öksürük azaldı, enerji arttı. Yeni sen budur!",
            "30 gün! Yeni alışkanlıkların yerleşiyor.",
            "Spor yaparken farkı hissediyorsundur, devam et!",
            "Bir ay! Para biriktirdin, sağlık kazandın. Bravo!"
        ],
        .twoMonths: [
            "2 ay sigarasız! Kan dolaşımın ve nefesin iyileşiyor.",
            "Öksürük ve nefes darlığı azalmaya başlıyor.",
            "Dolaşım sistemi artık çok daha iyi çalışıyor.",
            "Stres yönetimin iyileşti, sigara olmadan da yapabiliyorsun."
        ],
        .threeMonths: [
            "3 AY! Akciğer fonksiyonun iyileşiyor.",
            "Fiziksel aktivite artık daha kolay geliyor.",
            "Kan dolaşımın ve nefesin eskisinden daha iyi.",
            "Artık bir sigara bırakma kahramanısın!"
        ],
        .sixMonths: [
            "6 AY! Öksürük ve nefes darlığı azalıyor.",
            "Yarım yıl sigarasız! Akciğerlerin harika çalışıyor.",
            "Sigarasız her ay kalbin ve akciğerlerin için bir kazanç.",
            "Vücudun artık eski sigara içen bir kişiyi tanımıyor bile."
        ],
        .oneYear: [
            "Bir yılın sonunda kalp hastalığı riskin, sigara içen birinin yaklaşık yarısı olacak.",
            "1 yıla yaklaşıyorsun — efsanesin!",
            "Bu sürede biriktirdiğin parayı düşün... harika!",
            "Bir yıllık sigara dumanı yerine temiz hava seçtin."
        ],
        .beyondYear: [
            "1 YIL+ Sigarasız! Sen bir efsanesin.",
            "Kalp hastalığı riskin, sigara içen birinin yaklaşık yarısı.",
            "İnme riskin yıldan yıla azalıyor.",
            "Yeni nesillere ilham oluyorsun!",
            "Artık sigarasız bir yaşam senin doğal halin."
        ]
    ]

    static let englishMessages: [TimeBracket: [String]] = [
        .minutes: [
            "Your journey has begun! The first step is the hardest.",
            "Every second counts. Your body is starting to heal right now.",
            "You made a brave decision. Celebrate yourself!",
            "Your heart rate will start dropping in just 20 minutes."
        ],
        .firstHours: [
            "Carbon monoxide in your blood is dropping.",
            "The first hours are tough but you are tougher!",
            "Your body has begun cleansing itself, great going!",
            "Push through these moments and it gets easier!",
            "Nicotine's grip is loosening, freedom awaits."
        ],
        .firstDay: [
            "You're completing your first day! What an achievement.",
            "The carbon monoxide in your blood is returning to normal.",
            "Clean air instead of smoke — your lungs thank you.",
            "24 hours! Your body is conquering nicotine addiction.",
            "Every breath is now cleaner and deeper."
        ],
        .twoDays: [
            "Your sense of smell and taste are returning! Notice it?",
            "Day 2 — the hardest phase is almost over!",
            "Your nerve endings are regenerating.",
            "48 hours nicotine-free! Your willpower is incredible.",
            "Every passing hour makes your body stronger."
        ],
        .firstWeek: [
            "Almost one week! This is a serious accomplishment.",
            "Breathing gets a little easier every day.",
            "Your body keeps repairing itself.",
            "Breathing is getting easier, can you feel it?",
            "One week smoke-free — few people achieve this!"
        ],
        .twoWeeks: [
            "2 weeks! Your circulation is starting to improve.",
            "Climbing stairs is getting easier now.",
            "Your lung capacity is increasing — take a deep breath!",
            "You have more energy for the things you love."
        ],
        .firstMonth: [
            "1 MONTH! Your lungs are seriously repairing themselves.",
            "Less coughing, more energy. This is the new you!",
            "30 days! Your new habits are settling in.",
            "You must feel the difference when exercising, keep it up!",
            "One month! Money saved, health regained. Bravo!"
        ],
        .twoMonths: [
            "2 months smoke-free! Your circulation and breathing are improving.",
            "Coughing and shortness of breath are starting to ease.",
            "Your circulatory system is performing much better now.",
            "Your stress management improved — no cigarette needed."
        ],
        .threeMonths: [
            "3 MONTHS! Your lung function is improving.",
            "Physical activity feels easier now.",
            "Your circulation and breathing are better than before.",
            "You're officially a quit-smoking hero!"
        ],
        .sixMonths: [
            "6 MONTHS! Coughing and shortness of breath are easing.",
            "Half a year smoke-free! Your lungs are thriving.",
            "Every smoke-free month is a gain for your heart and lungs.",
            "Your body barely remembers you were a smoker."
        ],
        .oneYear: [
            "At one year, your heart disease risk will be about half that of a smoker.",
            "Approaching 1 year — you're legendary!",
            "Think about all the money you've saved... amazing!",
            "A full year of clean air instead of smoke."
        ],
        .beyondYear: [
            "1 YEAR+ Smoke-free! You are a legend.",
            "Your heart disease risk is about half that of a smoker.",
            "Your stroke risk keeps falling year after year.",
            "You're inspiring future generations!",
            "A smoke-free life is now your natural state."
        ]
    ]
}
