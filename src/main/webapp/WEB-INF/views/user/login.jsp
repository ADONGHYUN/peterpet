<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>PeterPet-Login</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
#text {
	font-size: 42px;
	font-weight: bold;
}

#logoBack {
	text-decoration-line: none;
	color: white;
}

#logoBack:hover {
	color: white;
}

.background {
	background-color: #3D2922;
	opacity: 97%;
}

.login-logo {
	width: 100px; /* 최대 너비 설정 (로그인 버튼과 동일하게) */
	height: 40px;
	margin: 3px;
	cursor: pointer;
}

.login-logos-container {
	display: inline;
}

.find {
	padding:0px 7px !important;
}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/views/module/c_header.jsp"%>

	<div class="container mt-4 mb-3">
		<div class="mt-5">
			<h2 class="text-center" style="font-weight: bold;">로 그 인</h2>
			<form id="loginForm">
				<div class="mt-4">
					<div class="row">
						<div class="col-sm-4"></div>
						<div class="col-sm-4">
							<label for="uid">아이디</label>
						</div>
						<div class="col-sm-4"></div>
					</div>
					<div class="row mb-3">
						<div class="col-sm-4"></div>
						<div class="col-sm-4" style="padding: 0 5px;">
							<input type="text" class="form-control" id="uid" name="uid">
						</div>
						<div class="col-sm-4"></div>
					</div>
					<div class="row">
						<div class="col-sm-4"></div>
						<div class="col-sm-4">
							<label for="upw">비밀번호</label>
						</div>
					</div>
					<div class="row mb-2">
						<div class="col-sm-4"></div>
						<div class="col-sm-4" style="padding: 0 5px;">
							<input type="password" class="form-control" id="upw" name="upw">
						</div>
					</div>

					<div class="row mt-5">
						<div class="col-sm-4"></div>
						<div class="col-sm-4 text-center logocon">
							<div class="login-logos-container col-6 text-center">
								<img id="kakao"
									src="<%=request.getContextPath()%>/resources/logo/kakao_login.png"
									title="카카오로그인" alt="카카오 계정으로 로그인 할 수 있는 이미지입니다."
									class="login-logo" />
							</div>
							<div class="login-logos-container col-6 text-center">
								<img id="naver"
									src="<%=request.getContextPath()%>/resources/logo/naver_login.png"
									title="네이버로그인" alt="네이버 계정으로 로그인 할 수 있는 이미지입니다."
									class="login-logo" />
							</div>
						</div>
						<div class="col-sm-4"></div>
					</div>

					<div class="row mt-5">
						<div class="col-sm-4"></div>
						<div class="col-sm-4 d-flex justify-content-center"
							style="padding: 0 5px;">
							<input id="login" type="button" class="btn btn-dark"
								style="width: 95%;" value="로그인">
						</div>
					</div>
					<div class="row mt-1">
						<div class="col-sm-4"></div>
						<div class="col-sm-4 d-flex justify-content-center"
							style="padding: 0 5px;">
							<a class="nav-link justify-content-center" href="user/join"
								style="width: 95%;"> <input type="button"
								class="btn btn-dark" style="width: 100%;" value="회원가입">
							</a>
						</div>
						<div class="col-sm-4"></div>
					</div>
					<!-- 아이디/비밀번호 찾기 링크 추가 -->
					<div class="row mt-1">
						<div class="col-sm-4"></div>
						<div class="col-sm-4 d-flex justify-content-center"
							style="padding: 0 5px;">
							<a class="nav-link justify-content-center" href="user/findId"
								style="width: 95%;"> <input type="button"
								class="btn btn-dark" style="width: 100%;" value="ID/비밀번호 찾기">
							</a>
						</div>
						<div class="col-sm-4"></div>
					</div>
				</div>
			</form>
		</div>
	</div>
	<%@ include file="/WEB-INF/views/module/footer.jsp"%>

</body>
<script type="text/javascript" src="/resources/script/login.js"></script>
</html>
