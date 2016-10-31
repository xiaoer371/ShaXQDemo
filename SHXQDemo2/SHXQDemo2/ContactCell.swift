//
//  ContactCell.swift
//  SHXQDemo2
//
//  Created by swhl on 16/3/4.
//  Copyright © 2016年 sprite. All rights reserved.
//

import UIKit

enum  MCDeleteState {
    case MCDeleteBtnStateNormal
    case MCDeleteBtnStateEditing
}

protocol ContactCellDelegate :NSObjectProtocol {
    func deleteCurrentItem(item:ContactCell)
}

let   xCellPaddingLeft :CGFloat = 8.0;
let   xCellPaddingTop  :CGFloat = 5.0;
let   xCellTitleHeight :CGFloat = 20.0;

class ContactCell: UICollectionViewCell {
    var delegate :ContactCellDelegate?
    var contast:Contact?
    var _delState = MCDeleteState.MCDeleteBtnStateNormal
    var delState:MCDeleteState{
        get{
            return _delState;
        }
        set {
            _delState = delState;
            if (_delState == MCDeleteState.MCDeleteBtnStateNormal) {
                self.delBtn.hidden = true;
            }else if (_delState == MCDeleteState.MCDeleteBtnStateEditing){
                self.delBtn.hidden = false;
            }else{
                
            }
        }
    }

    private
    var headImageView:UIImageView!
    var titleLabel:UILabel!
    var delBtn:UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delState = MCDeleteState.MCDeleteBtnStateNormal
        headImageView = UIImageView(frame:CGRect(x: xCellPaddingLeft, y: xCellPaddingTop, width:(frame.size.height-3*xCellPaddingTop-xCellTitleHeight), height:(frame.size.width-2*xCellPaddingLeft)))
        self.addSubview(headImageView)

        titleLabel = UILabel(frame: CGRect(x: xCellPaddingLeft/2, y: CGRectGetMaxX(headImageView.frame)+xCellPaddingTop, width: frame.size.width-xCellPaddingLeft, height: xCellTitleHeight))
        titleLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(titleLabel)
        
        delBtn = UIButton(type:.Custom)
        delBtn.frame = CGRect(x: CGRectGetMaxX(headImageView.frame), y: 3.0, width: 15.0, height: 15.0)
        delBtn.setImage(UIImage(named:"delMini.png"), forState: UIControlState.Normal)
        delBtn.addTarget(self, action: Selector("delectActions:"), forControlEvents: UIControlEvents.TouchUpInside)
        delBtn.hidden = true;
        self.addSubview(delBtn)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func delectActions(sender:UIButton){
        delegate?.deleteCurrentItem(self)
    }
    
    func setDataWithModel(contactModel:Contact){
        contast = contactModel ;
        
        titleLabel.text = contactModel.name;
    
        if (contactModel.state == ContactState.ContactStateAdd ) {
            headImageView.image = UIImage(named: "add.png")
            self.delBtn.hidden = true;
        }else if (contactModel.state == ContactState.ContactStateDel){
            headImageView.image = UIImage(named: "delete.png")
            self.delBtn.hidden = true;
        }else{
            headImageView.image = UIImage(named: "nv.png")
        }
    }
    
    func resetTitleName(name: String){
        titleLabel.text = name
    }
    
    func angleToRadion(angle:Double)->CGFloat{
        return  CGFloat(angle / 180.0 * M_PI)
    }
    
    
    func StartShakeAnimations(){
        let ani :CAKeyframeAnimation = CAKeyframeAnimation()
        ani.keyPath = "transform.rotation"
        ani.values = [self.angleToRadion(-6),self.angleToRadion(6),self.angleToRadion(-6)];
        ani.repeatCount = MAXFLOAT;
        ani.duration = 0.2;
        self.layer.addAnimation(ani, forKey: "mcshake")
    }
    
    func StopShakeAnimations(){
        self.layer.removeAnimationForKey("mcshake")
    }
    
}
