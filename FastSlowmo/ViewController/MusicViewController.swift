//
//  MusicViewController.swift
//  FastSlowmo
//
//  Created by Manh Nguyen Ngoc on 12/02/2021.
//

import UIKit

protocol MusicViewControllerDelegate: class {
    func musicViewController(_ view: MusicViewController, didSelectNameMusic music: String, countedClickMusic: Int)
}

class MusicViewController: UIViewController {
    
    var listMusic = ["SampleAudio1", "Andy-Cohen-Gazing", "Crowander-Crime-Story", "Derek-Clegg-Golden-Rule", "Ketsa-Light-Through-The-Window", "Shaolib-Dub-Disruptor"]

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: MusicViewControllerDelegate?
    var countedClickMusic: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CELL")
    }

    // MARK: - Methods
    @IBAction func cancelButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - Extension UITableViewDelegate
extension MusicViewController: UITableViewDelegate {
    
}

// MARK: - Extension UITableViewDataSource
extension MusicViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listMusic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell?
        cell?.textLabel?.textColor = .white
        cell?.textLabel?.text = listMusic[indexPath.row]
        cell?.backgroundColor = .clear
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        countedClickMusic += 1
        delegate?.musicViewController(self, didSelectNameMusic: listMusic[indexPath.row], countedClickMusic: countedClickMusic)
        navigationController?.popViewController(animated: true)
    }
}
