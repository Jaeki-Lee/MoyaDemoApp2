//
//  ViewController.swift
//  MoyaDemoApp2
//
//  Created by jaeki lee on 2022/07/19.
//

import UIKit
import Then
import SnapKit
import RxDataSources
import RxCocoa
import Reusable
import RxSwift
import Moya

class ViewController: UIViewController {
    
    struct Metric {
        static let collectionViewItemSize = CGSize(
          width: (UIScreen.main.bounds.width - 32.0 - Self.collectionViewSpacing) / 3.0,
          height: 96
        )
        
        static let collectionViewSpacing = 8.0
        
        static let collectionViewContentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    struct Color {
        static let collectionViewBackgroudColor = UIColor.clear
    }
    
    private let disposeBag = DisposeBag()

    //데이터가 저장될 PhotoDataSource 정의
    private let photoDataSource = BehaviorRelay<[PhotoSection]>(value: [])
    
    private let loadImageButton = UIButton().then {
      $0.setTitle("이미지 불러오기", for: .normal)
      $0.setTitleColor(.systemBlue, for: .normal)
      $0.setTitleColor(.blue, for: .highlighted)
    }
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout().then {
            $0.itemSize = Metric.collectionViewItemSize
            $0.minimumLineSpacing = Metric.collectionViewSpacing
            $0.minimumInteritemSpacing = Metric.collectionViewSpacing
        }
    ).then {
        $0.register(cellType: P)
    }
    
    //RxDataSources 정의
//    private func setupCollectionViewDataSource() {
//        let collectionViewDataSource = RxCollectionViewSectionedReloadDataSource<PhotoSection> { _, collectionView, indexPath, sectionItme in
//
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

