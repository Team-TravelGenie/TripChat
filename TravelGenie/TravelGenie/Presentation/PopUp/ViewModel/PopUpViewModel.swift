//
//  PopUpViewModel.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/26.
//

import Foundation

final class PopUpViewModel {
    
    func createFeedbackModel() -> PopUpModel {
        let mainText = NSMutableAttributedString()
            .text("오늘 대화는 어떠셨나요?\n", font: .bodyRegular, color: .black)
            .text("피드백", font: .bodyBold, color: .primary)
            .text("을 주시면 이후 서비스 개선에 참고하겠습니다!", font: .bodyRegular, color: .black)
        let leftButtonTitle = NSMutableAttributedString()
            .text("보내기", font: .bodyRegular, color: .white)
        let rightButtonTitle = NSMutableAttributedString()
            .text("안 할래요", font: .bodyRegular, color: .black)
        
        return PopUpModel(
            mainText: mainText,
            leftButtonTitle: leftButtonTitle,
            rightButtonTitle: rightButtonTitle)
    }
    
    // TODO: - 사용자 피드백 처리(RemoteStorage에 전송)
    func sendUserFeedback(_ feedback: UserFeedback) {
        
    }
}
