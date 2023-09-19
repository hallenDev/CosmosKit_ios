import Foundation

public struct AuthConfig {
    let signInOptions: String?
    let registerOptions: String?
    let registerAuthBlock: String?
    let registerInstructions: String?
    let registerToSignInText: String?
    let forgotPasswordEmailInstructions: String?

    public init(signInOptions: String? = nil,
                registerInstructions: String? = nil,
                registerOptions: String? = nil,
                registerAuthBlock: String? = nil,
                registerToSignInText: String? = nil,
                forgotPasswordEmailInstructions: String? = nil) {

        self.signInOptions = signInOptions
        self.registerInstructions = registerInstructions
        self.registerOptions = registerOptions
        self.registerAuthBlock = registerAuthBlock
        self.registerToSignInText = registerToSignInText
        self.forgotPasswordEmailInstructions = forgotPasswordEmailInstructions
    }
}
