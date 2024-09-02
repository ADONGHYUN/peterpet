<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Peterpet</title>
<style type="text/css">
label, td {
	vertical-align: middle;
}
/* 이미지 */
.image_wrap {
	width: 100%;
	height: auto%;
}

.image_wrap img {
	max-width: 90%;
	height: auto;
	display: block;
}

.bold {
	font-weight: bold;
	font-size: 20px;
}

input[readonly] {
	background-color: #fff;
	color: black;
	border: 1px solid #fff;
	cursor: default;
	outline: none;
	pointer-events: none;
}

.pd {
	padding: 0 12px;
}
.pd1 {
	padding: 8px 12px;
}

.align {
	padding: 0 0 0 8px;
}

.btn-dark {
	margin: 0 8px 0 0;
}
@media (max-width: 576px) {
    body {
        font-size: 0.8rem !important;
    }
}

</style>
</head>
<body>
<body>
	<%@ include file = "/WEB-INF/views/module/c_header.jsp" %>
	<div class="container-fluid">
		<div class="row">
		<div class="col-sm-2"></div>
		<div class="col-sm-8">
		<div class="p-3 my-5 border rounded shadow bg-white">
		<div class="row mt-3">
		<h1 class="text-center">주문 번호 : ${paidList[0].paymentId}</h1>
		<h4 class="text-center mt-1 mb-4">${paidList[0].orderName}</h4>
		<hr>
		<form action="/pay/doPay" method="post" id="insertForm">
			<input type="hidden" id="paymentId" name="paymentId" />
			<div class="row mt-3 mx-2">
				<label class="bold mb-2">주문자 정보</label>
            <div class="col-md-3 mb-3">
            	<input id="uname" class="form-control" name="uname" value="${paidList[0].uname}" readonly>
            </div>
            <div class="col-md-9 mb-3">
                    <input id="utel" class="form-control" name="utel" value="${paidList[0].utel}" readonly>
            </div>
            <div class="col-md-3 mb-3">
            	<input id="zcode" class="form-control" name="zcode" value="${paidList[0].zcode}" readonly>
            </div>
            <div class="col-md-9 mb-3">
            	<input id="addr" class="form-control" name="addr" value="${paidList[0].addr}" readonly>
            </div>
        </div>
			<hr>
			<div>
			<div class="d-flex flex-wrap align-items-center mx-2">
				<label class="bold">주문상품</label>
			</div>
			<c:forEach items="${paidList}" var="pay">
			<div class="row d-flex align-items-center mt-3 mx-2">
				<div class="col-md-3 mb-3">
					<div class="image_wrap me-3">
               			<img class="img-thumbnail" src="${pageContext.request.contextPath}/resources/upload/${pay.pimg1}"
                     		title="${pay.pimg1}" alt="${pay.pimg1}"/>
            		</div>
            	</div>
				<div class="col-md-7 mb-3">
					<input id="pname" class="form-control" name="pname" value="${pay.pname}" readonly>
                	<div class="input-group d-felx align-items-center mb-2 mx-3">
                    	<label>주문 수량 : </label>
                    	<input id="rcount" class="form-control" name="rcount" value="${pay.rcount}" readonly>
                	</div>
                	<label class="form-label mx-3"><fmt:formatNumber value="${pay.pprice}" pattern="#,### 원" /></label>
				</div>
				<div class="col-md-2 mb-3">
					<label class="form-label mx-3 bold"><fmt:formatNumber value="${pay.rtotal}" pattern="#,### 원" /></label>
				</div>
			</div><hr></c:forEach>
        </div>
				<table class="table table-borderless">
				<tr>
					<td class="d-flex justify-content-end"><label class="bold">총 주문금액 : &nbsp;</label><label class="bold"><fmt:formatNumber value="${paidList[0].totalAmount}" pattern="#,### 원" /></label></td>
				</tr>
				</table>
			<div class="d-flex justify-content-end">
				<input type="button" value="주문내역으로 이동" class="btn btn-dark" onclick="location.href='/pay/mypaylist'">
				<input type="button" value="홈" class="btn btn-dark" onclick="location.href='/'">
			</div>
		</form>
		</div>
		</div>
		</div>
			<div class="col-sm-2"></div>
		</div>
</div>
	<%@ include file = "/WEB-INF/views/module/footer.jsp" %>
</body>
</html>