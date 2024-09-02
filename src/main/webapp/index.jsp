<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<title>PeterPet</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
.carousel-item img {
	width: 100%;
}
.qpay{
	height:6rem;
	--bs-btn-font-size: 75px; 
}
.img-thumbnail {
		width: 400px !important;
		height: 400px !important;
		border-radius: 10px !important;
		background-color: white;
	}
	
	#prodlink {
		width: 400px;
		color: #495057;
		text-decoration: none;
		-bs-a-hover-color:#495057 !important;
		-bs-a-hover-decoration: underline !important;
		-bs-a-focus-color:#495057 !important;
		-bs-a-focus-decoration: underline !important;
		-bs-a-visite-color:#495057 !important;
		-bs-a-visite-decoration: underline !important;
	}
	.align-middle {
		height: 60px;
		display: inline-block; /* inline 요소에서 vertical-align 적용 */
        vertical-align: middle;
	}
	.prod-nav:hover {
		cursor: pointer;
	}
	#innerdiv, #consection {
		padding: 0px;
	}
	.pname-span {
		width: 400px;
	}
</style>

</head>
<body>
	<input type="hidden" id="contextPath"
		value="${pageContext.request.contextPath}" />
	<%@ include file="/WEB-INF/views/module/c_header.jsp"%>
	<%
	session.removeAttribute("url");
	%>
	<div id="demo" class="carousel slide" data-bs-ride="carousel">

		<!-- Indicators/dots -->
		<div class="carousel-indicators">
			<button type="button" data-bs-target="#demo" data-bs-slide-to="0"
				class="active"></button>
			<button type="button" data-bs-target="#demo" data-bs-slide-to="1"></button>
			<button type="button" data-bs-target="#demo" data-bs-slide-to="2"></button>
			<button type="button" data-bs-target="#demo" data-bs-slide-to="3"></button>
		</div>

		<!-- The slideshow/carousel -->
		<div class="carousel-inner">
			<div class="carousel-item active">
				<img src="<%=request.getContextPath()%>/resources/banner_walk.jpg"
					alt="dog1" class="d-block" style="width: 100%;">
				<div class="carousel-caption">
					<h3>유치원</h3>
					<p>예절 교육 등 다양한 커리큘럼</p>
				</div>
			</div>
			<div class="carousel-item">
				<img src="<%=request.getContextPath()%>/resources/banner_hotel.jpg"
					alt="dog2" class="d-block" style="width: 100%">
				<div class="carousel-caption">
					<h3>호텔링</h3>
					<p>장기간 떨어져 있어도 안심</p>
				</div>
			</div>
			<div class="carousel-item">
				<img src="<%=request.getContextPath()%>/resources/banner_spa.jpg"
					alt="dog3" class="d-block" style="width: 100%">
				<div class="carousel-caption">
					<h3>그루밍</h3>
					<p>스트레스를 덜어주는 그루밍 서비스</p>
				</div>
			</div>
			<div class="carousel-item">
				<img src="<%=request.getContextPath()%>/resources/banner_food.jpg"
					alt="dog4" class="d-block" style="width: 100%">
				<div class="carousel-caption">
					<h3>각종 용품</h3>
					<p>반려 동물들을 위한 각종 상품 판매</p>
				</div>
			</div>
		</div>

		<!-- Left and right controls/icons -->
		<button class="carousel-control-prev" type="button"
			data-bs-target="#demo" data-bs-slide="prev">
			<span class="carousel-control-prev-icon"></span>
		</button>
		<button class="carousel-control-next" type="button"
			data-bs-target="#demo" data-bs-slide="next">
			<span class="carousel-control-next-icon"></span>
		</button>
	</div>
	<div class="text-center d-grid">
		<button type="button" class="btn btn-primary btn-block qpay rounded-0" onclick=''><h1>돌봄 간편 결제</h1></button>
	</div>
	<div class="container mt-5 mb-5">
		<div class="text-center">
			<h2>베스트 상품</h2>
			<div id="bestSpace" class="row">
			<table class="table-borderless">
				<tr id="bestProdList">
					
				</tr>
			</table>
			</div>
		</div>
	</div>
	<script type="text/javascript">
	$(document).ready(function() {
            $.ajax({
                url: '/pay/bestProdList', // 서버에서 JSON 데이터를 반환하는 메서드의 URL
                type: 'GET',
                dataType: 'json', // 서버가 JSON 데이터를 반환한다고 명시
                success: function(data) {
                	console.log(data);
                    // JSON 데이터를 성공적으로 받아온 후 처리
                    //받아오는 데이터: pcode pimg1 pname pprice
                    let result = '';
                    $.each(data, function(index, prod) {
                    	console.log(index);
                    	result += '<td>'+'<form action="/res/doRes" method="post">'+
                    	'<input name="pcode" type="hidden" value="'+prod.pcode+'" />'+
                    	'<input type="hidden" id="pname" name="pname" value="'+prod.pname+'">'+
                    	'<input type="hidden" id="rcount" name="rcount" value="1" />'+
                    	'<input type="hidden" id="totalPrice" name="totalPrice" value="'+prod.pprice+'">'+
                        '<div class="pt-3 d-flex justify-content-center">'+
                        '<a id="prodlink" href="prod/detail/pcode/'+prod.pcode+'">'+
                            '<img class="d-block img-thumbnail" title="'+prod.pimg1+'" alt="'+prod.pimg1+'"'+
                            'src="${pageContext.request.contextPath}/resources/upload/'+prod.pimg1+'" />'+
                            '<br>'+
                            '<span class="text-center align-middle d-block fs-5 pname-span">'+prod.pname+'</span>'+
                        '<span class="d-block pb-2 fs-4">'+prod.pprice.toLocaleString()+'원</span></a>'+
                    
                    '</div>'+
                    '<div class="submit-buttons">'+
                    '<input type="button" value="장바구니에 추가" class="btn btn-primary" onclick="addCart(this.form)" /> '+
                    '<input type="button" value="구매하기" class="btn btn-primary" onclick="doOrder('+index+')"/>'+
                '</div></form>'+
                '<form id="payForm'+index+'" action="/pay/doOrder" method="post">'+
            	'<input name="pcode" type="hidden" value="'+prod.pcode+'" />'+
            	'<input type="hidden" id="pimg1" name="pimg1" value="'+prod.pimg1+'"/>'+
            	'<input type="hidden" id="pname" name="pname" value="'+prod.pname+'/>'+
            	'<input type="hidden" id="pprice" name="pprice" value="'+prod.pprice+'"/>'+
            	'<input type="hidden" id="count" name="count" value="1"/>'+
            	'<input type="hidden" id="rtotal" name="rtotal" value="'+prod.pprice+'">'+
            	'</form>'+
                '</td>';
                    });
                    $('#bestProdList').html(result);
                },
                error: function(xhr, status, error) {
                    // 오류 처리
                    console.error('AJAX error:', status, error);
                }
            });
        });
	
	function doOrder(n) {
		console.log('#payForm'+n);
		$('#payForm'+n).submit();
	}
   
function addCart(ff){
		
		var uid = '<%=loginID%>';
		console.log(uid);
		if(uid=='null'){
			location.href='/login';
		}
		
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
				 console.log(resData);
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
	</script>
	<%@ include file="WEB-INF/views/module/footer.jsp"%>
</body>
</html>