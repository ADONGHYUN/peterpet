<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>아이디 찾기</title>

<style type="text/css">
label, td {
	white-space: nowrap;
	vertical-align: middle;
}

table {
	width: 100%;
}
</style>
</head>
<body>
<%@ include file = "/WEB-INF/views/module/c_header.jsp" %>
	<div class="container p-5 my-5 border box1">

		<ul class="nav nav-tabs">
			<li class="nav-item col-6"><a
				class="nav-link active text-center" href="#">아이디 찾기</a></li>
			<li class="nav-item col-6"><a class="nav-link text-center"
				href="findPw">비밀번호 찾기</a></li>
		</ul>
		<br>
		<form action="" id="mailForm">
			<table>
				<tr>
					<td><label for="uemail" class="d-none d-md-block">가입할 때 사용했던 메일주소를 입력해주세요.</label> 
						<label for="uemail" class="d-md-none">메일주소를 입력해주세요.</label>
						<div class="input-group">
							<input type="email" id="uemail" name="uemail"
								class="form-control"> <input type="submit"
								value="인증번호 발송" class="btn btn-primary form-button-input">
						</div></td>
				</tr>
			</table>
		</form>
		<form action="findId" method="post" id="codeForm">
			<table>
				<tr>
					<td><label for="code">전송받은 인증번호를 기입해주세요.</label><br>
						<div class="input-group">
						<input type="text" id="code" name="code" class="form-control">
						<input type="submit" value=" 아이디 찾기  " class="btn btn-primary form-button-input"></div></td>
				</tr>
			</table>
		</form>
		<form action="findIdResult" method="post" id="resultForm">
			<table>
				<tr>
					<td><input type="hidden" id="result" name="uemail"></td>
				</tr>
			</table>
		</form>
	</div>
	<%@ include file="/WEB-INF/views/module/footer.jsp"%>
	<script type="text/javascript">
	console.log(typeof $);
	console.log("123");
		let conf = '';
		let cemail = '';
		$("#mailForm").submit(function(event) {
			event.preventDefault();
			let uemail = $('#uemail').val();
			if (uemail == '') {
				alert('이메일 주소를 입력해주세요.');
			} else {
				console.log(uemail);

				$.ajax({
					url : 'findGetMail',
					type : 'post',
					data : {
						uemail : uemail
					},
					success : function(data) {
						console.log('Received data:', data);
						if (data == 'api') {
							alert('소셜 가입 회원입니다. 소셜 로그인으로 로그인 해주세요.');
							location.href = '/login';
						} else if (data == 'yes') {
							alert('인증번호가 발송되었습니다. 인증번호의 유효시간은 10분입니다.');
							$('#code').focus();
							conf = '1';
							cemail = uemail;
						} else if (data == 'yesb') {
							//alert('인증번호 발송 but 인증번호 저장 실패.');
							alert('인증번호 발급 과정에서 오류가 발생했습니다. 다시 발급해주세요.');
							conf = '';
							cemail = '';
						} else if (data == 'no') {
							alert('가입되지 않은 이메일입니다.');
							$('#uemail').val('');
							conf = '';
							cemail = '';
						} else {
							alert('예상치 못한 에러 발생.');
							conf = '';
							cemail = '';
						}
					},
					error : function(xhr, status, error) {
						console.error('AJAX request failed: ', status, error);
					}
				});
			}
		});

		$("#codeForm").submit(function(event) {
			event.preventDefault();
			let mailcode = $('#code').val();
			let uemail = cemail;
			console.log(conf);
			console.log(uemail);
			if (conf == '') {
				alert('인증번호를 발급받아주세요.');
			} else if (mailcode == '') {
				alert('인증번호를 입력해주세요.');
			} else {
				$.ajax({
					url : 'findId',
					type : 'post',
					contentType : 'application/json',
					data : JSON.stringify({
						uemail : uemail,
						mailcode : mailcode
					}),
					success : function(data) {
						console.log('Received data:', data);
						if (data == 'yes') {
							alert('인증이 완료되었습니다.');
							$('#result').val(uemail);
							console.log($('#result').val());

							$('#resultForm').submit();

						} else if (data == 'no') {
							alert('인증번호가 일치하지 않습니다.');
						} else if (data == 'exp') {
							alert('인증번호가 만료되었습니다. 다시 발급해주세요.');
							$('#code').val('');
						} else {
							alert('예상치 못한 에러.');
						}
					},
					error : function(xhr, status, error) {
						console.error('AJAX request failed: ', status, error);
					}
				});
			}
		});
	</script>
</body>
</html>