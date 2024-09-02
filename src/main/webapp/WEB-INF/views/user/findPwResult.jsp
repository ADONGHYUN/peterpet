<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>비밀번호 찾기</title>
<style type="text/css">
label,td{
	white-space: nowrap;
	vertical-align: middle;
}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/views/module/c_header.jsp"%>

	<div class="container p-5 my-5 border">
		<h4> ${uid}님 비밀번호 변경</h4>
		<form action="" method="post" id="cngPwForm">
		<div class="row">
		<hr>
			<table class="table">
				<tr>
					<td class="col-4"><label for="upw">새 비밀번호</label></td>
					<td class="col-8"><input id="upw" class="form-control" name="upw"
						type="password" maxlength="20" minlength="8"
						placeholder="비밀번호는 영문,숫자,특수문자(@#^$!%*?&) 조합으로 8~20자리를 입력해주세요."
						pattern="^(?=.*[A-Za-z])(?=.*\d)(?=.*[@#^$!%*?&])[A-Za-z\d@#^$!%*?&]+$"
						required>
						<div id="pwmsg"></div></td>
				</tr>
				<tr>
					<td class="col-4"><label for="upw2">새 비밀번호확인</label></td>
					<td class="col-8"><input id="upw2" class="form-control" name="upw2"
						type="password" maxlength="20" placeholder="비밀번호를 다시 한 번 입력해주세요."
						required>
						<div id="pwmsg2"></div></td>
				</tr>
			</table>
			</div>
			<input type="submit" value="수정" class="btn btn-primary">
			<button type="button" class="btn btn-secondary" onclick="formReset()">리셋</button> 
		</form>
	</div>

	<%@ include file="/WEB-INF/views/module/footer.jsp"%>
<script type="text/javascript">

function formReset(){
	document.getElementById('cngPwForm').reset();
	$('#idmsg').text('');
	$('#pwmsg').text('');
	$('#pwmsg2').text('');
}

		$('#upw').on('input', function() {
	       	let upw = $(this).val();
	       	let upw2 = $('#upw2').val();
	       	//console.log(upw);
	       	let msg = '';
	       	let msg2 = '';

	       	let type = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@#^$!%*?&])[A-Za-z\d@#^$!%*?&]+$/;
	       	
	       	if(upw == ''){
	       		msg = '';
	       	 	$("#pwmsg").css("color", "black");
	       	}else if (upw.length < 8 || upw.length > 20) {
	            msg = "8자 이상을 입력해주세요.";
	            $("#pwmsg").css("color", "red");
	        }else if (!type.test(upw)) {
	            msg = "영문과 숫자, 특수문자를 하나 이상 포함해야 합니다.";
	            $("#pwmsg").css("color", "red");
	        }else{
	        	msg = "올바른 형식입니다.";
	        	$("#pwmsg").css("color", "green");
	        }
	        $('#pwmsg').text(msg);
	        
	        if(upw2 == ''){
	       		msg = '';
	       	}else if(upw != upw2){
	       		msg = '비밀번호가 일치하지 않습니다.';
	       		$("#pwmsg2").css("color", "red");
	       		chpw = '';
	       	}else{
	        	msg = "비밀번호가 일치합니다.";
	        	$("#pwmsg2").css("color", "green");
	        	chpw = 'yes';
	        }
	        $('#pwmsg2').text(msg);
	    });
		
		$('#upw2').on('input', function() {
			let upw1 = $('#upw').val();
	       	let upw2 = $(this).val();
	       	//console.log(upw1);
	       	//console.log(upw2);
	       	let msg = '';
	       		
	       	if(upw2 == ''){
	       		msg = '';
	       	}else if(upw1 != upw2){
	       		msg = '비밀번호가 일치하지 않습니다.';
	       		$("#pwmsg2").css("color", "red");
	       		chpw = '';
	       	}else{
	        	msg = "비밀번호가 일치합니다.";
	        	$("#pwmsg2").css("color", "green");
	        	chpw = 'yes';
	        }
	        $('#pwmsg2').text(msg);
	    });
		
		let chpw='';
		
		$("#cngPwForm").submit(function(event) {
	        event.preventDefault();
	        console.log(chpw);
	        let uid = '${uid}';
	        let upw = $('#upw').val();
	        let upw2 = $('#upw2').val();
	        if(upw2 == ''){
	        	alert('비밀번호 확인란을 입력해주세요.');
	        	$('#upw2').focus();
	        }else if(chpw == ''){
	        	alert('비밀번호 확인이 일치하지 않습니다.');
	        	$('#upw2').val('');
	        	$('#upw2').focus();
	        }else{
	        	console.log(uid);
	        	console.log(upw);
	        	$.ajax({
					url : 'findPwChange',
					type : 'post',
					contentType : 'application/json',
					data : JSON.stringify({
						uid : uid,
						upw : upw
					}),
					success : function(data) {
						console.log('Received data:', data);
						if(data == 'yes'){
							alert('비밀번호가 변경되었습니다.');
							window.location.href = '/login';
						}else if(data == 'no'){
							alert('비밀번호 변경에 실패하였습니다.');
						}else{
							alert('예외발생.');
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