<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko"><head>
<title>Admin</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
	textarea { resize:none;}
	#preview { display:none;}
</style>
<script>
	function slctPname() {
		var rcount = parseFloat(document.getElementById('rcount').value) || 0;
		
		$.ajax({
	        type: 'GET',
	        url: './getProdInfo',
	        dataType: 'json',
	        data: { "pcode" : $("#pcode").val() }, // 요청 파라미터
	        success: function(response) {
	        	console.log('서버에서 받은 데이터:', response);
	        	
	        	if(!response){
	        		alert("존재하지 않는 상품입니다");
	        		return false;
	        	}
	        	// 서버에서 받은 응답(response)에 따라 DOM 조작
	        	$('#pname').val(response.pname);
	        	$('#pprice').val(response.pprice);
	        	$('#rtotal').val(response.pprice * rcount);
	        	// $('#ptype').prop('value', "'response.ptype'");
	        },
	        error: function(xhr, status, error) {
	            console.error('AJAX 오류 발생:', status, error);
	        }
	    });
	}
	
	function idConfirm() { // id 확인
		if ($("#uid").val().trim() === "") {
			alert("아이디를 입력해주세요.");
			$("#uid").focus();
			return false;
		} else {
			  $.ajax({
		        type: 'GET',
		        url: './idCheck',
		        data: { "uid" : $("#uid").val() },
		        success: function(response) {
		        	console.log('서버에서 받은 데이터:', response);
		        	
		        	if(!response){
		        		alert("존재하지 않는 회원입니다");
		        		return false;
		        	}
		        	// 서버에서 받은 응답(response)에 따라 DOM 조작
		        	$('#uname').val(response.uname);
		        	$('#utel').val(response.utel);
		        	
		        },
		        error: function(xhr, status, error) {
		            console.error('AJAX 오류 발생:', status, error);
		        }
		    });
		  }
		  return false;
		}
	
	function rtotalCal() {
	    // 문자열로 가져온 값을 숫자로 변환
	    var pprice = parseFloat(document.getElementById('pprice').value) || 0;
	    var rcount = parseFloat(document.getElementById('rcount').value) || 0;
	    
	    // 계산 결과를 설정
	    $('#rtotal').val(pprice * rcount);
	}
	
</script>
</head>
<body>
<%@ include file="/WEB-INF/views/module/anav.jsp" %>

	<div class="container mt-4">
		<h2 class="text-center">패키지 예약 등록</h2>
		<hr />
		<input type="button" value="상품 예약하기" class="btn btn-primary" onClick="location.href='./insertResProd'"><br><br>
		<form id="insertForm" action="./insertResPack" method="post">
			<div class="mt-3">
				<input type="hidden" id="ptype" name="ptype" value="패키지">
				<!-- 상품 정보 -->
				<div class="row mb-2">
					<div class="col-sm-2"></div>
					<div class="col-sm-4">
						<label for="pcode">패키지</label>
					</div>
					<div class="col-sm-4">
						<select name="pcode" id="pcode" class="form-select" onChange="slctPname()" required>
							<option value="P100" selected>유치원</option>
							<option value="P110">유치원, 호텔</option>
							<option value="P101">유치원, 미용</option>
							<option value="P111">유치원, 호텔, 미용</option>
						</select>
					</div>
					<div class="col-sm-2">
					<input type="hidden" id="pname" name="pname" value="패키지(유치원)"></div>
				</div>
				<div class="row mb-2">
					<div class="col-sm-2"></div>
					<div class="col-sm-4">
						<label for="pprice">가격</label>
					</div>
					<div class="col-sm-4">
						<input type="text" id="pprice" name="pprice" class="form-control" value="100000" required>
					</div>
					<div class="col-sm-2"></div>
				</div>
			
				<!-- 고객 정보 -->
				<div class="row mb-2">
					<div class="col-sm-2"></div>
					<div class="col-sm-4">
						<label for="uid">고객 아이디</label>
					</div>
					<div class="col-sm-4">
						<div class="input-group">
						<input type="text" id="uid" name="uid" class="form-control" required>
						<button type="button" onclick="idConfirm()" class="btn btn-primary" style="width: 100px;">ID 확인</button>
						</div>
					</div>
					<div class="col-sm-2"></div>
				</div>
				<div class="row mb-2">
					<div class="col-sm-2"></div>
					<div class="col-sm-4">
						<label for="uname">이름</label>
					</div>
					<div class="col-sm-4">
						<input type="text" id="uname" name="uname" class="form-control" required>
					</div>
					<div class="col-sm-2"></div>
				</div>
				<div class="row mb-2">
					<div class="col-sm-2"></div>
					<div class="col-sm-4">
						<label for="utel">전화번호</label>
					</div>
					<div class="col-sm-4">
						<input type="text" id="utel" name="utel" class="form-control" required>
					</div>
					<div class="col-sm-2"></div>
				</div>

				<div class="row mb-2">
					<div class="col-sm-2"></div>
					<div class="col-sm-4">
						<label for="rsday">돌봄 시작일</label>
					</div>
					<div class="col-sm-4">
						<input type="date" id="rsday" name="rsday" class="form-control" required>
					</div>
					<div class="col-sm-2"></div>
				</div>
				<div class="row mb-2">
					<div class="col-sm-2"></div>
					<div class="col-sm-4">
						<label for="rperiod">돌봄 기간</label>
					</div>
					<div class="col-sm-4">
						<select name="rperiod" id="rperiod" class="form-select" required>
							<option value="null">기간 선택</option>
							<option value="2">1박 2일</option>
							<option value="3">2박 3일</option>
							<option value="7">6박 7일</option>
						</select>
					</div>
					<div class="col-sm-2"></div>
				</div>
				<div class="row mb-2">
					<div class="col-sm-2"></div>
					<div class="col-sm-4">마리</div>
					<div class="col-sm-4 quantity-container">
						<input type="number" id="rcount" name="rcount" min="1" value="1" class="form-control" onChange="rtotalCal()"/>
					</div>
					<div class="col-sm-2"></div>
				</div>
				<div class="row mb-2">
					<div class="col-sm-2"></div>
					<div class="col-sm-2">설명</div>
					<div class="col-sm-6">
						<textarea id="rdinfo" name="rdinfo" cols="80" rows="30" class="form-control"
						placeholder="맡기실 반려견의 이름, 나이, 특이사항 등을 작성해주세요." required></textarea>
					</div>
					<div class="col-sm-2"></div>
				</div>
				<div class="row mb-2">
					<div class="col-sm-2"></div>
					<div class="col-sm-4">
						<label for="pprice">합계</label>
					</div>
					<div class="col-sm-4">
						<input type="number" id="rtotal" name="rtotal" class="form-control" value="100000" readonly required>
					</div>
					<div class="col-sm-2"></div>
				</div>
				<div class="row mb-2">
					<div class="col-sm-3"></div>
					<div class="col-sm-2"></div>
					<div class="col-sm-2">
						<input type="submit" value="등록" class="btn btn-primary">
					</div>
					<div class="col-sm-2">
						<input type="button" value="취소" class="btn btn-primary" onClick="location.href='/admin/res/list'">
					</div>
					<div class="col-sm-3"></div>
				</div>
			</div>
		</form>
	</div>
<%@ include file="/WEB-INF/views/module/footer.jsp"%>

<script>
	//날짜 form 하루 뒤부터 선택 가능하게
	const date = new Date();
	date.setDate(date.getDate() + 1);
	const dateControl = document.getElementById('rsday');
	dateControl.setAttribute("min", date.toISOString().substring(0, 10));
	
    // 현재 날짜 객체 생성
    var today = new Date();

    // 날짜에 1일 추가
    today.setDate(today.getDate() + 1);

    // 연도, 월, 일 추출
    var year = today.getFullYear();
    var month = ('0' + (today.getMonth() + 1)).slice(-2); // 월은 0부터 시작하므로 +1, 2자리 형식
    var day = ('0' + today.getDate()).slice(-2); // 2자리 형식

    // 'YYYY-MM-DD' 형식으로 변환
    var tomorrow = year + '-' + month + '-' + day;

    // <input> 요소의 기본값 설정
    document.getElementById('rsday').value = tomorrow;

</script>
</body></html>