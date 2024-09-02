<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>회원가입</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<style type="text/css">
label,td{
	white-space: nowrap;
	vertical-align: middle;
}
.req{
	color: red;
}
</style>

</head>
<body>
	<%@ include file = "/WEB-INF/views/module/c_header.jsp" %>
	<div class="container p-5 my-5 border">
		<h1 class="text-center">회원가입</h1>
		<div class="text-center"><span class="req">*</span>는 필수입력란입니다.</div>
		<hr>
		<form action="join" method="post" class="" id="joinForm">
			<table class="table">
				<tr>
					<td><label for="uid"><span class="req">* </span>아이디</label></td>
					<td><div class="input-group"><input id="uid" class="form-control" name="uid" required
						maxlength="12" minlength="6" pattern="^(?=.*[A-Za-z])[A-Za-z\d]+$"
						placeholder="아이디는 영문,숫자 조합으로 6~12자리를 입력해주세요.">
						<button type="button" class="btn btn-primary form-button-input" onclick="idCheck()">중복확인</button></div>
						<div id="idmsg"></div></td>
				</tr>
				<tr>
					<td><label for="upw"><span class="req">* </span>비밀번호</label></td>
					<td><input id="upw" class="form-control" name="upw" type="password" 
						maxlength="20" minlength="8" 
						placeholder="비밀번호는 영문,숫자,특수문자(@#^$!%*?&) 조합으로 8~20자리를 입력해주세요."
						pattern="^(?=.*[A-Za-z])(?=.*\d)(?=.*[@#^$!%*?&])[A-Za-z\d@#^$!%*?&]+$"
						required>
						<div id="pwmsg"></div></td>
				</tr>
				<tr>
					<td><label for="upw2"><span class="req">* </span>비밀번호확인</label></td>
					<td><input id="upw2" class="form-control" name="upw2"
						type="password" maxlength="20" placeholder="비밀번호를 다시 한 번 입력해주세요."
						required>
						<div id="pwmsg2"></div></td>
				</tr>
				<tr>
					<td><label for="uname"><span class="req">* </span>이름</label></td>
					<td><input id="uname" class="form-control" name="uname"
						required></td>
				</tr>
				<tr>
					<td><label for="utel"><span class="req">* </span>연락처</label></td>
					<td><input id="utel" class="form-control" name="utel"
						type="tel" maxlength="11" minlength="9" pattern="\d*" 
						placeholder="연락처는 '-' 없이 숫자만 입력해주세요." required>
						<div></div></td>
				</tr>
				<tr>
					<td><label for="uemail"><span class="req">* </span>이메일</label></td>
					<td><input id="uemail" class="form-control" name="uemail"
						type="email" required><div id="mailmsg"></div></td>
				</tr>
				<tr>
					<td><label for="ubirth"><span class="req">* </span>생년월일</label></td>
					<td><input id="ubirth" class="form-control" name="ubirth"
						maxlength="8" minlength="8" pattern="\d*" 
						placeholder="8자리 숫자만 입력해주세요 예)19900505" required>
						</td>
				</tr>
				<tr>
					<td><span class="req">* </span>성별</td>
					<td><label for="male">남</label><input type="radio"
						class="form-check-input" id="male" name="ugender" value="남"
						checked>&nbsp;&nbsp;<label for="female">여</label><input type="radio"
						class="form-check-input" id="female" name="ugender" value="여">
						&nbsp;&nbsp;<label for="unk">비공개</label><input type="radio"
						class="form-check-input" id="unk" name="ugender" value="비공개"></td>
				</tr>
				<tr>
					<td><span class="req">* </span>주소</td>
					<td>
						<div class="input-group">
							<input type="text" id="sample4_postcode" name="zcode"
								class="form-control" placeholder="우편번호" maxlength="5"
								minlength="5" required> <input type="button"
								class="btn btn-primary form-button-input"
								onclick="sample4_execDaumPostcode()" value="우편번호 찾기">
						</div> <input type="text" class="form-control" id="sample4_roadAddress"
						placeholder="도로명주소" name="addr" required> <input
						type="text" class="form-control" id="sample4_jibunAddress"
						placeholder="지번주소"> <span id="guide"
						style="color: #999; display: none"></span> <input type="text"
						class="form-control" id="sample4_detailAddress" placeholder="상세주소"
						name="addr2"> <input type="hidden"
						id="sample4_extraAddress" placeholder="참고항목">
					</td>
				</tr>
			</table>
			<input type="submit" value="가입" class="btn btn-primary"> 
			<button type="button" class="btn btn-secondary" onclick="formReset()">리셋</button>
		</form>
	</div>
	<%@ include file = "/WEB-INF/views/module/footer.jsp" %>
	<script
	src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script type="text/javascript">
		
		let chid='';
		let chidf='';
		let chpw='';
		let chpwf='';
		let chmail='';
		let chmailf='';
		
		function idCheck(){
			let uid = $('#uid').val();
			if(uid == ''){
				alert('아이디를 입력해주세요.');
			}else if(chidf==''){
				alert('올바른 아이디를 입력해주세요.');
				$('#uid').focus();
			}else{
				console.log(uid);
				
				$.ajax({
					url : 'join/getId',
					type : 'post',
					data : {
						uid : uid
					},
					success : function(data) {
						console.log('Received data:', data.uid);
						if(data == 'yes'){
							alert('중복된 아이디가 있습니다.');
							$('#uid').val('');
							$('#idmsg').text('');
							$('#uid').focus();
							
						}else{
							alert('사용 가능한 아이디입니다.');
							chid="ok";
						}
					},
					error : function(xhr, status, error) {
						console.error('AJAX request failed: ', status, error);
					}
				});
			}
		}
		
		function formReset(){
			document.getElementById('joinForm').reset();
			$('#idmsg').text('');
			$('#pwmsg').text('');
			$('#pwmsg2').text('');
		}
		 
		$('#uemail').on('input', function() {
	       	let uemail = $(this).val();
	       	console.log(uemail);
	       	let msg = '';
	       	chmail='';
			chmailf='';
			let emailtype = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*$/;
	       	if (uemail == '') {
	       	    msg = '';
	       	}else if (!emailtype.test(uemail)) {
	       	    msg = "잘못된 이메일 형식입니다.";
	       	 	$("#mailmsg").css("color", "red");
	       	}else {
	       		
	       		$.ajax({
					url : 'join/getMail',
					type : 'post',
					data : {
						uemail : uemail
					},
					success : function(data) {
						console.log('Received data:', data);
						if(data == 'yes'){
							msg = "이미 가입된 이메일입니다.";
				       	 	$("#mailmsg").css("color", "red");
				       	 console.log(chmail);
						}else if(data == 'no'){
				       	    msg = "가입 가능한 이메일입니다.";
				       	 	$("#mailmsg").css("color", "green");
							chmail='ok';
							console.log(chmail);
						}else{
							alert('예상치 못한 에러.');
						}
						$('#mailmsg').text(msg);
					},
					error : function(xhr, status, error) {
						console.error('AJAX request failed: ', status, error);
					}
				});
	       	}
	        $('#mailmsg').text(msg);
	    });
		
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
		       	    msg = "한글은 포함할 수 없습니다.";
		       	 	$("#idmsg").css("color", "red");
		       	}
		       	// 문자열 길이 체크 (6~12자리)
		       	else if (uid.length < 6 || uid.length > 12) {
		       	    msg = "6자 이상 입력해주세요.";
		       	 	$("#idmsg").css("color", "red");
		       	}
		       	// 영문을 1자리 이상 포함하는지 체크
		       	else if (!/(?=.*[A-Za-z])/.test(uid)) {
		       	    msg = "영문을 1자리 이상 입력해주세요.";
		       	 	$("#idmsg").css("color", "red");
		       	}
		       	// 영문과 숫자만 포함하는지 체크
		       	else if (!/^[A-Za-z0-9]+$/.test(uid)) {
		       	    msg = "영문과 숫자만 포함할 수 있습니다.";
		       	 	$("#idmsg").css("color", "red");
		       	} else {
		       	    msg = "올바른 형식입니다.";
		       	 	$("#idmsg").css("color", "green");
		       	 	chidf='ok';
		       	}
		        $('#idmsg').text(msg);
		    });
			
			$('#upw').on('input', function() {
		       	let upw = $(this).val();
		       	let upw2 = $('#upw2').val();
		       	//console.log(upw);
		       	
		       	let msg = '';
		       	let msg2 = '';
		       	chpwf='';

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
		        	chpwf='ok';
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
			
			$("#joinForm").submit(function(event) {
		        event.preventDefault();
		        console.log(chid);
		        console.log(chpw);
		        let upw2 = $('#upw2').val();
		        
		        let utel = $('#utel').val();
		        let ubirth = $('#ubirth').val();
		        let uemail = $('#uemail').val();
		        
		        let teltype = /^01([0|1|6|7|8|9])([0-9]{3,4})([0-9]{4})$/;
		        let birthtype = /^(19\d{2}|20\d{2})(0[0-9]|1[0-2])(0[1-9]|[1-2][0-9]|3[0-1])$/;
		        let emailtype = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*$/;
		        
		        if(chid == ''){
		        	alert('아이디 중복체크를 해주세요.');
		        }else if (chpwf == ''){
		        	alert('올바른 비밀번호를 입력해주세요.');
		        	$('#upw').val('');
		        	$('#upw').focus();
		        }else if(upw2 == ''){
		        	alert('비밀번호 확인란을 입력해주세요.');
		        	$('#upw2').focus();
		        }else if(chpw == ''){
		        	alert('비밀번호 확인이 일치하지 않습니다.');
		        	$('#upw2').val('');
		        	$('#upw2').focus();
		        }else if (!teltype.test(utel)){
		        	alert('잘못된 휴대폰 번호입니다.');
		        	$('#utel').focus();
		        }else if (!emailtype.test(uemail)){
		        	alert('잘못된 이메일입니다.');
		        	$('#uemail').focus();
		        }else if (chmail == ''){
		        	alert('이미 가입된 이메일입니다.');
		        	$('#uemail').val('');
		        	$('#uemail').focus();
		        }else if (!birthtype.test(ubirth)){
		        	alert('잘못된 생년월일입니다.');
		        	$('#ubirth').focus();
		        }else{
		        	
		        	 let user = $(this).serializeArray();
		        	 let jsonData = {};
		             $.each(user, function() {
		                 jsonData[this.name] = this.value;
		             });
		        	 console.log(jsonData);
		        	$.ajax({
						url : 'join',
						type : 'post',
						contentType: 'application/json',
			            data: JSON.stringify(jsonData), // JSON 문자열로 변환
						success : function(data) {
							console.log('Received data:', data);
							if(data == 'yes'){
								alert('회원 가입이 완료되었습니다.');
								formReset();
								window.location.href = '/login';
								
							}else if(data == 'no'){
								alert('회원 가입에 실패하였습니다.');
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
		
			//본 예제에서는 도로명 주소 표기 방식에 대한 법령에 따라, 내려오는 데이터를 조합하여 올바른 주소를 구성하는 방법을 설명합니다.
			function sample4_execDaumPostcode() {
				new daum.Postcode(
						{
							oncomplete : function(data) {
								// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

								// 도로명 주소의 노출 규칙에 따라 주소를 표시한다.
								// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
								var roadAddr = data.roadAddress; // 도로명 주소 변수
								var extraRoadAddr = ''; // 참고 항목 변수

								// 법정동명이 있을 경우 추가한다. (법정리는 제외)
								// 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
								if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
									extraRoadAddr += data.bname;
								}
								// 건물명이 있고, 공동주택일 경우 추가한다.
								if (data.buildingName !== '' && data.apartment === 'Y') {
									extraRoadAddr += (extraRoadAddr !== '' ? ', '
											+ data.buildingName : data.buildingName);
								}
								// 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
								if (extraRoadAddr !== '') {
									extraRoadAddr = ' (' + extraRoadAddr + ')';
								}

								// 우편번호와 주소 정보를 해당 필드에 넣는다.
								document.getElementById('sample4_postcode').value = data.zonecode;
								document.getElementById("sample4_roadAddress").value = roadAddr;
								document.getElementById("sample4_jibunAddress").value = data.jibunAddress;

								// 참고항목 문자열이 있을 경우 해당 필드에 넣는다.
								if (roadAddr !== '') {
									document.getElementById("sample4_extraAddress").value = extraRoadAddr;
								} else {
									document.getElementById("sample4_extraAddress").value = '';
								}

								var guideTextBox = document.getElementById("guide");
								// 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
								if (data.autoRoadAddress) {
									var expRoadAddr = data.autoRoadAddress
											+ extraRoadAddr;
									guideTextBox.innerHTML = '(예상 도로명 주소 : '
											+ expRoadAddr + ')';
									guideTextBox.style.display = 'block';

								} else if (data.autoJibunAddress) {
									var expJibunAddr = data.autoJibunAddress;
									guideTextBox.innerHTML = '(예상 지번 주소 : '
											+ expJibunAddr + ')';
									guideTextBox.style.display = 'block';
								} else {
									guideTextBox.innerHTML = '';
									guideTextBox.style.display = 'none';
								}
							}
						}).open();
			}
			
	</script>
	
</body>
</html>