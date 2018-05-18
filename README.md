# ClickStream_Competition

 * 인터넷 이용자가 1년간 웹사이트 접속한기록(ClickStream Data)와 검색엔진(Search Data)를 분석하여 이용자의 성별(M/F)를 예측
  
 * 하지만 ClickStream Data만을 이용하여 정량 분석 하였음
  - 앞으로 나오는 그림들은 예제 데이터를 이용하였다 실제 대분류 이름은 (A,B,C,D)가 아니라 22개의 Category목록에 해당함
  
![clickstream_raw](https://user-images.githubusercontent.com/21652564/40236192-acd81cf0-5ae7-11e8-9e94-223feb3fe620.jpg)

 1. CUS_ID : 고객 아이디
 2. TIME_ID: 사이트에 접속한 시간 (형식: yyyymmddhh)
 3. SITE: 접속한 사이트 URL
 4. SITE_CNT: 해당 시간에 사이트에 접속한 횟수
 5. SITE_TIME: 해당 시간에 사이트에 접속하여 머문 기간(초 단위)
 6. SITE_NAME: 접속한 사이트명 (총 28,876개)
 7. BACT_NM: 접속한 사이트의 대분류 이름 (총 22개)
 8. MACT_NM: 접속한 사이트의 중분류 이름 (총 207개)
 9. ACT_NM: 접속한 사이트의 소분류 이름 (총 1,216개)
  * GENDER: 고객의 성별

## PreProcessing
 
  - month(월)
  
  + week(요일)
 
  * hour(시간) ->  hours (시간의 구간)
  
![clistr_1st](https://user-images.githubusercontent.com/21652564/40237059-49214206-5aea-11e8-8b95-9194dca530ae.png)
  
### dummy화
  
 + 접속사이트 대분류(BACT_NM)별 클릭횟수
 + WEEK별 클릭횟수
 + MONTH별 클릭횟수
 + Hours별 클릭횟수
 + 각 변수별 CV(변동계수)변수 생성

![prepro2_1](https://user-images.githubusercontent.com/21652564/40238132-4900021e-5aed-11e8-8c1c-92a05528d9b2.jpg)
![prepro2_2](https://user-images.githubusercontent.com/21652564/40238148-54f8b5a2-5aed-11e8-87dd-758400ebb3c4.jpg)

## Model Compare
  - LogitBoost
  - PCA_LogitBoost
  - svmRadialSigma
  - PCA_svmRadialSigma
  - C5.0
  - svmLinear
  - svmPoly
