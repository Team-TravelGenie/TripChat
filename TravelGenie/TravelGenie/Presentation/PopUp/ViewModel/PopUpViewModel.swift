//
//  PopUpViewModel.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/26.
//

/*
 1. PopUpVC에서 PopUpView 분리
 2. PopUpView의 case 정리 (enum, associatedvalue)
 3. PopUpVCDelegate = ChatVC(PopUpVC를 띄운 애 -> dismiss해야 하니까)
 4. PopUpViewDelegate = PopUpVC(역할: 팝업뷰의 액션. 네/아니오, 제출하기/싫어요)
 예시: '네'눌렀을 때 PopUpView 변경 또는 겹쳐서 새로운 거 띄워주기
 5. PopUpModel = PopUpView에 들어갈 콘텐트. 얘는 PopUpVC를 띄워주는 뷰컨(뷰모델)에서 생성해서 주입
 */

import Foundation

final class PopUpViewModel {
}
