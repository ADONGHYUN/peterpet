<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>비밀번호 변경 - PeterPet</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="/resources/script/password.js"></script>
<style>
    .form-container {
        max-width: 500px;
        margin: 30px auto;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        background-color: #f8f9fa;
    }
    .form-container h2 {
        margin-bottom: 20px;
    }
    .form-group {
        margin-bottom: 15px;
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
</style>
</head>
<body>
	 <div class="container d-flex justify-content-center align-items-center min-vh-100">
        <div class="form-container">
            <h2 class="text-center">비밀번호 변경</h2>
            <form id="changePasswordForm">
                <input type="hidden" id="uid" name="uid" value="${userId}" required>

                <div class="form-group">
                    <label for="upw">현재 비밀번호</label>
                    <input id="upw" name="upw" type="password" class="form-control" required>
                </div>

                <div class="form-group">
                    <label for="npw">새 비밀번호</label>
                    <input id="npw" name="npw" type="password" class="form-control" maxlength="20" minlength="8" pattern="^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,20}$" required>
                    <small class="form-text text-muted">비밀번호는 숫자, 영문, 특문을 포함한 8~20자리로 입력해 주세요.</small>
                    <div id="npwmsg" class="form-text"></div> 
                </div>
                
                <div class="form-group">
                    <label for="npw2">새 비밀번호 확인</label>
                    <input id="npw2" name="npw2" type="password" class="form-control" maxlength="20" pattern="^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,20}$" required>
                    <div id="pwmsg2" class="form-text"></div> <!-- 비밀번호 확인 유효성 메시지 -->
                </div>

                <div class="form-group text-center">
                    <button type="button" id="submitChange" class="btn btn-custom">수정</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
