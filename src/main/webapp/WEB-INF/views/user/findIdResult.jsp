<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>아이디 찾기</title>
</head>
<body>
	<%@ include file="/WEB-INF/views/module/c_header.jsp"%>

	<div class="container px-5 pt-5 pb-3 my-5 border text-center">
		<h3>아이디 찾기 결과</h3><hr>
		<table class="table">
			<tr>
				<td><h4>${userList.uemail}로 가입된 아이디입니다.</h4></td>
			</tr>
				<tr>
					<td>${userList.uid}</td>
				</tr>
		</table>
		<a href="findPw">비밀번호 찾기</a>
	</div>

	<%@ include file="/WEB-INF/views/module/footer.jsp"%>
</body>
</html>