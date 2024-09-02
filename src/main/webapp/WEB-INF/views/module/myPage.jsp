<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">


<title>PeterPet</title>
</head>
<body>
	<%@ include file="/WEB-INF/views/module/c_header.jsp"%>
	<div class="container-fluid container-expand-sm mt-5">
		<div class="row">
			<div class="col-sm-2"></div>
			<div class="col-sm-8">
				<ul class="nav nav-tabs justify-content-center" id="tabs">
					<li class="nav-item"><input type="button"
						class="nav-link active text" id="myInfo" data-toggle="tab"
						value="내 정보"></li>
					<li class="nav-item"><input type="button"
						class="nav-link text" id="myReserve" data-toggle="tab" value="예약"></li>
					<li class="nav-item"><input type="button"
						class="nav-link text" id="myReview" data-toggle="tab" value="결제"></li>
				</ul>
				<div class="mb-5" id="includeFilePath"></div>
			</div>
			<div class="col-sm-1"></div>
		</div>
	</div>
	<%@include file="/WEB-INF/views/module/footer.jsp"%>
	<script>
	document.addEventListener("DOMContentLoaded", function () {
	    // 탭 버튼들을 변수로 가져옵니다.
	    const tabs = document.querySelectorAll("#tabs input");

	    // 각 탭 클릭 이벤트에 대한 리스너를 설정합니다.
	    tabs.forEach(tab => {
	        tab.addEventListener("click", function () {
	            // 클릭된 탭에서 id를 가져옵니다.
	            const tabId = this.id;

	            // 모든 탭의 active 클래스를 제거하고 클릭된 탭에만 추가합니다.
	            tabs.forEach(t => t.classList.remove("active"));
	            this.classList.add("active");

	            // 탭 id에 따라 로드할 파일 경로를 결정합니다.
	            let pagePath = "";
	            if (tabId === "myInfo") {
	                pagePath = "/user/myInfo";
	            } else if (tabId === "myReserve") {
	                pagePath = "/user/findId";
	            } else if (tabId === "myReview") {
	                pagePath = "/user/findPw";
	            }

	            // AJAX를 통해 해당 페이지의 데이터를 가져옵니다.
	            loadPage(pagePath);
	        });
	    });

	    // 페이지 로드 함수
	    function loadPage(pagePath) {
	        const includeFilePath = document.getElementById("includeFilePath");

	        // 서버로부터 페이지 데이터를 가져와서 includeFilePath div에 로드합니다.
	        fetch(pagePath)
	            .then(response => response.text())
	            .then(data => {
	                includeFilePath.innerHTML = data;

	                includeFilePath.querySelectorAll("script").forEach(script => {
	                    const newScript = document.createElement("script");
	                    if (script.src) {
	                        newScript.src = script.src;
	                    } else {
	                        newScript.textContent = script.textContent;
	                    }
	                    document.head.appendChild(newScript);
	                });
	            })
	            .catch(error => console.error("Error loading page:", error));
	    }

	    // 초기 탭 설정 (첫 번째 탭 페이지 로드)
	    loadPage("/user/myInfo");
	});
	
    

	</script>
</body></html>
