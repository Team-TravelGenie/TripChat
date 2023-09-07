//
//  PopUpViewModel.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/26.
//

import Foundation

final class PopUpViewModel {
    
    private let selectedTags: [Tag]
    private let recommendationItem: [RecommendationItem]
    private let userFeedbackUseCase: UserFeedbackUseCase
    
    init(
        selectedTags: [Tag],
        recommendationItem: [RecommendationItem],
        userFeedbackUseCase: UserFeedbackUseCase
    ) {
        self.selectedTags = selectedTags
        self.recommendationItem = recommendationItem
        self.userFeedbackUseCase = userFeedbackUseCase
    }
    
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
    
    func sendUserFeedback(isPositive: Bool, content: String) {
        let tagValues: [String] = selectedTags.map { $0.value }
        let recommendationValues: [String] = recommendationItem.map { $0.spot }
        let userFeedback = UserFeedback(
            isPositive: isPositive,
            content: content,
            selectedTags: tagValues,
            recommendations: recommendationValues)
        userFeedbackUseCase.save(userFeedback: userFeedback) { error in
                // TODO: - 에러 처리
            }
    }
}
