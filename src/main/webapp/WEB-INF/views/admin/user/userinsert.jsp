<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Pragma", "no-cache");
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Cache-Control", "no-store");
response.setDateHeader("Expires", 0L);
%>
<!DOCTYPE html>
<html>
<head>
<title>회원 추가</title>
<style>
.fontsize {font-size:17px;}
</style>
<script src="http://code.jquery.com/jquery-1.10.2.min.js"></script>
<script src="path/to/your/javascript.js"></script>
</head>
<body>
	<%@ include file="/WEB-INF/views/module/anav.jsp"%>
	<section id="memberAdd">
		<form name="addForm" action="/admin/user/insert" method="post" class="mt-5 mb-5">
			<div class="container">
				<div class="row">
					<div class="col-sm-2"></div>
					<div class="col-sm-8 text-center"><h2>회원가입</h2></div>
					<div class="col-sm-2"></div>
				</div>
				
				<div class="row mt-5 fontsize">
					<div class="col-sm-2"></div>
					<div class="col-sm-1"><label for="uid"><span style="color:red;">* </span>아이디</label></div>
					<div class="col-sm-7">
						<div class="input-group">
							<input type="text" class="form-control" id="uid" name="uid" onchange="validation()" required>
							<button id="chkDuplicate" type="button" class="btn btn-sm btn-outline-dark" onclick="checkID()" style="width:100px; border-color: #cfcfcf; font-size:16px;">중복확인</button>
						</div>
					</div>
					<div class="col-sm-2"></div>
					
					<div class="col-sm-3"></div>
					<div class="col-sm-6"><span id="chkID"></span></div>
					<div class="col-sm-3"></div>
				</div>
				
				<div class="row mt-3 fontsize">
					<div class="col-sm-2"></div>
					<div class="col-sm-1"><label for="upw"><span style="color:red;">* </span>비밀번호</label></div>
					<div class="col-sm-7">
						<input type="password" class="form-control" id="upw" name="upw" onkeyup="check_pw()" onchange="validation()" placeholder="비밀번호는 8자 이상이며 특수문자를 1개 이상 포함해야 합니다" required />
					</div>
					<div class="col-sm-2"></div>
					
					<div class="col-sm-3"></div>
					<div class="col-sm-6"><span id="again"></span></div>
					<div class="col-sm-3"></div>
				</div>
				
				<div class="row mt-3 fontsize">
					<div class="col-sm-2"></div>
					<div class="col-sm-1"><label for="upw2"><span style="color:red;">* </span>비밀번호 확인</label></div>
					<div class="col-sm-7">
						<input type="password" class="form-control" id="upw2" name="upw2" onchange="check_pw()" onkeyup="validation()" required />
					</div>
					<div class="col-sm-2"></div>
					
					<div class="col-sm-3"></div>
					<div class="col-sm-6"><span id="check"></span></div>
					<div class="col-sm-3"></div>
				</div>
					
				<div class="row mt-3 fontsize">
					<div class="col-sm-2"></div>
					<div class="col-sm-1"><label for="uname"><span style="color:red;">* </span>이 름</label></div>
					<div class="col-sm-7">
						<input type="text" class="form-control" id="uname" name="uname" onkeyup="validation()" required />
					</div>
					<div class="col-sm-2"></div>
				</div>
					
				<div class="row mt-3 fontsize">
					<div class="col-sm-2"></div>
					<div class="col-sm-1"><label for="utel"><span style="color:red;">* </span>전화번호</label></div>
					<div class="col-sm-7">
						<input type="tel" class="form-control" id="utel" name="utel" maxlength="11" onkeyup="validation()" placeholder="ex) 01012345678" required />
					</div>
					<div class="col-sm-2"></div>
				</div>
					
				<div class="row mt-3 fontsize">
					<div class="col-sm-2"></div>
					<div class="col-sm-1"><label for="uemail"><span style="color:red;">* </span>이메일</label></div>
					<div class="col-sm-7">
						<input type="email" class="form-control" id="uemail" name="uemail" onkeyup="validation()" placeholder="ex) aaa@naver.com" required />
						  <span id="emailMsg"></span>
					</div>
					<div class="col-sm-2"></div>
				</div>


					
				<div class="row mt-3 fontsize">
					<div class="col-sm-2"></div>
					<div class="col-sm-1"><label for="ubirth"><span style="color:red;">* </span>생년월일</label></div>
					<div class="col-sm-7">
						<input type="text" class="form-control" id="ubirth" name="ubirth" maxlength="8" onkeyup="validation()" placeholder="ex) 20000101" required />
					</div>
					<div class="col-sm-2"></div>
				</div>
					
				<div class="row mt-3 fontsize">
					<div class="col-sm-2"></div>
					<div class="col-sm-1"><label><span style="color:red;">* </span>성 별</label></div>
					<div class="col-sm-7">
						<div class="form-check form-check-inline">
							<input type="radio" class="form-check-input" id="radio1" name="ugender" value="여" checked> 
							<label class="form-check-label" for="radio1">여자</label>
						</div>
						<div class="form-check form-check-inline">
							<input type="radio" class="form-check-input" id="radio2" name="ugender" value="남"> 
							<label class="form-check-label" for="radio2">남자</label>
						</div>
						<div class="form-check form-check-inline">
							<input type="radio" class="form-check-input" id="radio3" name="ugender" value="비공개"> 
							<label class="form-check-label" for="radio3">비공개</label>
						</div>
					</div>
					<div class="col-sm-2"></div>
				</div>
					
			<div class="row mt-3 fontsize">
   <div class="row mt-3 fontsize">
    <div class="col-sm-2"></div>
    <div class="col-sm-1"><label for="zcode">우편번호</label></div>
    <div class="col-sm-7">
        <div class="input-group">
            <input type="text" class="form-control" id="zcode" name="zcode">
            <button type="button" onclick="execDaumPostcode()" class="btn btn-outline-dark" style="width:100px; border-color: #cfcfcf; font-size:16px;">주소찾기</button>
        </div>
    </div>
    <div class="col-sm-2"></div>
</div>

<div class="row mt-3 fontsize">
    <div class="col-sm-2"></div>
    <div class="col-sm-1"><label for="roadAddr">주소</label></div>
    <div class="col-sm-7">
        <input type="text" class="form-control" placeholder="도로명 주소" id="roadAddr" name="addr">
        <input type="text" class="form-control" placeholder="지번 주소" id="jibunAddr">
        <input type="text" class="form-control" placeholder="상세 주소" id="detailAddr" name="addr2">
    </div>
    <div class="col-sm-2"></div>
</div>




				<div id="moveBtn" class="row mt-3 text-end">
					<div class="col-sm-10 text-end">
						<button type="submit" id="submitBtn" class="btn btn-dark" style="font-size: 16px;" disabled>회원등록</button>
						<a href="/admin/user/getlist" class="btn btn-outline-dark" style="width:90px; font-size: 16px;">회원목록</a>
					</div>
					<div class="col-sm-2"></div>
				</div>
			</div>
		</form>
	</section>
	<jsp:include page="/WEB-INF/views/module/footer.jsp" />
	<script src="http://code.jquery.com/jquery-1.10.2.min.js"></script>
	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script>
		// 다음 주소 API
	function execDaumPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {
            var roadAddr = data.roadAddress; // 도로명 주소
            var jibunAddr = data.jibunAddress; // 지번 주소

            // 콘솔에 응답 객체를 출력하여 디버깅
            console.log(data);

            // 우편번호를 입력
            document.getElementById('zcode').value = data.zonecode;

            // 도로명 주소를 입력
            document.getElementById('roadAddr').value = roadAddr;


         
                document.getElementById('jibunAddr').value = jibunAddr;
        

            // 상세 주소는 사용자가 직접 입력하도록 포커스
            document.getElementById('detailAddr').focus();
        }
    }).open();
}



	$(document).ready(function() {
	    $('#uemail').on('input', function() {
	        var email = $(this).val();
	        var msg = '';

	        // 이메일 형식 검증
	        var emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
	        if (email === '') {
	            msg = '';
	            $('#emailMsg').text(msg);
	            return;
	        } else if (!emailPattern.test(email)) {
	            msg = '잘못된 이메일 형식입니다.';
	            $('#emailMsg').css('color', 'red');
	            $('#emailMsg').text(msg);
	            return;
	        }

	        // 서버로 AJAX 요청
	        $.ajax({
	            url: '/admin/user/checkEmail', // 서버의 엔드포인트 URL
	            type: 'POST',
	            data: { email: email },
	            success: function(data) {
	                console.log('AJAX success:', data); // 디버깅을 위한 로그
	                if (data === 'exists') {
	                    msg = '이미 가입된 이메일입니다.';
	                    $('#emailMsg').css('color', 'red');
	                } else if (data === 'available') {
	                    msg = '가입 가능한 이메일입니다.';
	                    $('#emailMsg').css('color', 'green');
	                } else {
	                    msg = '예상치 못한 오류가 발생했습니다.';
	                    $('#emailMsg').css('color', 'red');
	                }
	                $('#emailMsg').text(msg);
	            },
	            error: function(xhr, status, error) {
	                console.error('AJAX request failed: ', status, error); // 디버깅을 위한 로그
	                $('#emailMsg').text('서버 오류. 나중에 다시 시도해 주세요.');
	                $('#emailMsg').css('color', 'red');
	            }
	        });
	    });
	});

		// 아이디 중복 체크
	function checkID() {
    var status = $('#uid').attr('data-status');
    var memberID = $('#uid').val();
    $('#chkID').html("");

    if (memberID === "") {
        $('#chkID').css('display', 'block');
        $('#chkID').html("&nbsp;아이디를 입력해주세요.");
        $('#chkID').css('color', 'gray');
        $('#uid').focus();
        return;
    }

    $.ajax({
        url: '/admin/user/checkid',
        type: 'POST',
        data: { uid: memberID }, // 서버 측의 요청 파라미터와 일치시킴
        success: function(data) {
            if (data.result > 0) {
                $('#uid').attr('data-status', 'no');
                $('#chkID').css('color', 'red');
                $('#chkID').html("&nbsp;이미 존재하는 아이디입니다.");
                $('#chkID').css('display', 'block');
                $('#uid').focus();
            } else {
                $('#uid').attr('data-status', 'yes');
                $('#chkID').css('color', 'blue');
                $('#chkID').html("&nbsp;사용 가능한 아이디입니다.");
                $('#chkID').css('display', 'block');
            }
            validation(); // Update validation after AJAX success
        },
        error: function(xhr, status, error) {
            console.error("Ajax Error " + status);
        }
    });
}

		// 비밀번호 일치 확인
		function check_pw() {
    var pw = document.getElementById('upw').value;
    var pw2 = document.getElementById('upw2').value;

    // 정규식 패턴: 최소 8자 이상, 특수문자 포함
    var pwPattern = /^(?=.*[!@#$%^&*()_+{}\[\]:;"'<>,.?~\\/-])[A-Za-z\d!@#$%^&*()_+{}\[\]:;"'<>,.?~\\/-]{8,}$/;

    // 비밀번호 유효성 검증
    if (pw.length === 0) {
        document.getElementById('again').innerHTML = '';
    } else if (!pwPattern.test(pw)) {
        document.getElementById('again').innerHTML = '비밀번호는 8자 이상이며 특수문자를 포함해야 합니다.';
    } else {
        document.getElementById('again').innerHTML = '';
    }

    // 비밀번호 일치 여부 확인
    if (pw.length >= 8 && pwPattern.test(pw) && pw2 !== '') {
        if (pw === pw2) {
            document.getElementById('check').innerHTML = '비밀번호 일치';
            document.getElementById('check').style.color = 'blue';
        } else {
            document.getElementById('check').innerHTML = '비밀번호 불일치';
            document.getElementById('check').style.color = 'red';
        }
    } else if (pw2 === '') {
        document.getElementById('check').innerHTML = '';
    }

    validation(); // Update validation after password check
}


		function validation() {
			var id = document.getElementById("uid");
			var pw = document.getElementById("upw");
			var pw2 = document.getElementById("upw2");
			var mname = document.getElementById("uname");
			var tel = document.getElementById("utel");
			var email = document.getElementById("uemail");
			var birthday = document.getElementById("ubirth");
			
			var idStatus = id.getAttribute('data-status');
			
			 var emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
			    var emailIsValid = emailPattern.test(email.value);
			
			if(idStatus === 'yes' && pw.value === pw2.value && mname.value.length > 0 && tel.value.length === 11 && email.value.length > 0 && birthday.value.length === 8) {
				document.getElementById("submitBtn").disabled = false;	
			} else {
				document.getElementById("submitBtn").disabled = true;
			}
		}
	</script>
</body>
</html>
