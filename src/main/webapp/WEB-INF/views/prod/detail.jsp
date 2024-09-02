<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html><html><head>
<meta charset="UTF-8">
<title>상품 상세</title>
<style>
body { font-family: Arial, sans-serif; margin: 20px; }
h1 { color: #333; }
.product-container {
	display: flex;
	align-items: flex-start;
	border: 1px solid #ddd;
	border-radius: 5px;
	overflow: hidden;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}
.product-image { width: 30%; padding: 10px; }
.product-image img {
	max-width: 100%;
	height: auto;
	border-radius: 5px;
}
.product-info { width: 70%; padding: 20px; }
.product-info h2 { margin: 0 0 10px; color: #333; }
.product-info p { margin: 5px 0; }
.submit-buttons {
	margin-top: 20px;
	text-align: center;
}
.submit-buttons input {
	padding: 10px 20px;
	font-size: 16px;
	margin: 0 5px;
}
.product-description {
	margin-top: 20px;
	padding: 10px;
	border-top: 1px solid #ddd;
}
.product-description h3 {
	margin-top: 0;
}
.price-display {
	font-weight: bold;
    color: #333;
    margin-top: 10px;
}
</style>
<script>
	function doOrder() {
		$('#payForm').submit();
	}
	function calPrice() {
		var price = ${prod.pprice};
        var quantity = parseInt(document.getElementById('rcount').value);
        if (isNaN(quantity) || quantity < 1) {
        	quantity = 1;
        }
        var total = price * quantity;
        document.getElementById('totalPrice').value = total; // 금액을 문자열로 변환
        document.getElementById('rtotal').value = total;
        document.getElementById('count').value = quantity;
        
        document.getElementById('price').innerText = "결제금액: " + total.toLocaleString() + "원";
    }
	
	function addCart(ff){
		var pcode = ff.pcode.value;
		var addCount = parseInt(ff.rcount.value, 10);
		var addTotal = parseInt(ff.totalPrice.value, 10);
		$.ajax({
			 // 요청
			 type: 'GET',
			 url: '/res/checkRes',
			 data: { pcode: pcode },
			 // 응답
			 dataType: 'json',
			 success: function(resData){
				 if (resData.exist === "1") {
					 const rnum = parseInt(resData.rnum, 10);
					 const bfRcount = parseInt(resData.rcount, 10);
					 const bfRtotal = parseInt(resData.rtotal, 10);
					 const rcount = bfRcount + addCount;
					 const rtotal = bfRtotal + addTotal;
					 console.log("rnum : " + rnum);
					 $.ajax({
							type: 'POST',
							url: '/res/updateRes',
							data: {
								rcount : rcount,
								rtotal : rtotal,
								rnum : rnum
								},
							dataType: 'json',
							success: function(result){
								console.log(result);
								if(result.msg === "success"){
									var userConfirmed = window.confirm("상품이 장바구니에 담겼습니다. 확인하시겠습니까?");
									if (userConfirmed) {
					                    location.href="/res/resList/page/1";
					                } else{
										return false;
									}
								}
							}
						});
				} else {
					var formData = $(ff).serialize();
					$.ajax({
						type: 'POST',
						url: '/res/doRes',
						data: formData,
						dataType: 'json',
						success: function(result){
							console.log(result);
							if(result.msg === "success"){
								var userConfirmed = window.confirm("상품이 장바구니에 담겼습니다. 확인하시겠습니까?");
								if (userConfirmed) {
				                    location.href="/res/resList/page/1";
				                } else{
									return false;
								}
							}
						}
					}); 
				}
			 },
			 error: function(xhr, status, error) {
			        console.error("AJAX 요청 오류:", status, error);
			 }
		});
	}
	window.onload = calPrice;
</script>
</head>
<body>
<%@ include file="/WEB-INF/views/module/c_header.jsp" %>
<div class="container mt-5">
    <h1 class="text-center mb-5">${prod.ptype}</h1>
    <hr>
    <form action="/res/doRes" method="post">
        <input name="pcode" type="hidden" value="${prod.pcode}" />
        <div class="product-container">
            <div class="product-image">
                <img
                    title="${prod.pimg1}" src="${pageContext.request.contextPath}/resources/upload/${prod.pimg1}"
                    alt="${prod.pimg1}" />
            </div>
            <div class="product-info">
                <h2>${prod.pname}</h2>
                <input type="hidden" id="pname" name="pname" value="${prod.pname}">
                <p><strong>가격:</strong><fmt:formatNumber type="number" value="${prod.pprice}" pattern="#,##0" /></p>
                <div class="row">
                	<div class="col-3"></div>
                	<div class="col-3">
                    <label for="rcount">수량:</label></div>
                    <div class="col-3">
                    <input type="number" id="rcount" name="rcount" min="1" value="1" class="form-control" onchange="calPrice()" />
                	</div>
                	<div class="col-3"></div>
                </div>
                <div class="quantity-container">
                    <div class="price-display" id="price"></div>
        			<input type="hidden" id="totalPrice" name="totalPrice" value="">
                </div>
                <div class="submit-buttons">
                    <input type="button" value="장바구니에 추가" class="btn btn-primary" onclick="addCart(this.form)" />
                    <input type="button" value="결제하기" class="btn btn-primary" onclick="doOrder()"/>
                </div>
            </div>
        </div>
    </form>
    <form id="payForm" action="/pay/doOrder" method="post">
    	<input name="pcode" type="hidden" value="${prod.pcode}" />
    	<input type="hidden" id="pimg1" name="pimg1" value="${prod.pimg1}"/>
    	<input type="hidden" id="pname" name="pname" value="${prod.pname}"/>
    	<input type="hidden" id="pprice" name="pprice" value="${prod.pprice}"/>
    	<input type="hidden" id="count" name="count"/>
    	<input type="hidden" id="rtotal" name="rtotal">
    </form>
    <div class="product-description">
        <h3>상품 설명</h3>
        <p>${prod.pdes}</p>
    </div>
    <hr>
    <input type="button" class="btn btn-primary" onclick="locaiont.href='/prod/list'" value="상품 목록">
</div>
<%@ include file="/WEB-INF/views/module/footer.jsp"%>
</body>
</html>
