<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html><html><head>
<meta charset="UTF-8">
<title>예약 상세</title>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<style>
	body {
		font-family: Arial, sans-serif;
		margin: 20px;
	}

	h1 {
		text-align: center;
		color: #333;
	}
</style>
<script>
	
	function slctPtype() {
		var rcount = parseFloat(document.getElementById('rcount').value) || 0;

		$.ajax({
			type : 'GET',
			url : '/admin/res/getProdListbyPtype',
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
			url : '/admin/res/getProdInfo',
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
				$('#pprice2').val(response.pprice);
				$('#rtotal').val(response.pprice * rcount);
				$('#rtotal2').val(response.pprice * rcount);
				// $('#ptype').prop('value', "'response.ptype'");
			},
			error : function(xhr, status, error) {
				console.error('AJAX 오류 발생:', status, error);
			}
		});
	}
	function parseDate(dateStr) {
        // 날짜 문자열을 Date 객체로 변환하는 함수
        // 입력 형식은 YYYY-MM-DD (ex: 2024-08-15)
        var parts = dateStr.split("-");
        return new Date(parts[0], parts[1] - 1, parts[2]); // 월은 0부터 시작
    }

    function redayCal() {
        // rsday를 Date 객체로 변환
        var rsday = parseDate($("#rsday").val());
        // rperiod를 숫자로 변환
        var rperiod = parseFloat($("#rperiod").val());

        if (isNaN(rperiod) || !rsday) {
            console.error('날짜 혹은 기간 오류');
            return;
        }

        // 날짜에 rperiod를 더하기
        rsday.setDate(rsday.getDate() + rperiod - 1);

        // 연도, 월, 일 추출
        var year = rsday.getFullYear();
        var month = ('0' + (rsday.getMonth() + 1)).slice(-2); // 월은 0부터 시작하므로 +1
        var day = ('0' + rsday.getDate()).slice(-2); // 2자리 형식

        // 'YYYY-MM-DD' 형식으로 변환
        var newDate = year + '-' + month + '-' + day;

        // 결과를 <input> 요소에 설정
        document.getElementById('reday').value = newDate;
    }
</script>
</head>
<body>
<%@ include file="/WEB-INF/views/module/anav.jsp" %>
    <h1>예약 정보 수정 : ${res.rnum} 번</h1>
    <hr/>
    <div class="container mt-4">
		<form id="updateForm" action="/admin/res/updateRes/rnum/${res.rnum}" method="post">
			<div class="mt-3">
				<input type="hidden" id="rnum" name="rnum" value="${res.rnum}">
				<!-- 상품 정보 -->
				<div class="row mb-2">
					<div class="col-sm-2"></div>
					<div class="col-sm-4">
						<label for="ptype">종류</label>
					</div>
					<div class="col-sm-4">
						<c:choose>
							<c:when test="${res.ptype eq '패키지'}">
								<input type="text" name="ptype" id="ptype" class="form-control" value="${res.ptype}" readonly>
							</c:when>
							<c:otherwise>
								<select name="ptype" id="ptype" class="form-select" onChange="slctPtype()" required>
									<option value="null">종류를 선택해주세요</option>
									<option value="간식" <c:if test="${res.ptype eq '간식'}">selected</c:if> >간식</option>
									<option value="미용" <c:if test="${res.ptype eq '미용'}">selected</c:if> >미용</option>
									<option value="사료" <c:if test="${res.ptype eq '사료'}">selected</c:if> >사료</option>
									<option value="영양제" <c:if test="${res.ptype eq '영양제'}">selected</c:if> >영양제</option>
									<option value="장난감" <c:if test="${res.ptype eq '장난감'}">selected</c:if> >장난감</option>
								</select>
							</c:otherwise>
						</c:choose>
					</div>
					<div class="col-sm-2"></div>
				</div>
				<div class="row mb-2">
					<div class="col-sm-2"></div>
					<div class="col-sm-4">
						<label for="pcode">상품명</label>
					</div>
					<div class="col-sm-4">
						<c:choose>
							<c:when test="${res.ptype eq '패키지'}">
								<select name="pcode" id="pcode" class="form-select" onChange="slctPname()" required>
									<option value="P100"
										<c:if test="${res.pcode eq 'P100'}">selected</c:if>>유치원</option>
									<option value="P110"
										<c:if test="${res.pcode eq 'P110'}">selected</c:if>>유치원, 호텔</option>
									<option value="P101"
										<c:if test="${res.pcode eq 'P101'}">selected</c:if>>유치원, 미용</option>
									<option value="P111"
										<c:if test="${res.pcode eq 'P111'}">selected</c:if>>유치원, 호텔, 미용</option>
								</select>
							</c:when>
							<c:otherwise>
								<select name="pcode" id="pcode" class="form-select" onChange="slctPname()" required>
									<option value="${res.pcode}">${res.pname}</option>
								</select>
							</c:otherwise>
						</c:choose>
					</div>
					<div class="col-sm-2">
					<input type="hidden" id="pname" name="pname" value="${res.pname}"></div>
				</div>
			
				<div class="row mb-2">
					<div class="col-sm-2"></div>
					<div class="col-sm-4">
						<label for="pprice">가격</label>
					</div>
					<div class="col-sm-4">
						<span><fmt:formatNumber value="${res.pprice}"  groupingUsed="true"/>원</span>
						<input type="text" id="pprice" name="pprice" value="${res.pprice}">
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
						<input type="text" id="uid" name="uid" class="form-control" value="${res.uid}" disabled>
					</div>
					<div class="col-sm-2"></div>
				</div>
				<div class="row mb-2">
					<div class="col-sm-2"></div>
					<div class="col-sm-4">
						<label for="uname">이름</label>
					</div>
					<div class="col-sm-4">
						<input type="text" id="uname" name="uname" class="form-control" value="${res.uname}" disabled>
					</div>
					<div class="col-sm-2"></div>
				</div>
				<div class="row mb-2">
					<div class="col-sm-2"></div>
					<div class="col-sm-4">
						<label for="utel">전화번호</label>
					</div>
					<div class="col-sm-4">
						<input type="text" id="utel" name="utel" class="form-control" value="${res.utel}" disabled>
					</div>
					<div class="col-sm-2"></div>
				</div>
				
				<c:choose>
					<c:when test="${res.ptype eq '패키지'}">
					<input type="hidden" id="zcode" name="zcode" value="${res.zcode}">
					<input type="hidden" id="addr" name="addr" value="${res.addr}">
					<input type="hidden" id="addr2" name="addr2" value="${res.addr2}">
					</c:when>
				<c:otherwise>
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
						<input type="text" id="addr" name="addr" class="form-control" value="${res.addr}" placeholder="도로명주소"></div>
					<div class="col-sm-2">
						<input type="hidden" id="jibunAddress" placeholder="지번주소"></div>
				</div>
				<div class="row mb-2">
					<div class="col-sm-2"></div>
					<div class="col-sm-4"></div>
					<div class="col-sm-4">
						<input type="text" id="addr2" name="addr2" class="form-control" value="${res.addr2}" placeholder="상세주소"></div>
					<div class="col-sm-2"><input type="hidden" id="extraAddress" placeholder="참고항목"></div>
				</div>
				</c:otherwise>
				</c:choose>
				
				<c:choose>
				<c:when test="${res.ptype eq '패키지'}">
				<div class="row mb-2">
					<div class="col-sm-2"></div>
					<div class="col-sm-4">
						<label for="rsday">돌봄 시작일</label>
					</div>
					<div class="col-sm-4">
						<input type="date" id="rsday" name="rsday" class="form-control" value="${res.rsday}" onChange="redayCal()">
					</div>
					<div class="col-sm-2"></div>
				</div>
				<div class="row mb-2">
					<div class="col-sm-2"></div>
					<div class="col-sm-4">
						<label for="rperiod">돌봄 기간</label>
					</div>
					<div class="col-sm-4">
						<c:choose>
							<c:when test="${res.rperiod eq '1'}">
								<input type="text" name="rperiod" id="rperiod" class="form-control" value="${res.rperiod}" required>
							</c:when>
							<c:otherwise>
								<select name="rperiod" id="rperiod" class="form-select" onChange="redayCal()" required>
									<option value="null">기간 선택</option>
									<option value="2" <c:if test="${res.rperiod eq '2'}">selected</c:if>>1박 2일</option>
									<option value="3" <c:if test="${res.rperiod eq '3'}">selected</c:if>>2박 3일</option>
									<option value="7" <c:if test="${res.rperiod eq '7'}">selected</c:if>>6박 7일</option>
								</select>
							</c:otherwise>
						</c:choose>
					</div>
					<div class="col-sm-2"></div>
				</div>
				</c:when>
				<c:otherwise>
					<input type="hidden" id="rsday" name="rsday" value="${res.rsday}">
					<input type="hidden" name="rperiod" id="rperiod" value="${res.rperiod}">
				</c:otherwise>
				</c:choose>
				<div class="row mb-2">
					<div class="col-sm-2"></div>
						<c:choose>
							<c:when test="${res.ptype eq '패키지'}">
								<div class="col-sm-4">마리</div>
							</c:when>
							<c:otherwise>
								<div class="col-sm-4">수량</div>
							</c:otherwise>
						</c:choose>
					<div class="col-sm-4 quantity-container">
						<input type="number" id="rcount" name="rcount" min="1" class="form-control" value="${res.rcount}" onClick="slctPname()" />
					</div>
					<div class="col-sm-2"></div>
				</div>
				<c:choose>
				<c:when test="${res.ptype eq '패키지'}">
				<div class="row mb-2">
					<div class="col-sm-2"></div>
					<div class="col-sm-2">설명</div>
					<div class="col-sm-6">
						<textarea id="rdinfo" name="rdinfo" cols="80" rows="30" class="form-control">${res.rdinfo}</textarea>
					</div>
					<div class="col-sm-2"></div>
				</div>
				</c:when>
				<c:otherwise>
					<input type="hidden" id="rdinfo" name="rdinfo" value="${res.rdinfo}">
				</c:otherwise>
				</c:choose>
				<div class="row mb-2">
					<div class="col-sm-2"></div>
					<div class="col-sm-4">
						<label for="rtotal">합계</label>
					</div>
					<div class="col-sm-4">
						<span><fmt:formatNumber value="${res.rtotal}" groupingUsed="true"/>원</span>
						<input type="text" id="rtotal" name="rtotal" value="${res.rtotal}">
					</div>
					<div class="col-sm-2"></div>
				</div>
				<div class="row mb-2">
					<div class="col-sm-3"></div>
					<div class="col-sm-2"></div>
					<div class="col-sm-2">
						<input type="submit" value="수정" class="btn btn-primary">
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
	
	$(document).ready(function() {
		var pcode = $('#pcode').val();
		console.log(pcode);
		
		slctPtype();
	});
</script>
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