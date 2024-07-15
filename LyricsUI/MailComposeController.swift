struct MailComposeController {
    
    static func compose() {
        let mailAddress = FeedbackPlaceholders.mailAddress.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let subject = FeedbackPlaceholders.subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let url = URL(string: "mailto:\(mailAddress)?subject=\(subject)")!
        UIApplication.shared.open(url)
    }
}


private extension MailComposeController {
    
    struct FeedbackPlaceholders {
        static let mailAddress = "Rhythm Support<alexandermcandrewog@gmail.com@gmail.com>"
        static let subject = "Feedback - Rhythm (\(Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? ""))"
    }
}
