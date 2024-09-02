<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>계정 탈퇴</title>
<!-- Bootstrap CSS 링크 -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="/resources/script/deleteAccount.js"></script>
<style>
body {
	background-color: #f8f9fa;
}

.form-container {
	max-width: 790px; /* 가로 크기를 늘림 */
	margin: 20px auto;
	padding: 20px;
	border-radius: 8px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	background-color: #ffffff;
}

.text-nowrap {
	white-space: nowrap;
	overflow-x: auto; /* 필요 시 가로 스크롤 추가 */
}

.form-container h2 {
	margin-bottom: 15px;
}

.form-group {
	margin-bottom: 15px;
}

.form-group label {
	font-weight: bold;
}

.form-group input {
	width: 100%;
}

.form-group input[type="password"] {
	border: 1px solid #ced4da;
	border-radius: 4px;
	padding: 10px;
}

.form-group input:focus {
	border-color: #80bdff;
	outline: none;
	box-shadow: 0 0 0 0.2rem rgba(38, 143, 255, 0.25);
}

.btn-custom {
	background-color: #007bff;
	color: white;
	border: none;
}

.btn-custom:hover {
	background-color: #0056b3;
}

.form-check {
	margin-bottom: 15px;
	word-break: break-word; /* 긴 문장을 한 줄로 표시 */
}

.form-check input {
	margin-right: 10px;
}

#pwmsg2 {
	font-size: 0.875rem;
	color: #dc3545;
}
</style>

</head>
<body>
	<div
		class="container d-flex justify-content-center align-items-center min-vh-100">
		<div class="form-container">
			<h2 class="text-center">계정 탈퇴</h2>
			<p class="text-center text-muted mb-4 text-nowrap">먼저 회원탈퇴를
				진행하시려는 고객님께 좋은 서비스를 제공하지 못해 대단히 죄송합니다.<br>탈퇴를 진행하시려면 약관에 동의해주셔야 합니다.</p>
			<ol class="text-muted mb-4 text-nowrap">
				<li>탈퇴를 하실 경우 연동된 SNS계정도 모두 연동 해제 됩니다.</li>
				<li>결제완료하신 제품중 결제취소를 하지 않고 탈퇴를 하실 경우 주문하신 물품은 정상배송됩니다.</li>
				<li>돌봄 서비스를 예약하신 경우, 결제하신 예약금은 환불이 불가능합니다.</li>
				<li>계정을 탈퇴하시면 모든 회원정보가 삭제되며, 절대 복구할 수 없습니다.</li>
				<li>회원 탈퇴 이후에 발생하는 회원님의 불이익에 대해 PeterPet은 책임지지 않습니다.</li>
			</ol>

			<form id="deleteForm">
				<input type="hidden" id="uid" name="uid" value="${userId}" required>

				<div class="form-check">
					<input type="checkbox" class="form-check-input" id="agreeTerms"
						required> <label class="form-check-label" for="agreeTerms">
						탈퇴 약관을 모두 확인하였으며 모든 내용에 동의 합니다. </label>
				</div>

				<div class="form-group">
					<label for="upw">비밀번호</label> <input id="upw" name="upw"
						type="password" class="form-control" required>
						<div id="pwmsg"></div>
				</div>

				<div class="form-group text-center">
					<button type="button" id="delete" class="btn btn-custom">탈퇴</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>
