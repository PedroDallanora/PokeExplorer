import Foundation

extension String {
    func isEmailValido() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }

    func isSenhaValida() -> Bool {
        let senhaRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[ !$%&?._-])[A-Za-z\\d !$%&?._-]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", senhaRegex).evaluate(with: self)
    }
}
