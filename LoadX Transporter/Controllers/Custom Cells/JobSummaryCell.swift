//
//  JobSummaryCell.swift
//  LoadX Transporter
//
//  Created by Fahad Baig on 20/10/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Reusable
import AVFoundation
class JobSummaryCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var audioView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    var audioUrl : String? = nil
    var updater : CADisplayLink! = nil
    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        audioView.layer.cornerRadius = 20
        audioView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        player = nil
    }
    
    @IBAction func playAudio(_ sender: Any) {
        playAct()
    }
    
    var timer: Timer?
    
    func playAct() {
        playButton.isSelected = !(playButton.isSelected)
        if playButton.isSelected {
            if player == nil {
                let fileURL = URL(string: audioUrl!)!
                playerItem = AVPlayerItem.init(url: fileURL)
                player = AVPlayer.init(playerItem: playerItem)
            }
        
            player?.volume = 10
            player?.play()
            
            playButton.setImage(R.image.pauseIcon(), for: .normal)
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (_) in
                self?.trackAudio()
            })
        } else {
            playButton.setImage(R.image.playIcon(), for: .normal)
            player?.pause()
            timer?.invalidate()
        }
    }
    
    func trackAudio() {
        guard let item = playerItem else {return}
        let timePercentage = (item.currentTime().seconds / item.duration.seconds)
        progressView.progress = Float(timePercentage)
        timeLabel.text = "\(player?.currentTime().seconds.asString(style: .full) ?? "0.0")"
    }

}

extension Double {
    func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second, .nanosecond]
        formatter.unitsStyle = style
        return formatter.string(from: self) ?? ""
      }
}
