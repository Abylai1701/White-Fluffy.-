import UIKit
import Alamofire
import Kingfisher
import Lottie

class MainPageVC: BaseController {
    private let viewModel: MainPageViewModelProtocol
    private var searchTimer: Timer?

    lazy var searchField: BaseTextField = {
        let field = BaseTextField()
        let space = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        field.leftView = space
        field.leftViewMode = .always
        field.rightImage.isHidden = true
        field.actionButton.isHidden = true
        field.attributedPlaceholder = NSAttributedString(
            string: "Поиск",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        field.layer.masksToBounds = true
        field.delegate = self
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private var collectionView: UICollectionView!
    
    private lazy var lottieView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "loadAnimation")
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.isHidden = true
        return animationView
    }()
    
    init(viewModel: MainPageViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupCollectionView()
        bindViewModel()
        Task {
            self.startLoadingAnimation()
            await viewModel.fetchRandomPhotos()
            self.stopLoadingAnimation()
        }
        hideKeyboardWhenTappedAround()
    }
    
    private func setupViews() {
        view.addSubview(searchField)
        
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width/2 - 5, height: 200)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(lottieView)
        lottieView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            lottieView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            lottieView.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            lottieView.widthAnchor.constraint(equalToConstant: 100),
            lottieView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func bindViewModel() {
        viewModel.photosPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &viewModel.cancellables)
    }
    
    private func startLoadingAnimation() {
        lottieView.isHidden = false
        lottieView.play()
    }

    private func stopLoadingAnimation() {
        lottieView.stop()
        lottieView.isHidden = true
    }
    
}

extension MainPageVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let photo = viewModel.photos[indexPath.item]
        cell.configure(with: photo)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.goToDetail(photo: viewModel.photos[indexPath.item])
    }
}

extension MainPageVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            searchTimer?.invalidate()
            
            
            searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
                guard let self = self else { return }
                Task {
                    self.startLoadingAnimation()
                    await self.viewModel.searchPhoto(value: updatedText)
                    self.stopLoadingAnimation()
                }
            }
        }
        return true
    }
}
