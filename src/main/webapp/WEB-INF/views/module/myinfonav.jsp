<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<div class="row">
    <div class="col-sm-2"></div>
    <div class="col-sm-8">
        <ul class="nav nav-tabs justify-content-center" id="tabs">
            <li class="nav-item">
                <button type="button" class="nav-link text" id="myInfo" data-toggle="tab" onclick="navigate('/user/myInfo')">내 정보</button>
            </li>
            <li class="nav-item">
                <button type="button" class="nav-link text" id="myReserve" data-toggle="tab" onclick="navigate('/res/resList/page/1')">예약</button>
            </li>
            <li class="nav-item">
                <button type="button" class="nav-link text" id="myReview" data-toggle="tab" onclick="navigate('/pay/mypaylist')">결제</button>
            </li>
        </ul>
        <div class="mb-5" id="includeFilePath"></div>
    </div>
    <div class="col-sm-1"></div>
</div>

<script>
$(document).ready(function() {
    // 현재 URL을 가져옴
    var currentUrl = window.location.pathname;

    // URL에 따라 active 클래스를 추가할 요소를 결정
    if (currentUrl.includes('/user/myInfo')) {
        $('#myInfo').addClass('active');
    } else if (currentUrl.includes('/res/resList/page/1')) {
        $('#myReserve').addClass('active');
    } else if (currentUrl.includes('/pay/mypaylist')) {
        $('#myReview').addClass('active');
    }
});

function navigate(url) {
    window.location.href = url;
}
</script>
</body>
</html>
