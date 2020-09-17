//
//  ViewController.swift
//  CalculatorDemo
//
//  Created by lyeah2 on 2020/9/15.
//  Copyright © 2020 lyeah2. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var picList = [String]()
    let backView = UIView()
    var resultLabel = UILabel()
    var beforeValue = ""
    var resultValue : Double = 0
    var currentType = 0 //当前选择加  1   减  2  乘  3  除  4
    var beforeType = 0 //上次选择加  1   减  2  乘  3  除  4
    var isOperator = false //是否是加减乘除等于运算符
    var isDot = true //店家加减乘除等于运算符之后是否立即点击了小数点
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        setSubviews()
    }
    
    func setSubviews() {
        resultLabel.textColor = UIColor.white
        resultLabel.font = UIFont.systemFont(ofSize: 80)
        resultLabel.textAlignment = .right
        resultLabel.text = "0"
        resultLabel.sizeToFit()
        layoutItems()
    }
    
    //MARK:布局按钮
    func layoutItems(){
        picList = ["ac", "jiajian","baifen","chu", "7", "8", "9","cheng","4", "5", "6","jian","1", "2", "3","jia","0", "dian", "dengyu"]
        let leading: CGFloat = 20
        let space: CGFloat = 15
        let count: CGFloat = 4
        let allSpace = (count - 1) * space + leading * 2
        let viewWidth = CGFloat(self.view.frame.size.width);
        let buttonWidth = (viewWidth - allSpace) / count
        let zeroWidth = buttonWidth * 2 + space;
        var left: CGFloat = leading
        var top: CGFloat = 0;
        backView.frame = CGRect.init(x: 0, y: 0, width: viewWidth, height: viewWidth)
        self.view.addSubview(backView)
        for index in 0 ..< picList.count {
            let button = UIButton.init(type: .custom)
            button.setImage(UIImage.init(named: picList[index]), for: .normal)
            button.frame = CGRect.init(x: left, y: top, width: buttonWidth, height: buttonWidth)
            if picList[index] != "0" {
                left += space + buttonWidth
            } else {
                button.frame.size.width = zeroWidth
                left += space + zeroWidth
            }
            
            if (left >= (viewWidth - leading)) {
                left = leading
                top += space + buttonWidth
            }
            button.tag = 100 + index
            button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            backView.addSubview(button)
            if index == picList.count - 1 {
                var frame = backView.frame
                frame.size.height = button.frame.maxY
                frame.origin.y = self.view.frame.size.height - frame.size.height - bottomSpace()
                backView.frame = frame
            }
        }
        let frame = CGRect.init(x: leading, y: self.backView.frame.origin.y - resultLabel.frame.size.height - 10, width: self.view.frame.size.width - leading * 2, height: resultLabel.frame.size.height)
        resultLabel.frame = frame;
        self.view.addSubview(resultLabel)
    }
    
    // MARK: - 判断iphoneX
    func isX() -> Bool {
       if UIScreen.main.bounds.height >= 812 {
        return true;
       }
       return false
     }
    
    func bottomSpace() -> (CGFloat) {
        var bottom = CGFloat()
        if isX() {
            bottom = 20 + 34
        } else {
            bottom = 20
        }
        return bottom
    }
    //MARK: 点击事件
    @objc func buttonPressed(sender:UIButton) {
        switch sender.tag {
        case 100: //归零
            resultValue = 0
            beforeType = 0
            currentType = 0
            resultLabel.text = "0"
            isDot = true
        case 101: //取反
            if resultLabel.text == "0" || resultLabel.text!.isEmpty {
                resultLabel.text = "0"
            } else {
                if resultLabel.text!.hasPrefix("-") {
                    resultLabel.text = resultLabel.text!.replacingOccurrences(of: "-", with: "")
                } else {
                    resultLabel.text = "-" + resultLabel.text!
                }
            }
        case 102: //百分比
            var value = Double(resultLabel.text!) ?? 0
            value = value/100
            resultLabel.text = String.init(format: "%g", value)
        case 103://除
            isOperator = true
            beforeType = currentType
            currentType = 4
            resultValue = getResult()
            resultLabel.text = String.init(format: "%g", resultValue)
        case 104://7
             touchNumber(number: 7)
        case 105://8
             touchNumber(number: 8)
        case 106://9
            touchNumber(number: 9)
        case 107://乘
            isOperator = true
            beforeType = currentType
            currentType = 3
            resultValue = getResult()
            resultLabel.text = String.init(format: "%g", resultValue)
        case 108://4
             touchNumber(number: 4)
        case 109://5
             touchNumber(number: 5)
        case 110://6
             touchNumber(number: 6)
        case 111://减
            isOperator = true
            beforeType = currentType
            currentType = 2
            resultValue = getResult()
            resultLabel.text = String.init(format: "%g", resultValue)
        case 112://1
            touchNumber(number: 1)
        case 113://2
            touchNumber(number: 2)
        case 114://3
             touchNumber(number: 3)
        case 115://加
            isOperator = true
            beforeType = currentType
            currentType = 1
            resultValue = getResult()
            resultLabel.text = String.init(format: "%g", resultValue)
        case 116://0
           touchNumber(number: 0)
        case 117://点
//            if isDot {
//                isDot = false
//                resultLabel.text = "0."
//            } else {
                if !(resultLabel.text?.contains("."))! {
                    resultLabel.text = resultLabel.text! + "."
                }
//            }
        case 118://等于
            isOperator = true
            beforeType = currentType
            resultValue = getResult()
            resultLabel.text = String.init(format: "%g", resultValue)
            currentType = 0
            resultValue = 0
        default:
            break
        }
    }
    //MARK: 点击数字
    func touchNumber(number: Int) {
        if resultLabel.text == "0" {
//            if (resultLabel.text?.contains("."))! {
//
//            } else {
               resultLabel.text = ""
//            }
        }
        if isOperator {
            isOperator = false
            resultLabel.text = ""
        }
        if number == 0 {
            resultLabel.text = resultLabel.text! + "0"
        } else {
            let input = String.init(format: "%d", number)
            resultLabel.text = resultLabel.text! + input
        }
//
//        //改
//        if currentType != 0 || beforeType != 0  {
//            isDot = false
//        }
    }
    //MARK: 点击加减乘除等号
    func getResult() -> Double {
        var calculaeResult: Double = 0
        let showString :String = resultLabel.text ?? "0"
        if beforeType == 0 {
            calculaeResult = Double(showString) ?? 0
        } else {
            let show : Double = Double(showString) ?? 0
            if beforeType == 1 {
              calculaeResult = resultValue + show
            } else if beforeType == 2 {
                calculaeResult = resultValue - show
            } else if beforeType == 3 {
                calculaeResult = resultValue * show
            } else if beforeType == 4 {
                calculaeResult = resultValue / show
            }
        }
        return calculaeResult
    }
    
}

