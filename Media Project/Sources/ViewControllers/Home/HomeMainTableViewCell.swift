//
//  HomeMainTableViewCell.swift
//  Media Project
//
//  Created by 박소진 on 2023/11/11.
//

import UIKit
import Kingfisher

final class HomeMainTableViewCell: BaseTableViewCell {
    
    let titleLabel = {
        let view = UILabel()
        view.text = "인기 영화"
        view.font = .systemFont(ofSize: 16, weight: .bold)
        return view
    }()
    
    let collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: setCollectionViewLayout())
        view.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    var data: [PopularResult] = []
    weak var delegate: HomeMainTableViewCellDelegate?
    
    func configureCell(data: [PopularResult]) {
        self.data = data
        collectionView.reloadData()
    }
    
    override func configureView() {
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        [collectionView, titleLabel].forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.horizontalEdges.equalToSuperview().inset(15)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    private static func setCollectionViewLayout() -> UICollectionViewFlowLayout {
        
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 15
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 160)
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        
        return layout
    }
}

extension HomeMainTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
        
        if indexPath.item < data.count {
            let item = data[indexPath.item]
            let url = URL(string: URL.imageURL + (item.posterPath ?? ""))
            cell.posterImageView.kf.setImage(with: url)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = data[indexPath.item]
        delegate?.didSelectItem(data)
    }
}
