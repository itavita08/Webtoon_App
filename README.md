# 📗 Webtoon Mobile App

✔️ **프로젝트 명** 
   
네이버 웹툰 API를 이용해 모바일 어플 만들기
   
✔️ **프로젝트 기간**

2023.03.23 ~ 2023.03.29
   
✔️ **프로젝트 주요 기능**
   
- 🔔 웹툰 서비스
  - 오늘의 인기 웹툰 목록 조회
  - 웹툰 상세 정보 조회
  - 웹툰 최신 에피소드 목록 조회
  - 에피소드 별 이미지 스크롤 및 조회
  - 회차 url 연동으로 네이버 웹툰 해당 회차로 이동 가능
- 🔮 로그인 서비스
  - 로그인 및 회원가입 기능
   
✔️ **개발 스택 및 사용 TOOL**   
   
- **Front**   
   
<img src="https://img.shields.io/badge/Flutter-02569B?style=flat&logo=Flutter&logoColor=white"> <img src="https://img.shields.io/badge/Dart-0175C2?style=flat&logo=Dart&logoColor=white">
   
- **Back**
   
<img src="https://img.shields.io/badge/Node.js-339933?style=flat&logo=Node.js&logoColor=white"> <img src="https://img.shields.io/badge/JWT-000000?style=flat&logo=JSON Web Tokens&logoColor=white"> <img src="https://img.shields.io/badge/REST API-5A29E4?style=flat&logo=REST API&logoColor=white"> 
   
- **DB**
   
<img src="https://img.shields.io/badge/MySQL-4479A1?style=flat&logo=MySQL&logoColor=white">
   
- **IDE**
   
<img src="https://img.shields.io/badge/Visual Studio Code-007ACC?style=flat&logo=Visual Studio Code&logoColor=white"> <img src="https://img.shields.io/badge/iOS Simulator-000000?style=flat&logo=iOS&logoColor=white"> <img src="https://img.shields.io/badge/Postman-FF6C37?style=flat&logo=Postman&logoColor=white">
   
✔️ **기술 구현 결과**
   
  - Front
    - `Stateless`와 `Stateful` 사용으로 비동기 동기 구현
    - `Flutter-Secure-Storage` 사용으로 `Acess Token`과 `Refresh Token`을 안전하게 저장
    - 서버와의 통신을 위해 `http`대신 `dio` 라이브러리 사용
    - `dio.interceptor` 사용으로 서버에 요청을 보낼 때마다 `Access Token`을 헤더에 담아 요청을 보내도록 구현
    - `Access Token`가 만료일 때, `Refresh Token`을 Post방식으로 서버에 보내 새로운 토큰을 발급 받을 수 있도록 
    - `Authorization Bearer`로 `Access Token` 전송
    
  - Back
    - `Middlewares`사용으로 응답 함수를 실행 시키기 전 `Access Token`확인
    - 서비스 기능에 필요한 `Rest API` 구현
    - `Refresh Token`을 DB에 저장하고 `Http Only Secure`방식으로 클라이언트에게 전송
    - HTTP 상태 코드 exception 처리
    - Front 과 `JSON` 포맷 데이터 통신
    - `MVC`패턴 적용
    - DB연결의 오버헤드를 줄이기 위해 `pool`사용
    - `bcrypt` 사용으로 비밀번호 암호화
    
 ✔️ **기능 구현 영상**
 - 회원가입
 <p align='center'>
 <img src=https://user-images.githubusercontent.com/105635205/228582166-eb173225-d456-447b-93f2-8a041c025963.gif height="500">
 </p><br />
 
 - 로그인
 <p align='center'>
 <img src=https://user-images.githubusercontent.com/105635205/228582899-c8538324-9a10-40df-ae41-676bcf4d01f8.gif height="500">
 </p><br />
 
 - 오늘의 웹툰
 <p align='center'>
 <img src=https://user-images.githubusercontent.com/105635205/228583108-ab241e99-75e1-4b51-b8f5-15726bda76f6.gif height="500">
 </p><br />
 
 - 회차
 <p align='center'>
 <img src=https://user-images.githubusercontent.com/105635205/228583235-deae9441-996f-434f-9860-c655931665ad.gif height="500">
 </p><br />

 


 


