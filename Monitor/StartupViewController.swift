//
//  StartupViewController.swift
//  AntTicket
//
//  Created by 王 夏阳 on 16/12/12.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

import UIKit
import Foundation

class StartupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let timer : Timer = Timer(timeInterval: 3, target: self, selector: #selector(StartupViewController.toRootPage), userInfo: nil, repeats: true)
        
        let runLoop : RunLoop = RunLoop.current;
        runLoop.add(timer, forMode: RunLoopMode.defaultRunLoopMode);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func toRootPage( sender: Timer) {
        sender.invalidate()
        self.performSegue(withIdentifier: "RootPage", sender: nil)

    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//         Get the new view controller using segue.destinationViewController.
//         Pass the selected object to the new view controller.
        UIApplication.shared.keyWindow?.rootViewController = segue.destination;
    }
 

}
