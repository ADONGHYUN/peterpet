<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.net.URLEncoder" %>
<%
response.setHeader("Pragma", "no-cache");
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Cache-Control", "no-store");
response.setDateHeader("Expires", 0L);
%>
<!DOCTYPE html>
<html>
<head>
<style>
input[readonly] {
	background-color: #F6F6F6;
	pointer-events: none;
}
.fontsize {font-size:17px;}
</style>
<title>회원 수정</title>
</head>
<body>
	<%@ include file="/WEB-INF/views/module/anav.jsp"%>
	<section id="memberUpdate">
		<form action="/admin/user/update/${vo.page}/${vo.searchCondition}?searchKeyword=${vo.searchKeyword}" id="updateForm" method="POST" class="mt-5 mb-5">
			<div class="container">
				<div class="row">
					<div class="col-sm-2"></div>
					<div class="col-sm-8 text-center"><h2>${user.uname}님 회원정보</h2></div>
					<div class="col-sm-2"></div>
				</div>
				<div class="row mb-3 mt-5 fontsize">
					<div class="col-sm-2"></div>
					<div class="col-sm-1"><label for="uid" class="form-label">아이디</label></div>
					<div class="col-sm-7"><input type="text" class="form-control" id="uid" name="uid" value="${user.uid}" readonly></div>
					<div class="col-sm-2"></div>
				</div>
				<div class="row mb-3 fontsize">
					<div class="col-sm-2"></div>
					<div class="col-sm-1"><label for="uname" class="form-label"><span style="color:red;">* </span>이름</label></div>
					<div class="col-sm-7"><input type="text" class="form-control" id="uname" name="uname" value="${user.uname}" onkeyup="validation()" required/></div>
					<div class="col-sm-2"></div>
				</div>
				<div class="row mb-3 fontsize">
					<div class="col-sm-2"></div>
					<div class="col-sm-1"><label for="utel" class="form-label"><span style="color:red;">* </span>전화번호</label></div> 
					<div class="col-sm-7"><input type="text" class="form-control" id="utel" name="utel" value="${user.utel}" onkeyup="validation()" placeholder="ex) 01012345678" maxlength="11"></div>
					<div class="col-sm-2"></div>
				</div>
				<div class="row mb-3 fontsize">
					<div class="col-sm-2"></div>
					<div class="col-sm-1"><label for="uemail" class="form-label"><span style="color:red;">* </span>이메일</label></div> 
					<div class="col-sm-7"><input type="email" class="form-control" id="uemail" name="uemail" value="${user.uemail}" onkeyup="validation()" placeholder="ex) 111@naver.com"></div>
					<div class="col-sm-2"></div>
				</div>
				<div class="row mb-3 fontsize">
					<div class="col-sm-2"></div>
					<div class="col-sm-1"><label for="ubirth" class="form-label">생년월일</label></div>
					<div class="col-sm-7"><input type="text" class="form-control" id="ubirth" name="ubirth" value="${user.ubirth}" readonly></div>
					<div class="col-sm-2"></div>
				</div>
				<div class="row mb-3 fontsize">
					<div class="col-sm-2"></div>
					<div class="col-sm-1"><label for="ugender" class="form-label">성별</label></div>
					<div class="col-sm-7"><input type="text" class="form-control" id="ugender" name="ugender" value="${user.ugender}" readonly></div>
					<div class="col-sm-2"></div>
				</div>
				<div class="row mb-3 fontsize"> 
					<div class="col-sm-2"></div>
					<div class="col-sm-1"><label for="zcode" class="form-label">우편번호</label></div>
					<div class="col-sm-7">
						<div class="input-group">
							<input type="text" class="form-control" id="zcode" name="zcode" style="border-right:none;" value="${user.zcode}" maxlength="5">
							<button type="button" class="btn btn-sm btn-outline-dark" onclick="execDaumPostcode()" style="width:100px;">주소찾기</button>
						</div>
					</div>
					<div class="col-sm-2"></div>
				</div>
				<div class="row mb-3 fontsize">
					<div class="col-sm-2"></div>
					<div class="col-sm-1"><label for="addr" class="form-label">주소</label></div>
					<div class="col-sm-7"><input type="text" class="form-control" id="addr" name="addr" value="${user.addr}"></div>
					<div class="col-sm-2"></div>
				</div>
				<div class="row mb-3 fontsize">
					<div class="col-sm-2"></div>
					<div class="col-sm-1"><label for="addr2" class="form-label">상세 주소</label></div>
					<div class="col-sm-7"><input type="text" class="form-control" id="addr" name="addr2" value="${user.addr2}"></div>
					<div class="col-sm-2"></div>
				</div>
				<div class="row mb-3 fontsize">
					<div class="col-sm-2"></div>
					<div class="col-sm-1"><label for="joindate" class="form-label">가입일</label></div>
					<div class="col-sm-7"><input type="text" class="form-control" id="joindate" name="joindate" value="${user.joindate}" readonly></div>
					<div class="col-sm-2"></div>
				</div>

				<div id="changeBtn" class="row text-end">
					<div class="col-sm-2"></div>
					<div class="col-sm-8 text-end">
						 <button type="submit" class="btn btn-sm btn-dark" id="updateBtn" style="width:90px; font-size: 16px;">수정하기</button>

						<button type="button" class="btn btn-sm btn-outline-dark" style="width:90px; font-size: 16px;" onclick="goMemberList()">회원목록</button>
					</div>
					<div class="col-sm-2"></div>
				</div>
			</div>
		</form>
	</section>
	
	<jsp:include page="/WEB-INF/views/module/footer.jsp"/>
	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script>
	function execDaumPostcode() {
		new daum.Postcode({
			oncomplete : function(data) {
				var addr = '';
				
				if (data.userSelectedType === 'R') {
					addr = data.roadAddress;
				} else {
					addr = data.jibunAddress;
				}

				document.getElementById('zcode').value = data.zonecode;

				var addressInput = document.getElementById("addr");

				var detailAddress = " (상세주소)";

				addressInput.value = addr + detailAddress;

				var cursorPosition = addr.length;
				var detailLength = detailAddress.length;
				addressInput.setSelectionRange(cursorPosition + 1,
						cursorPosition + detailLength);
				addressInput.focus();

			}
		}).open();
	}


	
	

	// 회원목록으로
	function goMemberList() {
    const page = encodeURIComponent('${vo.page}');
    const searchCondition = encodeURIComponent('${vo.searchCondition}');
    const searchKeyword = encodeURIComponent('${vo.searchKeyword}');

    const url = `/admin/user/getlist/${vo.page}/${vo.searchCondition}?searchKeyword=${vo.searchKeyword}`;
    location.href = url;
}
	
	function validation() {
		var uname = document.getElementById("uname");
		var tel = document.getElementById("utel");
		var email = document.getElementById("uemail");
		
		if(uname.value.length > 0 && tel.value.length > 0 && email.value.length > 0) {
			document.getElementById("updateBtn").disabled = false;	
		} else {
			document.getElementById("updateBtn").disabled = true;
		}
	}
	</script>

</body>
</html>
