//
//  ChatInterfaceViewController.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/15.
//

import UIKit
import MessageKit

class ChatInterfaceViewController: MessagesViewController {
    
    enum MessagesDefaultSection: Int {
        case systemMessage = 0
        case uploadButtonMessage = 2
    }

    let defaultSender: Sender = Sender(name: .user)
    let chatInterfaceViewModel = ChatInterfaceViewModel()

    private lazy var tagMessageCellSizeCalculator
        = TagMessageCellSizeCalculator(layout: self.messagesCollectionView.messagesCollectionViewFlowLayout)
    private lazy var recommendationCellSizeCalculator
        = RecommendationCellSizeCalculator(layout: self.messagesCollectionView.messagesCollectionViewFlowLayout)
    private lazy var attributedTextCellSizeCalculator
        = AttributedTextCellSizeCalculator(layout: self.messagesCollectionView.messagesCollectionViewFlowLayout)
    
    // MARK: Override(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupMessagesCollectionViewAttributes()
        configureMessageInputBar()
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell
    {
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
            fatalError("Datasource error")
        }
        
        guard !isSectionReservedForTypingIndicator(indexPath.section) else {
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }
        
        if let defaultSection = MessagesDefaultSection(rawValue: indexPath.section) {
            switch defaultSection {
            case .systemMessage:
                return messagesCollectionView.dequeueReusableCell(SystemMessageCell.self, for: indexPath)
            case .uploadButtonMessage:
                let cell = messagesCollectionView.dequeueReusableCell(UploadButtonCell.self, for: indexPath)
                cell.configureButtonState(state: chatInterfaceViewModel.uploadButtonState)
                return cell
            }
        }

        return super.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    // MARK: Internal
    
    func customCell(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView)
        -> UICollectionViewCell
    {
        if case let .custom(item) = message.kind {
            if item is TagItem {
                let cell = messagesCollectionView.dequeueReusableCell(CustomTagContentCell.self, for: indexPath)
                cell.sizedelegate = self
                cell.configure(with: message)
                return cell
            } else if item is [RecommendationItem] {
                let cell = messagesCollectionView.dequeueReusableCell(RecommendationCell.self, for: indexPath)
                cell.configure(with: message)
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
    
    private func bind() {
        chatInterfaceViewModel.messageStorage.didChangedMessageList = { [weak self] in
            DispatchQueue.main.async {
                self?.messagesCollectionView.reloadData()
                self?.messagesCollectionView.scrollToLastItem()
            }
        }
        
        chatInterfaceViewModel.didchangeUploadButtonState = { [weak self] state in
            let uploadButtonCellSectionIndex = MessagesDefaultSection.uploadButtonMessage.rawValue
            let indexSet = IndexSet(integer: uploadButtonCellSectionIndex)

            DispatchQueue.main.async {
                UIView.performWithoutAnimation {
                    self?.messagesCollectionView.reloadSections(indexSet)
                }
            }
        }
    }
    
    private func setupMessagesCollectionViewAttributes() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        customizeMessagesCollectionViewLayout()
        cellResistration()
        configureMessagesCollectionViewBackgroundColor()
        messagesCollectionView.reloadData()
    }
    
    private func customizeMessagesCollectionViewLayout() {
        let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        layout?.sectionInset = UIEdgeInsets(top: 8, left: .zero, bottom: 8, right: .zero)
        layout?.setMessageOutgoingAvatarSize(CGSize(width: 0, height: 0))
    }
    
    private func cellResistration() {
        messagesCollectionView.register(SystemMessageCell.self)
        messagesCollectionView.register(UploadButtonCell.self)
        messagesCollectionView.register(CustomTagContentCell.self)
        messagesCollectionView.register(
            RecommendationCell.self,
            forCellWithReuseIdentifier: RecommendationCell.identifier)
    }
    
    private func configureMessagesCollectionViewBackgroundColor() {
        messagesCollectionView.backgroundColor = .blueGrayBackground
    }
    
    private func configureMessageInputBar() {
        messageInputBar = CustomInputBarAccessoryView()
        messageInputBar.separatorLine.isHidden = true
        inputBarType = .custom(messageInputBar)
    }
}

// MARK: MessagesDataSource

extension ChatInterfaceViewController: MessagesDataSource {
    var currentSender: SenderType {
        return defaultSender
    }
    
    func messageForItem(
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView)
        -> MessageType
    {
        return chatInterfaceViewModel.messageStorage.sectionOfMessageList(indexPath.section)
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return chatInterfaceViewModel.messageStorage.count
    }
}

// MARK: MessagesDisplayDelegate

extension ChatInterfaceViewController: MessagesDisplayDelegate {
    func textColor(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView)
        -> UIColor
    {
        return isFromCurrentSender(message: message) ? .white : .black
    }
    
    func backgroundColor(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView)
        -> UIColor
    {
        return isFromCurrentSender(message: message) ? .primary : .blueGrayBackground2
    }
    
    func messageStyle(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView)
        -> MessageStyle
    {
        return .bubble
    }
    
    func configureAvatarView(
        _ avatarView: AvatarView,
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView)
    {
        let avatarImage = UIImage(named: "chat-with-background")
        let avatar = Avatar(image: avatarImage)
        avatarView.set(avatar: avatar)
        avatarView.backgroundColor = .clear
    }
}

// MARK: MessagesLayoutDelegate

extension ChatInterfaceViewController: MessagesLayoutDelegate {
    func customCellSizeCalculator(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView)
        -> CellSizeCalculator
    {
        guard case let .custom(item) = message.kind else {
            return MessageSizeCalculator()
        }
        
        if item is TagItem {
            return tagMessageCellSizeCalculator
        } else if item is [RecommendationItem] {
            return recommendationCellSizeCalculator
        }
        
        return MessageSizeCalculator()
    }
    
    func attributedTextCellSizeCalculator(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView)
        -> CellSizeCalculator?
    {
        if let defaultSection = MessagesDefaultSection(rawValue: indexPath.section) {
            switch defaultSection {
            case .systemMessage:
                return SystemMesasgeCellSizeCalculator(layout: messagesCollectionView.messagesCollectionViewFlowLayout)
            case .uploadButtonMessage:
                return ButtonMessageCellSizeCalculator(layout: messagesCollectionView.messagesCollectionViewFlowLayout)
            }
        }

        return attributedTextCellSizeCalculator
    }
}

extension ChatInterfaceViewController: TagMessageSizeDelegate {
    func didUpdateTagMessageHeight(_ height: CGFloat) {
        guard let tagMessageIndex = chatInterfaceViewModel.messageStorage.findTagMessageIndex() else {
            print("MessageStorage에서 TagMessage를 찾지못헀음")
            return
        }
        
        let tagSectionIndex: IndexSet = IndexSet(integer: tagMessageIndex)
        tagMessageCellSizeCalculator.updateMessageContainerHeight(height)
        UIView.performWithoutAnimation {
            messagesCollectionView.reloadSections(tagSectionIndex)
        }
        
        messagesCollectionView.scrollToLastItem()
    }
}
