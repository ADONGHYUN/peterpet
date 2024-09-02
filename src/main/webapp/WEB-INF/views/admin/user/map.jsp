<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>오시는 길</title>

    <style>
    .info-window {
        padding: 10px;
        text-align: center; /* 가운데 정렬 */
        border: 0; /* 테두리 제거 */
        background: transparent; /* 배경 제거 */
        font-size: 14px;
        line-height: 1.5;
        box-shadow: none; /* 그림자 제거 */
    }
    .button-container {
        margin-top: 20px;
    }
    .button-container button {
        padding: 10px 20px;
        font-size: 16px;
        margin-right: 10px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        transition: background-color 0.3s;
        color: white; /* 글자 색상 흰색으로 유지 */
    }
    .button-container button:hover {
        background-color: #444; /* 버튼에 마우스 올렸을 때 어두운 회색 */
    }
    .view-map-button {
        background-color: #000000; /* 검정색 */
    }
    .get-directions-button {
        background-color: #000000; /* 검정색 */
    }
</style>
</head>
<body>
    <%@ include file="/WEB-INF/views/module/c_header.jsp"%>

    <!-- Kakao Maps API를 한 번만 포함 -->
    <script type="text/javascript" src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=4bfd91f6398036f61a0aa47a06c6908e"></script>
    
    <br/>
    <h5 style="margin: 0;">오시는 길</h5>
    <hr>
    <br/>

    <div id="map" style="width:900px;height:400px;"></div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // 지도 설정
            var container = document.getElementById('map');
            var options = {
                center: new kakao.maps.LatLng(37.57200615777235, 126.98715198037605), // 지도 중심 좌표
                level: 3 // 확대 레벨
            };

            var map = new kakao.maps.Map(container, options);
            
            // 마커 위치
            var markerPosition = new kakao.maps.LatLng(37.57200615777235, 126.98715198037605); 

            // 마커 생성
            var marker = new kakao.maps.Marker({
                position: markerPosition
            });

            // 마커를 지도에 표시
            marker.setMap(map);

            // 정보 창 설정
            var infowindow = new kakao.maps.InfoWindow({
                content: '<div class="info-window">peterpet</div>', // 정보 창 내용
                removable: false // 닫기 버튼 비활성화
            });

            // 마커에 마우스를 올렸을 때 정보 창 표시
            kakao.maps.event.addListener(marker, 'mouseover', function() {
                infowindow.open(map, marker);
            });

            // 마커에서 마우스를 뗐을 때 정보 창 숨기기
            kakao.maps.event.addListener(marker, 'mouseout', function() {
                infowindow.close();
            });

           

            // 클러스터러 설정 (클러스터링이 필요한 경우 주석 해제)
            var clusterer = new kakao.maps.MarkerClusterer({
                map: map,
                markers: [marker], // 마커 배열에 마커 추가
                gridSize: 35,
                averageCenter: true,
                minLevel: 6,
                disableClickZoom: true,
                styles: [{
                    width: '53px', height: '52px',
                    background: 'url(cluster.png) no-repeat',
                    color: '#fff',
                    textAlign: 'center',
                    lineHeight: '54px'
                }]
            });
        });

        function openMap() {
            var url = 'https://map.kakao.com/link/map/peterpet,37.57200615777235,126.98715198037605';
            window.open(url, '_blank');
        }

        function getDirections() {
            var url = 'https://map.kakao.com/link/to/peterpet,37.57200615777235,126.98715198037605';
            window.open(url, '_blank');
        }
    </script>
    
    <br/>
    <h3>peterpet</h3>     
    <h5>서울 종로구 인사동길 12, 대일빌딩 7층 및 15층</h5>
    
    <div class="button-container">
        <button class="view-map-button" onclick="openMap()">지도로 보기</button>
        <button class="get-directions-button" onclick="getDirections()">길찾기</button>
    </div>
     <br/>
     <hr>
     
    이용시간: 평일 07:30 ~ 21:00 (픽업마감 : 20:30입니다) 주말 09:00 ~ 21:00 (픽업마감 : 20:30입니다)
     <br/>
     <hr>
     전화번호 : 0000000000
     <br/>
     <hr>
주차 : 무료이용 1시간
 <hr>
<br/>
    <jsp:include page="/WEB-INF/views/module/footer.jsp" />
</body>
</html>
