//
//  MineViewController.swift
//  FQYHub
//
//  Created by yinsiqian on 2019/7/4.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import UIKit
import SafariServices

class MineViewController: BaseViewController {
    
    lazy private var loginBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Sign In With Github", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = LightTheme().primary
        btn.layer.cornerRadius = 22;
        btn.layer.masksToBounds = true
        return btn
    }()
    
    lazy var tableView: UITableView = {
        let tb = UITableView(frame: self.view.bounds, style: .plain)
        tb.separatorStyle = .none
        tb.delegate = self
        tb.dataSource = self
        tb.backgroundColor = LightTheme().background
        return tb
    }()
    
    private var user: User?
    
    private var titles = [String]()
    
    private var des = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        if TokenManager.shared.isAuth {
            tableView.snp.makeConstraints { (make) in
                make.edges.equalTo(self.view)
            }
        }
       
    }
    
    private func setupSubviews() {
        
        if !TokenManager.shared.isAuth {
            view.addSubview(loginBtn)
            
            loginBtn.snp.makeConstraints { (make) in
                make.center.equalTo(self.view)
                make.height.equalTo(44)
                make.left.equalTo(self.view).offset(15)
                make.right.equalTo(self.view).offset(-15)
            }
            
            bindViewModel()
        } else {
            view.addSubview(tableView)
            autoLogin()
        }
       
    }
    
    private func autoLogin() {
        self.show(with: "")
        singleProvider.profile().subscribe(onSuccess: { (user) in
            self.hideHUD()
            user.save()
            self.updateUI()
            self.setupData()
        }) { (error) in
            self.view.showFail(with: error.localizedDescription)
            self.hideHUD()
        }.disposed(by: disposeBag)
        
    }
    
    private func bindViewModel() {
        
        let input = MineViewModel.Input(oAuthTrigger: loginBtn.rx.tap.asDriver())
        
        let viewModel = MineViewModel().transform(input: input)
        
        viewModel.actionCompection.drive(onNext: { (_) in
            print("123456")
            self.updateUI()
            self.setupData()
            
        }, onCompleted: {
            print("onCompleted 123456")

        }).disposed(by: disposeBag)
    }
    
    private func setupData() {
        if let user = User.currentUser() {
            self.user = user
            
            let size = user.descriptionField?.calculate(font: .systemFont(ofSize: 14), size: CGSize(width: kScreen_width - 30, height: CGFloat(MAXFLOAT)))
            let currentHeight = 150 + (size?.height ?? 0)
            
            let headerView = MineHeaderView(frame: CGRect(x: 0, y: 0, width: kScreen_width, height: currentHeight))
            headerView.avatar.rx.tap.subscribe(onNext: { () in
                
                let web = WebViewController()
                web.url = user.htmlUrl
                self.navigationController?.pushViewController(web, animated: true)
                
            }).disposed(by: disposeBag)
            headerView.updateInfo()
            
            tableView.tableHeaderView = headerView
            
            let following = "\(user.following ?? 0)"
            let repos = "\(user.repositoriesCount ?? 0)"
            let follows = "\(user.followers ?? 0)"
            let blog = "\(user.bio ?? "---")"
            
            des = [follows, repos, following, blog]
            titles = ["Followers", "Repos", "Following", "Blog"]
            tableView.reloadData()
            
        }
        
    }
    
    private func updateUI() {
        if TokenManager.shared.isAuth {
            
            view.addSubview(tableView)
            loginBtn.removeFromSuperview()
        } else {
            tableView.removeFromSuperview()
            view.addSubview(loginBtn)
            loginBtn.snp.remakeConstraints { (make) in
                make.center.equalTo(self.view)
                make.height.equalTo(44)
                make.left.equalTo(self.view).offset(15)
                make.right.equalTo(self.view).offset(-15)
            }
        }
    }


}

extension MineViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !TokenManager.shared.isAuth {
            return 0
        }
        return section == 1 ? 1 : titles.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = LightTheme().background
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = MineCell.cell(with: tableView)
            cell.title.text = titles[indexPath.row]
            cell.des.text = des[indexPath.row]
            return cell
        } else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
                cell?.textLabel?.textAlignment = .center
                cell?.textLabel?.text = "Log Out"
                cell?.textLabel?.textColor = LightTheme().primary
            }
            return cell!
        }
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 3 {
                guard let url = user?.blog else {
                    return
                }
                if url.hasPrefix("http") || url.hasPrefix("https") {
                    let web = WebViewController()
                    web.url = url
                    self.navigationController?.pushViewController(web, animated: true)
                } else {
                    show(message: "Blog url error")
                }
                
            }
            if indexPath.row == 1 {
                let repos = UserReposViewController()
                repos.username = user?.login ?? ""
                self.navigationController?.pushViewController(repos, animated: true)
            }
            if indexPath.row == 0 {
                let followers = FollowerListViewController()
                followers.username = user?.login ?? ""
                self.navigationController?.pushViewController(followers, animated: true)
            }
            
        }
        if indexPath.section == 1 {
            //Clear
            TokenManager.shared.remove()
            User.clear()
            updateUI()
        }
    }
    
    
    
    
}
