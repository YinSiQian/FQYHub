//
//  RepositoryDetailController.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/7/5.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RepositoryDetailController: BaseViewController {

    var fullName: String = "" {
        didSet {
            title = fullName
        }
    }
    
    var headerView: RepositoryHeaderView!
    
    lazy var tableView: UITableView = {
        let tb = UITableView(frame: self.view.bounds, style: .plain)
        tb.separatorStyle = .none
        tb.delegate = self
        tb.dataSource = self
        tb.backgroundColor = LightTheme().background
        return tb
    }()
    
    var repo: Repository?
    
    private var noticeView: UILabel!
    
    private var titles = [String]()
    
    private var contents = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        bindViewModel()
        self.view.show(with: "loading...")
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        noticeView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.height.equalTo(40)
            make.top.equalTo(self.view.safeAreaInsets.top)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(noticeView.snp.bottom).offset(0)
        }
    }
    
    private func setupSubviews() {
        
        view.addSubview(tableView)
        
        noticeView = UILabel()
        noticeView.text = "See more infomation about this repository >"
        noticeView.textAlignment = .center
        noticeView.font = .systemFont(ofSize: 14)
        noticeView.textColor = .white
        noticeView.backgroundColor = LightTheme().primary
        noticeView.isUserInteractionEnabled = true
        self.view.addSubview(noticeView)
        
        let tag = UITapGestureRecognizer(target: self, action: #selector(self.seeMoreInfo))
        noticeView.addGestureRecognizer(tag)
        
    }
    
    private func bindViewModel() {
        
        let viewModel = RepositoryDetailViewModel(with: fullName)
        
        viewModel.repo.subscribe(onNext: { (repo) in
            self.repo = repo
            self.setupHeaderView()
        }, onError: { (error) in
            self.view.hideHUD()
            self.view.showFail(with: error.localizedDescription)
        }) {
            self.view.hideHUD()
        }.disposed(by: disposeBag)
        
    }
    
    private func setupHeaderView() {
        
        let size = repo?.descriptionField?.calculate(font: .systemFont(ofSize: 14), size: CGSize(width: kScreen_width - 30, height: CGFloat(MAXFLOAT)))
        let currentHeight = 170 + (size?.height ?? 0)
        
        
        headerView = RepositoryHeaderView(frame: CGRect(x: 0, y: noticeView.bottom, width: kScreen_width, height: currentHeight))
        view.addSubview(headerView)
        headerView.model = repo
        tableView.tableHeaderView = headerView
        headerView.avatar.rx.tap.subscribe(onNext: { [weak self] in
            
            let user = UserInfoViewController()
            user.title = self?.repo?.owner?.login
            user.username = self?.repo?.owner?.login ?? ""
            self?.navigationController?.pushViewController(user, animated: true)
            
        }).disposed(by: disposeBag)
        
        titles = ["Author", "Branch", "Created", "Updated", "License", "Issues", "Contributors"]
        contents = [repo?.owner?.login ?? "---", "master", "\(repo?.createdAt?.stringValue ?? "---")", "\(repo?.updatedAt?.stringValue ?? "---")", repo?.license?.name ?? "---", "\(repo?.openIssues ?? 0)", "\(repo?.contributorsCount ?? 0)"]
        
        tableView.reloadData()
    }
    
    @objc private func seeMoreInfo() {
        let web = WebViewController()
        web.url = repo?.htmlUrl
        navigationController?.pushViewController(web, animated: true)
    }

}

extension RepositoryDetailController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = LightTheme().background
        return v
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RepositoryInfoCell.cell(with: tableView)
        cell.title.text = titles[indexPath.row]
        cell.content.text = contents[indexPath.row]
        return cell
    }
    
}
