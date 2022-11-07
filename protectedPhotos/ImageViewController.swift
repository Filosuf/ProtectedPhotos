//
//  ImageViewController.swift
//  protectedPhotos
//
//  Created by 1234 on 29.09.2022.
//

import UIKit

final class ImageViewController: UIViewController {

    private let image: UIImage

    private lazy var imageView: UIImageView = {

        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = self.image

        return image
    }()

    // MARK: - Initialiser
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layout()
    }

    private func layout() {
        [imageView].forEach { view.addSubview($0) }

        NSLayoutConstraint.activate([

            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
