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
	white-space: nowrap;
	vertical-align: middle;
}

.imgTd {
	width: 26%;
}
/* 이미지 */
.image_wrap {
	width: 50%;
	height: auto%;
}

.image_wrap img {
	max-width: 85%;
	height: auto;
	display: block;
}

.bold {
	font-weight: bold;
	font-size: 20px;
}

.delivery {
	width: 85%;
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
<script src="https://cdn.portone.io/v2/browser-sdk.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript">
console.log('${res.addr}');
if ('${res.addr}'.includes(',')) {
	var addr = '${res.addr}'.split(',');
	var addr1 = addr[0];
	var addr2 = addr[1];
} else {
	var addr1 = addr;
	var addr2 = "";
}

function serializeToJson(queryString) {
    // 쿼리 문자열을 '&'로 분리하여 키-값 쌍을 배열로 변환
    return queryString
        .slice(queryString.indexOf('?') + 1) // ? 제거
        .split('&') // '&'로 분리
        .map(function(part) {
            return part.split('=').map(decodeURIComponent); // '='으로 분리 후 디코딩
        })
        .reduce(function (acc, curr) {
            var key = curr[0];
            var value = curr[1];
            if (acc[key]) {
                // 이미 키가 존재하면 배열에 추가
                if (Array.isArray(acc[key])) {
                    acc[key].push(value);
                } else {
                    acc[key] = [acc[key], value];
                }
            } else {
                acc[key] = value;
            }
            return acc;
        }, {});
}

async function doKakao() {
	const paymentId = createOrderNum();
	console.log("paymentID" + paymentId);
	$('#paymentId').val(paymentId);
	
	const payBean = [{
		paymentId : paymentId,
		orderName: "${res.pname}",
        totalAmount: parseInt($('#rtotal').val(), 10),
        uid: "${res.uid}",
        uname: "${res.uname}",
        utel: "${res.utel}",
        addr: "${res.addr}",
        zcode: "${res.zcode}",
        pcode: "${res.pcode}",
        pname: "${res.pname}",
        pimg1: "${res.pimg1}",
        pprice: "${res.pprice}",
        ptype: "${res.ptype}",
        rcount: "${res.rcount}",
        rtotal: "${res.rtotal}",
        rdinfo: "일반 상품",
        rsday: "2300-01-01",
        rperiod: "1",
        reday: "2300-01-01",
        rnumList: []
	}]
	
	const jsonData = JSON.stringify(payBean, null, 2);
	
	console.log(jsonData);
	
	try {
		// AJAX 요청
		const result = await new Promise((resolve, reject) => {
			$.ajax({
				type : 'POST',
				url : './insertKakaoPay',
				data : jsonData,
				contentType: 'application/json',
				success : function(result) {
					console.log('서버에서 받은 데이터:', result);
	
					if (result.n < 1) {
						alert("결제 데이터 저장 실패");
						reject(new Error("결제 데이터 저장 실패"));
					} else {
						resolve(result);
					}
					
				},
				error : function(xhr, status, error) {
					console.log('서버에서 받은 데이터:', result);
					console.error('AJAX 오류 발생:', status, error);
					reject(new Error('AJAX 오류 발생: ' + status));
				}
			});
		});
		
		console.log('const result의 값: ', result);
		
		const response = await PortOne.requestPayment({
			// Store ID 설정
			storeId : "store-3e1256db-ab78-402b-b63f-03cf01111360",
			// 채널 키 설정
			channelKey : "channel-key-13721a43-0ead-4b1d-8767-00a623cf1571",
			paymentId : paymentId,
			orderName : "${res.pname}",
			totalAmount : parseInt($('#rtotal').val(), 10),
			currency : "KRW",
			isTestChannel : true,
			payMethod : "EASY_PAY",
			customer : {
				"customerId" : "${res.uid}",
				"fullName" : "${res.uname}",
				"phoneNumber" : "${res.utel}",
				"address" : {
					"country" : "KR",
					"addressLine1" : addr1,
					"addressLine2" : addr2,
					"zipcode" : "${res.zcode}"
					}
				},
			windowType : {
				"pc" : "IFRAME",
				"mobile" : "REDIRECTION"
				},
			easyPay : {
				"easyPayProvider" : "KAKAOPAY"
				}
		});
		
		console.log(response);
		
		const transactionType = response.transactionType;
		const txId = response.txId;
		const code = "결제완료";
		const status = "결제완료";
		
		if (response.code != null) {
			const code = response.code;
			// status 요청 오류, code는 받은 값 그대로 update
		    // 결제 과정에서 오류 발생
		    return alert(response.message);
		}
		
		  // 고객사 서버에서 /pay/complete 엔드포인트를 구현해야 합니다.
		  const notified = await fetch('/pay/complete', {
		    method: "POST",
		    headers: { "Content-Type": "application/json" },
		    // paymentId와 주문 정보를 서버에 전달합니다
		    body: JSON.stringify({
		    	"paymentId" : paymentId,
		    	"transactionType" : transactionType,
		    	"txId" : txId,
		    	"code" : code,
		    	"status" : status,
		    	"rnumList" : []
			})

		 });
		  console.log(notified);
		 
		  
		  if (notified.ok) {
		        // 응답이 성공적일 경우
		        const responseData = await notified.text();

		        if (responseData) {
		        	alert('결제 완료되었습니다.');
		            window.location.href = '/pay/getPayDetail/' + paymentId; // 리디렉션
		        } else {
		        	alert('결제 실패.');
		            console.error('응답 본문이 비어있습니다.');
		        }
		    } else {
		        // 응답이 실패할 경우
		        console.error('응답 실패:', notified.status);
		    }
	} catch (error) {
		console.error("Payment error:", error);
        alert("결제 처리 중 오류가 발생했습니다.");
	}
}
</script>
</head>
<body>
<%@ include file="/WEB-INF/views/module/c_header.jsp"%>
	<div class="container-fluid p-5 my-5">
		<div class="p-5 my-5 border rounded">
		<div class="row">
			<div class="col-sm-2"></div>
			<div class="col-sm-8">
		<h1 class="text-center">주문/결제</h1>
		<hr>
		<form action="/pay/doPay" method="post" class="" id="doPayForm">
			<input type="hidden" id="paymentId" name="paymentId" />
			<table class="table table-responsive">
				<tr>
					<td><label class="bold">배송지</label></td>
					<td><div class="d-flex justify-content-end">
						<input type="button" class="btn btn-dark" id="post" name="post" 
							data-bs-toggle="modal" data-bs-target="#myModal" value="변&nbsp;경" />
					</div></td>
				</tr>
				<tr>
					<td><label for="uname">이름</label></td>
					<td><input id="uname" class="form-control" name="uname" value="${res.uname}" readonly></td>
				</tr>
				<tr>
					<td><label for="utel">연락처</label></td>
					<td><input id="utel" class="form-control" name="utel" value="${res.utel}" readonly></td>
				</tr>
				<tr>
					<td><label for="addr">주소</label></td>
					<td><input id="addr" class="form-control" name="addr" value="${res.addr}" readonly></td>
				</tr>
				<tr>
					<td><label for="zcode">우편번호</label></td>
					<td><input id="zcode" class="form-control" name="zcode" value="${res.zcode}" readonly></td>
				</tr>
			</table>
			<br>
			<table class="table table-responsive">
				<tr><td><label class="bold">주문상품</label></td></tr>
				<tr>
					<td class="imgTd"><div class="image_wrap">
						<img class="img-thumbnail d-block" src="${pageContext.request.contextPath}/resources/upload/${res.pimg1}"
							title="${res.pimg1}" alt="${res.pimg1}" />
					</div></td>
					<td><div class="align">
						<input id="pname" class="form-control" name="pname" value="${res.pname}" readonly>
						<div class="input-group pd">
							<label class="d-flex align-items-center">주문 수량 : </label>
							<input id="rcount" class="form-control" name="rcount" value="${res.rcount}" readonly>
						</div>
						<label class="pd"><fmt:formatNumber value="${res.pprice}" pattern="#,### 원" /></label>
					</div></td>
				</tr>
			</table>
			<br> <br>
			<table class="table table-responsive">
				<tr>
					<td><label class="bold">총 주문금액</label></td>
					<td>
						<label class="d-flex justify-content-end bold">
						<fmt:formatNumber value="${res.rtotal}" pattern="#,### 원" /></label></td>
				</tr>
			</table>
			<input type="hidden" id="rtotal" class="form-control" name="rtotal" value="${res.rtotal}">
			<input type="hidden" id="pprice" class="form-control" name="pprice" value="${res.pprice}">
			<input type="hidden" id="pcode" class="form-control" name="pcode" value="${res.pcode}">
			<input type="hidden" id="ptype" class="form-control" name="ptype" value="${res.ptype}">
			<input type="hidden" id="pimg1" class="form-control" name="pimg1" value="${res.pimg1}">
			
			


			<div class="d-flex justify-content-end">
				<input type="button" value="카드 결제" class="btn btn-secondary" onclick="doKcp()">
				<input type="button" value="KAKAOPAY 결제" onclick="doKakao()" class="btn btn-warning text-white">
			</div>
		</form>
		</div>
			<div class="col-sm-2"></div>
		</div>
	</div>
	</div>
	
	<!-- ChangeAddr Modal -->
	<div class="modal" id="myModal">
  		<div class="modal-dialog">
    		<div class="modal-content">

      		<!-- Modal Header -->
      		<div class="modal-header">
        		<h4 class="modal-title">배송지 변경</h4>
        		<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      		</div>

      		<!-- Modal body -->
      		<div class="modal-body">
      			<input type="text" class="form-control" id="newName" placeholder="이름" name="newName">
      			<input type="text" class="form-control" id="newTel" placeholder="01012341234" maxlength="11" name="newTel">
      			<div class="row">
      				<div class="col-6">
    					<input type="text" class="form-control" id="zip" placeholder="우편번호" name="ZCODE">
    				</div>
    				<div class="col-6">
    					<input style="width:100%;" type="button" class="btn btn-dark" onclick="execPostcode()" value="주소 찾기">
    				</div>
    			</div>
    			<input type="text" class="form-control" id="newADDR" placeholder="도로명주소" name="newADDR">
   				<input type="text" class="form-control" id="oldADDR" placeholder="지번주소" name="oldADDR">
   				<input type="text" class="form-control" id="ADDR1" placeholder="상세주소" name="ADDR1"></div>
   			<div class="col-sm-3"></div>

      		<!-- Modal footer -->
      		<div class="modal-footer">
      			<button type="button" class="btn btn-dark" onclick="chgAddr()" data-bs-dismiss="modal">변경</button>
        		<button type="button" class="btn btn-dark" data-bs-dismiss="modal">취소</button>
      		</div>
    		</div>
  		</div>
	</div>
	
<%@ include file="/WEB-INF/views/module/footer.jsp"%>

<script>
	function doKcp(){
		const paymentId = createOrderNum();
		document.getElementById('paymentId').value = paymentId;
		console.log("paymenyId : " + paymentId);
		var formData = $('#doPayForm').serialize();
		$.ajax({
			type: 'POST',
			url: '/pay/insertKcp',
			data: formData,
			dataType: 'json',
			success: function(result){
				console.log(result);
				if(result.msg === "success"){
					console.log("결제 데이터 입력 완료");
					doPortOne(paymentId);
				}else{
					console.log("결제 데이터 입력 실패");
					alert("결제 요청에 실패했습니다. 다시 시도해주세요.");
				}
			},
			error: function(xhr, status, error) {
		        console.error("AJAX 요청 오류:", status, error);
		 	}
		}); 
	}
	
	async function doPortOne(paymentId){
		try {
			const response = await PortOne.requestPayment({
				storeId: "store-3e1256db-ab78-402b-b63f-03cf01111360",
				channelKey: "channel-key-16845740-5013-443f-a6ba-152e597437f9",
				paymentId: paymentId,
				orderName: "${res.pname}",
				totalAmount: "${res.rtotal}",
				currency: "CURRENCY_KRW",
				payMethod: "CARD",
				card: {
					installment: {
						monthOption: {
							fixedMonth: 0,
						},
					},
					useAppCardOnly: true,
				}
			});
			
			const status = "결제완료";
			
			if(response.code != null){
				$.ajax({
					type: 'POST',
					url: '/pay/failPay',
					data: { paymentId : response.paymentId },
					dataType: 'json',
					success: function(result){
						console.log(result);
						if(result.msg === "success"){
							console.log("요청 결제 내역 삭제 완료");
							console.log("code값 in failpay : " + response.code);
						}
					},
					error: function(xhr, status, error) {
				        console.error("AJAX 요청 오류:", status, error);
					}
				});
				return alert(response.message);	
			}
		
			const notified = await fetch("/pay/kcpcomplete", {
				method: "POST",
		    	headers: { "Content-Type": "application/json" },
		    	body: JSON.stringify({
		    		"uid": "${res.uid}",
		    		"paymentId": response.paymentId
		    	})
			});
			
			if (notified.ok) {
            	const text = await notified.text(); // 문자열로 응답 본문 읽기
            	console.log(text);
				location.href = "/pay/getPayDetail/" + paymentId;
            
        	} else {
        		$.ajax({
					type: 'POST',
					url: '/pay/failPay',
					data: { paymentId : paymentId },
					dataType: 'json',
					success: function(result){
						console.log(result);
						if(result.msg === "success"){
							console.log("요청 결제 내역 삭제 완료");
						}
					},
					error: function(xhr, status, error) {
				        console.error("AJAX 요청 오류:", status, error);
					}
				});
            	console.error("응답 실패:", notified.statusText);
        	}
    	} catch (error) {
    		$.ajax({
				type: 'POST',
				url: '/pay/failPay',
				data: { paymentId : response.paymentId },
				dataType: 'json',
				success: function(result){
					console.log(result);
					if(result.msg === "success"){
						console.log("요청 결제 내역 삭제 완료");
						console.log("code값 in failpay : " + response.code);
					}
				},
				error: function(xhr, status, error) {
			        console.error("AJAX 요청 오류:", status, error);
				}
			});
        	console.error("네트워크 오류:", error);
    	}
	}

	function createOrderNum() {
		// 현재 날짜 기준으로 주문 번호의 기본 형태 생성
		const date = new Date();
		const year = date.getFullYear();
		const month = String(date.getMonth() + 1).padStart(2, "0");
		const day = String(date.getDate()).padStart(2, "0");
	    const hours = String(date.getHours()).padStart(2, "0");
	    const minutes = String(date.getMinutes()).padStart(2, "0");
	    const seconds = String(date.getSeconds()).padStart(2, "0");
		
		var orderNum = year + month + day + hours + minutes + seconds;
		for(var i = 0; i < 6; i++) { // 6개의 랜덤 숫자 생성
			// Math.random() 		0과 1사이의 실수를 랜덤 반환
			// Math.random() * 9 	0과 9사이의 실수 랜덤 반환
			// Math.floor() 		해당 실수를 정수로 내림
			orderNum += Math.floor(Math.random() * 9);
		}
		console.log("주문번호 랜덤 생성: ", orderNum);
		return orderNum;
	}
	
	function execPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                var roadAddr = data.roadAddress; // 도로명 주소 변수

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('zip').value = data.zonecode;
                document.getElementById("newADDR").value = roadAddr;
                document.getElementById("oldADDR").value = data.jibunAddress;
                
            }
        }).open();
    }
	
	function chgAddr(){
		var chgName = document.getElementById('newName').value;
		var chgTel = document.getElementById('newTel').value;
		var chgZip = document.getElementById('zip').value;
		var roadAddr = document.getElementById('newADDR').value;
		var detail = document.getElementById('ADDR1').value;
		document.getElementById('uname').value = chgName;
		document.getElementById('utel').value = chgTel;
		document.getElementById('zcode').value = chgZip;
		document.getElementById('addr').value = roadAddr + ", " + detail;
	}
</script>
</body>
</html>