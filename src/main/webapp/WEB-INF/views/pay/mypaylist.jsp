<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html><html><head><meta charset="UTF-8">
<title>PeterPet</title>
<%@ include file="/WEB-INF/views/module/c_header.jsp"%>
<style>
.imgTd{width:26%;}
/* 이미지 */
.image_wrap{
	width: 50%;
	height: auto%;
}
.image_wrap img{
    max-width: 85%;
    height: auto;
    display: block;		
}
img {

}
</style>
</head>
<body>

	<%@ include file="/WEB-INF/views/module/myinfonav.jsp"%>

	<div class="container d-flex justify-content-center align-items-center">
		<table class="table">
			<tr>
				<th></th>
				<th>주문 명</th>
				<th>결제 가격</th>
				<th>결제 시각</th>
			</tr>
			<c:forEach items="${payList}" var="pay">
			<tr>
			<td class="imgTd"><div class="image_wrap"><img class="img-thumbnail d-block" src="${pageContext.request.contextPath}/resources/upload/${pay.pimg1}"
                            	title="${pay.pimg1}" alt="${pay.pimg1}"/></div></td>
			<td><a href="/pay/getPayDetail/${pay.paymentId}"><c:out value="${pay.orderName}"></c:out></a></td>
			<td><c:out value="${pay.totalAmount}"></c:out></td>
			<td><c:out value="${pay.paydate}"></c:out></td>
			</tr>
			</c:forEach>
		</tbody>
		</table>
	</div>

	<%@include file="/WEB-INF/views/module/footer.jsp"%>
</body>
</html>