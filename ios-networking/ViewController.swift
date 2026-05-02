//
//  ViewController.swift
//  ios-networking
//
//  Created by Khanh Anh Kiet on 2026-04-25.
//

import UIKit

class ViewController: UIViewController {

    private let viewModel: LoginViewModel

    // MARK: - UI

    private let emailField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let passwordField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Login", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .medium)
        ai.hidesWhenStopped = true
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
    }()

    // MARK: - Init

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not supported")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        emailField.text = "eve.holt@reqres.in"
        passwordField.text = "cityslicka"
    }

    // MARK: - Setup

    private func setupUI() {
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            emailField.widthAnchor.constraint(equalToConstant: 280),

            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 16),
            passwordField.widthAnchor.constraint(equalToConstant: 280),

            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 24),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
        ])

        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func loginTapped() {
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            showAlert("Please fill in all fields")
            return
        }

        setLoading(true)

        Task {
            await viewModel.login(email: email, password: password)
            setLoading(false)

            if viewModel.isLoggedIn {
                print("Login success — navigate to home here")
            } else if let error = viewModel.errorMessage {
                showAlert(error)
            }
        }
    }

    private func setLoading(_ loading: Bool) {
        loading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        loginButton.isEnabled = !loading
    }

    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
