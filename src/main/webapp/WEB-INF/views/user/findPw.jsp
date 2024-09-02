<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>비밀번호 찾기</title>

<style type="text/css">
label, td {
	white-space: nowrap;
	vertical-align: middle;
}

p {
	color: grey;
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
			<li class="nav-item col-6"><a class="nav-link text-center"
				href="findId">아이디 찾기</a></li>
			<li class="nav-item col-6"><a
				class="nav-link active text-center" href="#">비밀번호 찾기</a></li>
		</ul>
		<br>
		<div>
			<p class="mb-0">비밀번호의 경우 암호화 저장되어 분실 시 찾아드릴 수 없는 정보 입니다.</p>
			<p>본인 확인을 통해 비밀번호를 재설정 하실 수 있습니다.</p>
		</div>
		<hr>
		<form action="" id="idForm">
			<table class="table-borderless">
				<tr>
					<td><label for="uid">아이디를 입력해주세요.</label> <input type="text"
						id="uid" name="uid" class="form-control"> 
						<label for="uemail" class="d-none d-md-block">가입할 때 사용한 이메일을 입력해주세요.</label> 
						<label for="uemail" class="d-md-none">찾을 계정 이메일을 입력해주세요.</label>
						<div class="input-group">
							<input type="email" id="uemail" name="uemail"
								class="form-control"> <input type="submit"
								value="인증번호 발송" class="btn btn-primary form-button-input">
						</div></td>
				</tr>
			</table>
		</form>
		<form action="findPw" method="post" id="codeForm">
			<table>
				<tr>
					<td><label for="code">전송받은 인증번호를 기입해주세요.</label><br>
						<div class="input-group">
							<input type="text" id="code" name="code" class="form-control">
							<input type="submit" value="비밀번호 찾기"
								class="btn btn-primary form-button-input">
						</div></td>
				</tr>
			</table>
		</form>
		<form action="findPwResult" method="post" id="resultForm">
			<table>
				<tr>
					<td><input type="hidden" id="result" name="uid"></td>
				</tr>
			</table>
		</form>
	</div>
	<%@ include file="/WEB-INF/views/module/footer.jsp"%>
	<script type="text/javascript">
	console.log(typeof $);
	console.log("123");
		let conf = '';
		let cid = '';
		let chid='';
		let chidf='';
		
		$('#uid').on('input', function() {
	       	let uid = $(this).val();
	       	//console.log(uid);
	       	let msg = '';
	       	chid='';
			chidf='';
	       	if (uid == '') {
	       	    msg = '';
	       	}
	       	else if (/[가-힣]/.test(uid)) {
	       	    
	       	}
	       	// 문자열 길이 체크 (6~12자리)
	       	else if (uid.length < 6 || uid.length > 12) {
	       	    
	       	}
	       	// 영문을 1자리 이상 포함하는지 체크
	       	else if (!/(?=.*[A-Za-z])/.test(uid)) {
	       	    
	       	}
	       	// 영문과 숫자만 포함하는지 체크
	       	else if (!/^[A-Za-z0-9]+$/.test(uid)) {
	       	    
	       	} else {
	       	    
	       	 	chidf='ok';
	       	}
	    });
		
		$("#idForm").submit(function(event) {
			event.preventDefault();
			let uid = $('#uid').val();
			let uemail = $('#uemail').val();
			if (uid == '') {
				alert('아이디를 입력해주세요.');
			} else if(chidf==''){
				alert('잘못된 아이디입니다.');
				$('#uid').focus();
			} else if(uemail==''){
				alert('이메일 주소를 입력해주세요.');
				$('#uemail').focus();
			} else {
				console.log(uid);

				$.ajax({
					url : 'findGetFid',
					type : 'post',
					data : {
						uid : uid,
						uemail, uemail
					},
					success : function(data) {
						console.log('Received data:', data);
						if (data == 'yes') {
							alert('인증번호가 발송되었습니다. 인증번호의 유효시간은 10분입니다.');
							$('#code').focus();
							conf = '1';
							cid = uid;
						} else if (data == 'yesb') {
							//alert('인증번호 발송 but 인증번호 저장 실패.');
							alert('인증번호 발급 과정에서 오류가 발생했습니다. 다시 발급해주세요.');
							conf = '';
						} else if (data == 'no') {
							alert('가입되지 않은 회원입니다.');
							$('#uid').val('');
							conf = '';
						} else if (data == 'nmail') {
							//alert('인증번호 발송 but 인증번호 저장 실패.');
							alert('메일이 일치하지 않습니다.');
							conf = '';
						} else {
							alert('예상치 못한 에러 발생.');
							conf = '';
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
			let uid = cid;
			console.log(conf);
			console.log(uid);
			if (conf == '') {
				alert('인증번호를 발급받아주세요.');
			} else if (mailcode == '') {
				alert('인증번호를 입력해주세요.');
			} else {
				$.ajax({
					url : 'findPw',
					type : 'post',
					contentType : 'application/json',
					data : JSON.stringify({
						uid : uid,
						mailcode : mailcode
					}),
					success : function(data) {
						console.log('Received data:', data);
						if (data == 'yes') {
							alert('인증 성공.');
							
							$('#result').val(uid);
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