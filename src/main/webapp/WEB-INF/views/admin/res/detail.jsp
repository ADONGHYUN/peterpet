<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
	form div {
		height: 38px;
		vertical-align: middle;
	}
</style>
</head>
<body>
<%@ include file="/WEB-INF/views/module/anav.jsp" %>
    <div class="container mt-5">
    	<h1 class="mb-4">예약 정보 : ${res.rnum} 번</h1>
    	<hr/>
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
						<input type="text" name="ptype" id="ptype" class="form-control" value="${res.ptype}" readonly>
					</div>
					<div class="col-sm-2"></div>
				</div>
				<div class="row mb-2">
					<div class="col-sm-2"></div>
					<div class="col-sm-4">
						<label for="pname">상품명</label>
					</div>
					<div class="col-sm-4">
						<input type="text" id="pname" name="pname" class="form-control" value="${res.pname}" readonly>
					</div>
					<div class="col-sm-2"></div>
				</div>
			
				<div class="row mb-2">
					<div class="col-sm-2"></div>
					<div class="col-sm-4">
						<label for="pprice">가격</label>
					</div>
					<div class="col-sm-4">
						<span id="pprice"><fmt:formatNumber value="${res.pprice}" groupingUsed="true"/>원</span>
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
						<input type="text" id="uid" name="uid" class="form-control" value="${res.uid}" readonly>
					</div>
					<div class="col-sm-2"></div>
				</div>
				<div class="row mb-2">
					<div class="col-sm-2"></div>
					<div class="col-sm-4">
						<label for="uname">이름</label>
					</div>
					<div class="col-sm-4">
						<input type="text" id="uname" name="uname" class="form-control" value="${res.uname}" readonly>
					</div>
					<div class="col-sm-2"></div>
				</div>
				<div class="row mb-2">
					<div class="col-sm-2"></div>
					<div class="col-sm-4">
						<label for="utel">전화번호</label>
					</div>
					<div class="col-sm-4">
						<input type="text" id="utel" name="utel" class="form-control" value="${res.utel}" readonly>
					</div>
					<div class="col-sm-2"></div>
				</div>
				
				<c:choose>
					<c:when test="${res.ptype eq '패키지'}">
						<input type="hidden" id="zcode" name="zcode" value="${res.zcode}">
						<input type="hidden" id="addr" name="addr" value="${res.addr}">
						<input type="hidden" id="addr2" name="addr2" value="${res.addr2}">
					</c:when>
				<c:when test="${ res.addr2 eq ''}">
				<div class="row mb-2">
					<div class="col-sm-2"></div>
					<div class="col-sm-4">
						<label for="zcode">우편번호</label>
					</div>
					<div class="col-sm-4">
						<input type="text" id="zcode" name="zcode" class="form-control" value="${res.zcode}" readonly>
					</div>
					<div class="col-sm-2"></div>
				</div>
				<div class="row mb-2">
					<div class="col-sm-2"></div>
					<div class="col-sm-4">
						<label for="addr">주소</label>
					</div>
					<div class="col-sm-4">
						<input type="text" id="addr" name="addr" class="form-control" value="${res.addr}" readonly></div>
					<div class="col-sm-2"></div>
				</div>
				</c:when>
				<c:otherwise>
					<div class="row mb-2">
					<div class="col-sm-2"></div>
					<div class="col-sm-4">
						<label for="zcode">우편번호</label>
					</div>
					<div class="col-sm-4">
						<input type="text" id="zcode" name="zcode" class="form-control" value="${res.zcode}" readonly>
					</div>
					<div class="col-sm-2"></div>
				</div>
				<div class="row mb-2">
					<div class="col-sm-2"></div>
					<div class="col-sm-4">
						<label for="addr">주소</label>
					</div>
					<div class="col-sm-4">
						<input type="text" id="addr" name="addr" class="form-control" value="${res.addr}, ${res.addr2}" readonly></div>
					<div class="col-sm-2"></div>
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
						<input type="date" id="rsday" name="rsday" class="form-control" value="${res.rsday}" readonly>
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
								<input type="text" name="rperiod" id="rperiod" class="form-control" value="${res.rperiod}" readonly>
							</c:when>
							<c:otherwise>
								<input type="text" name="rperiod" id="rperiod" class="form-control" value="${res.rperiod}일" readonly>
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
						<input type="number" id="rcount" name="rcount" min="1" class="form-control" value="${res.rcount}" onClick="slctPname()" readonly/>
					</div>
					<div class="col-sm-2"></div>
				</div>
				<c:choose>
				<c:when test="${res.ptype eq '패키지'}">
				<div class="row mb-2">
					<div class="col-sm-2"></div>
					<div class="col-sm-2">설명</div>
					<div class="col-sm-6">
						<textarea id="rdinfo" name="rdinfo" cols="80" rows="30" class="form-control" readonly>${res.rdinfo}</textarea>
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
						<span id="rtotal"><fmt:formatNumber value="${res.rtotal}" groupingUsed="true"/>원</span>
					</div>
					<div class="col-sm-2"></div>
				</div>
				<div class="row mb-2">
					<div class="col-sm-3"></div>
					<div class="col-sm-2"></div>
					<div class="col-sm-2">
						<input type="button" value="수정" class="btn btn-primary" onClick="location.href='/admin/res/updateRes/rnum/${res.rnum}'">
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