//
//  CustomMessageContentCell.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/18.
//

import MessageKit
import UIKit

// 굳이 이거 서브클래싱해서 CustomTagContentCell을 구현할 필요가 없는 것 같아요!
// 그냥 UICollectionViewCell을 서브클래싱해서 만들어도 될 것 같아서 얘는 삭제해도 될 것 같습니다~
class CustomMessageContentCell: MessageCollectionViewCell {
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        setupSubviews()
    }
    
    // MARK: Internal
    
    /// The `MessageCellDelegate` for the cell.
    weak var delegate: MessageCellDelegate?
    
    /// The container used for styling and holding the message's content view.
    var messageContainerView: UIView = {
        let containerView = UIView()
        containerView.clipsToBounds = true
        containerView.layer.masksToBounds = true
        return containerView
    }()
    
    func setupSubviews() {
        messageContainerView.layer.cornerRadius = 20
        contentView.addSubview(messageContainerView)
    }
    
    func configure(
        with message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView,
        dataSource: MessagesDataSource,
        and sizeCalculator: CustomCellSizeCalculator)
    {
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            return
        }
        messageContainerView.frame = sizeCalculator.messageContainerFrame(
            for: message,
            at: indexPath,
            fromCurrentSender: dataSource
                .isFromCurrentSender(message: message))
        messageContainerView.backgroundColor = displayDelegate.backgroundColor(
            for: message,
            at: indexPath,
            in: messagesCollectionView)
    }
    
}


/*
 /// Handle tap gesture on contentView and its subviews.
 override func handleTapGesture(_ gesture: UIGestureRecognizer) {
 let touchLocation = gesture.location(in: self)
 
 switch true {
 case messageContainerView.frame
 .contains(touchLocation) && !cellContentView(canHandle: convert(touchLocation, to: messageContainerView)):
 delegate?.didTapMessage(in: self)
 case cellTopLabel.frame.contains(touchLocation):
 delegate?.didTapCellTopLabel(in: self)
 case cellDateLabel.frame.contains(touchLocation):
 delegate?.didTapMessageBottomLabel(in: self)
 default:
 delegate?.didTapBackground(in: self)
 }
 }
 
 /// Handle long press gesture, return true when gestureRecognizer's touch point in `messageContainerView`'s frame
 override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
 let touchPoint = gestureRecognizer.location(in: self)
 guard gestureRecognizer.isKind(of: UILongPressGestureRecognizer.self) else { return false }
 return messageContainerView.frame.contains(touchPoint)
 }
 
 /// Handle `ContentView`'s tap gesture, return false when `ContentView` doesn't needs to handle gesture
 func cellContentView(canHandle _: CGPoint) -> Bool {
 false
 }
 */
