<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="/resources/script/myInfo.js"></script>
<title>PeterPet</title>
</head>
<body>
	<%@ include file="/WEB-INF/views/module/c_header.jsp"%>
	<%@ include file="/WEB-INF/views/module/myinfonav.jsp"%>
	
	
	<div class="container d-flex justify-content-center align-items-center">
		<div class="form-container">
			<form id="info">
				<table class="table">
					<tr>
						<td><label for="uid">아이디</label></td>
						<td><div class="input-group">
								<input id="uid" class="form-control" name="uid" disabled>
							</div></td>
					</tr>
					<tr id="snsTr" class="d-none">
						<td><label for="SNS">SNS</label></td>
						<td><div class="input-group">
								<button id="deleteAPI1" type="button"
								class="btn d-none"></button>
								<button id="deleteAPI2" type="button"
								class="btn d-none"></button>
							</div></td>
					</tr>
					<tr id="PWtr" class="d-none">
						<td><label for="upw">비밀번호</label></td>
						<td>
							<button id="changePW" type="button"
								class="btn btn-primary d-none">비밀번호 변경</button>
						</td>
					</tr>
					<tr>
						<td><label for="uname">이름</label></td>
						<td><input id="uname" class="form-control" name="uname"
							value="${myinfo.uname }" disabled></td>
					</tr>
					<tr>
						<td><label for="utel">연락처</label></td>
						<td><input id="utel" class="form-control" name="utel"
							type="tel" maxlength="11" minlength="9" pattern="\d*"
							placeholder="연락처는 '-' 없이 숫자만 입력해주세요." value="${myinfo.utel }"
							disabled><div id="telmsg"></div>
							<div></div></td>
					</tr>
					<tr>
						<td><label for="uemail">이메일</label></td>
						<td><input id="uemail" class="form-control" name="uemail"
							type="email" value="${myinfo.uemail }" disabled><div id="mailmsg"></div></td>
					</tr>
					<tr>
						<td><label for="ubirth">생년월일</label></td>
						<td><input id="ubirth" class="form-control" name="ubirth"
							maxlength="8" minlength="8" pattern="\d*"
							placeholder="8자리 숫자만 입력해주세요 예)19900505" value="${myinfo.ubirth }"
							disabled></td>
					</tr>
					<tr>
						<td><label for="male">성별</label></td>
						<td><input id="ugender" name="ugender" class="form-control"
							type="text" value="${myinfo.ugender }" disabled></td>
					</tr>
					<tr>
						<td>주소</td>
						<td>
						<div class="input-group">
							<input type="text" id="sample4_postcode" name="zcode"
									class="form-control" value="${myinfo.zcode }"
									placeholder="우편번호" maxlength="5" minlength="5" disabled>
							<input type="button" id="findPostcode"
									class="btn btn-primary form-button-input"
									onclick="sample4_execDaumPostcode()" value="우편번호 찾기" disabled>
							</div>
							<input type="text" class="form-control" id="sample4_roadAddress"
									placeholder="도로명주소" name="addr" value="${myinfo.addr }" disabled>
							<input type="text" class="form-control" id="sample4_jibunAddress"
									placeholder="지번주소" disabled>
							<span id="guide" style="color: #999; display: none"></span>
							<input type="text" class="form-control" id="sample4_detailAddress" placeholder="상세주소"
									name="addr2" value="${myinfo.addr2 }" disabled>
							<input type="hidden" id="sample4_extraAddress" name="extraAddress" disabled>
						</td>
					</tr>
				</table>
				<div class="form-group row mb-3 text-center">
					<button id="editProfile" type="button" class="btn btn-primary">정보수정</button>
					<div class="form-group row mb-3 text-center">
						<div class="col-6 text-start">
							<button id="deleteAccount" type="button"
								class="btn btn-danger d-none">탈퇴</button>
						</div>
						<div class="col-6 text-end">
							<button id="cancle" type="button" class="btn btn-secondary d-none">취소</button>&nbsp;
							<button id="save" type="button" class="btn btn-primary d-none">저장</button>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
	<%@ include file="/WEB-INF/views/module/footer.jsp"%>
	<script>
	window.type = '${type}';
    window.id = '${myinfo.uid }';
	</script>
</body></html>
