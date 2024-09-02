<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko"><head>
<title>Admin</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<style>
	textarea { resize: none;}
	#preview { display: none;}
</style>
<script>
	function slctPtype() {
		var rcount = parseFloat(document.getElementById('rcount').value) || 0;

		$.ajax({
			type : 'GET',
			url : './getProdListbyPtype',
			dataType : 'json',
			data : { "ptype" : $("#ptype").val() }, // 요청 파라미터
			success : function(response) {
				console.log('서버에서 받은 데이터:', response);

				if (!response) {
					alert("존재하지 않는 상품 종류입니다");
					return false;
				}
				// <select> 요소의 기존 옵션을 제거
	            var select = $('#pcode');
	            select.empty();

	            // 기본 옵션 추가
	            select.append('<option value="null">상품을 선택해주세요</option>');

	            // 서버에서 받은 데이터로 옵션 생성
	            $.each(response, function(index, prod) {
	                var option = $('<option></option>')
	                    .attr('value', prod.pcode)
	                    .text(prod.pname);
	                select.append(option);
	            });
			},
			error : function(xhr, status, error) {
				console.error('AJAX 오류 발생:', status, error);
			}
		});
	}
	function slctPname() {
		var rcount = parseFloat(document.getElementById('rcount').value) || 0;

		$.ajax({
			type : 'GET',
			url : './getProdInfo',
			dataType : 'json',
			data : { "pcode" : $("#pcode").val() }, // 요청 파라미터
			success : function(response) {
				console.log('서버에서 받은 데이터:', response);

				if (!response) {
					alert("존재하지 않는 상품입니다");
					return false;
				}
				// 서버에서 받은 응답(response)에 따라 DOM 조작
				$('#pname').val(response.pname);
				$('#pprice').val(response.pprice);
				$('#rtotal').val(response.pprice * rcount);
				// $('#ptype').prop('value', "'response.ptype'");
			},
			error : function(xhr, status, error) {
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
				type : 'GET',
				url : './idCheck',
				data : { "uid" : $("#uid").val() },
				success : function(response) {
					console.log('서버에서 받은 데이터:', response);

					if (!response) {
						alert("존재하지 않는 회원입니다");
						return false;
					}
					// 서버에서 받은 응답(response)에 따라 DOM 조작
					$('#uname').val(response.uname || '');
	                $('#utel').val(response.utel || '');
	                $('#zcode').val(response.zcode || '');
	                $('#addr').val(response.addr || '');
	                $('#addr2').val(response.addr2 || '');

				},
				error : function(xhr, status, error) {
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
	
	$(function() {
	    $("#insertForm").submit(function(event) {
	        event.preventDefault();

	        $.ajax({
	            type: 'post',
	            url: './insertResProd',
	            data: $("#insertForm").serialize(),
	            success: function(response) {
	            	
	                if (response === "1") {
	                	alert('회원 가입 성공. 로그인 페이지로 이동합니다.');
	                	window.location.href = './Login.uc';
	                } else if (response === "false") {
	                	alert('회원 가입 실패. 입력 사항을 확인해주세요.');
	                } else {
	               	 console.error('예상치 못한 응답:', response);
	                }
	            },
	            error: function(xhr, status, error) {
	                console.error('AJAX 오류 발생:', status, error);
	            }
	        });
	    });
	});
</script>
</head>
<body>
<%@ include file="/WEB-INF/views/module/anav.jsp" %>

	<div class="container mt-4">
		<h2 class="text-center">상품 예약 등록</h2>
		<hr />
		<input type="button" value="패키지 예약하기" class="btn btn-primary" onClick="location.href='./insertResPack'"><br><br>
		<form id="insertForm" action="./insertResProd" method="post">
			<div class="mt-3">
				<!-- 상품 정보 -->
				<div class="row mb-2">
					<div class="col-sm-2"></div>
					<div class="col-sm-4">
						<label for="ptype">상품 종류</label>
					</div>
					<div class="col-sm-4">
						<select name="ptype" id="ptype" class="form-select" onChange="slctPtype()" required>
							<option value="null">종류를 선택해주세요</option>
							<option value="간식">간식</option>
							<option value="미용">미용</option>
							<option value="사료">사료</option>
							<option value="영양제">영양제</option>
							<option value="장난감">장난감</option>
						</select>
					</div>
					<div class="col-sm-2"></div>
				</div>
				<div class="row mb-2">
					<div class="col-sm-2"></div>
					<div class="col-sm-4">
						<label for="pcode">상품명</label>
					</div>
					<div class="col-sm-4">
						<select name="pcode" id="pcode" class="form-select" onChange="slctPname()" required>
							<option value="null">상품 종류를 먼저 선택해주세요</option>
						</select>
					</div>
					<div class="col-sm-2">
					<input type="hidden" id="pname" name="pname" class="form-control" required></div>
				</div>
				<div class="row mb-2">
					<div class="col-sm-2"></div>
					<div class="col-sm-4">
						<label for="pprice">가격</label>
					</div>
					<div class="col-sm-4">
						<input type="text" id="pprice" name="pprice" class="form-control" required>
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
						<label for="zcode">우편번호</label>
					</div>
					<div class="col-sm-4">
						<div class="input-group">
						<input type="text" id="zcode" name="zcode" class="form-control" placeholder="우편번호">
						<input type="button" onclick="execDaumPostcode()" class="btn btn-primary" value="우편번호 찾기">
						</div>
					</div>
					<div class="col-sm-2"></div>
				</div>
				<div class="row mb-2">
					<div class="col-sm-2"></div>
					<div class="col-sm-4">
						<span id="guide" style="color: #999; display: none"></span>
					</div>
					<div class="col-sm-4">
						<input type="text" id="addr" name="addr" class="form-control" placeholder="도로명주소"></div>
					<div class="col-sm-2">
						<input type="hidden" id="jibunAddress" placeholder="지번주소"></div>
				</div>
				<div class="row mb-2">
					<div class="col-sm-2"></div>
					<div class="col-sm-4"></div>
					<div class="col-sm-4">
						<input type="text" id="addr2" name="addr2" class="form-control" placeholder="상세주소"></div>
					<div class="col-sm-2"><input type="hidden" id="extraAddress" placeholder="참고항목"></div>
				</div>
				<div class="row mb-2">
					<div class="col-sm-2"></div>
					<div class="col-sm-4">수량</div>
					<div class="col-sm-4 quantity-container">
						<input type="number" id="rcount" name="rcount" min="1" value="1" class="form-control" onClick="rtotalCal()"/>
					</div>
					<div class="col-sm-2"></div>
				</div>
				<div class="row mb-2">
					<div class="col-sm-2"></div>
					<div class="col-sm-4">
						<label for="pprice">합계</label>
					</div>
					<div class="col-sm-4">
						<input type="number" id="rtotal" name="rtotal" class="form-control" readonly required>
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
    //본 예제에서는 도로명 주소 표기 방식에 대한 법령에 따라, 내려오는 데이터를 조합하여 올바른 주소를 구성하는 방법을 설명합니다.
    function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 도로명 주소의 노출 규칙에 따라 주소를 표시한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var roadAddr = data.roadAddress; // 도로명 주소 변수
                var extraRoadAddr = ''; // 참고 항목 변수

                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraRoadAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if(data.buildingName !== '' && data.apartment === 'Y'){
                   extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if(extraRoadAddr !== ''){
                    extraRoadAddr = ' (' + extraRoadAddr + ')';
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('zcode').value = data.zonecode;
                document.getElementById("addr").value = roadAddr;
                document.getElementById("jibunAddress").value = data.jibunAddress;
                
                // 참고항목 문자열이 있을 경우 해당 필드에 넣는다.
                if(roadAddr !== ''){
                    document.getElementById("extraAddress").value = extraRoadAddr;
                } else {
                    document.getElementById("extraAddress").value = '';
                }

                var guideTextBox = document.getElementById("guide");
                // 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
                if(data.autoRoadAddress) {
                    var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
                    guideTextBox.innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';
                    guideTextBox.style.display = 'block';

                } else if(data.autoJibunAddress) {
                    var expJibunAddr = data.autoJibunAddress;
                    guideTextBox.innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';
                    guideTextBox.style.display = 'block';
                } else {
                    guideTextBox.innerHTML = '';
                    guideTextBox.style.display = 'none';
                }
            }
        }).open();
    }
</script>
</body></html>