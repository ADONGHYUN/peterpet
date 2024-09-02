<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Peterpet</title>
<style type="text/css">
label, td {
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

INPUT[READONLY] { 
	BACKGROUND-COLOR: #FFF;
	COLOR: BLACK;
	BORDER: 1PX SOLID #FFF;
 	CURSOR: DEFAULT;
 	OUTLINE: NONE;
	POINTER-EVENTS: NONE;
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
	console.log('${user.addr}');
	if ('${user.addr}'.includes(',')) {
		var addr = '${user.addr}'.split(',');
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
	
	function serializeToArray(jsonData) {
		
		if (!jsonData) {
	        console.error("jsonData는 null 또는 undefined일 수 없습니다.");
	        return [];
	    }
		
		if (!jsonData.pcode || !jsonData.pname) {
	        console.error("jsonData.pcode와 jsonData.pname이 필요합니다.");
	        return [];
	    }
		
		// 배열 확인
		let pcodeArray = Array.isArray(jsonData.pcode) ? jsonData.pcode : [jsonData.pcode];
	    let pnameArray = Array.isArray(jsonData.pname) ? jsonData.pname : [jsonData.pname];
	    let pimg1Array = Array.isArray(jsonData.pimg1) ? jsonData.pimg1 : [jsonData.pimg1];
	    let ppriceArray = Array.isArray(jsonData.pprice) ? jsonData.pprice : [jsonData.pprice];
	    let ptypeArray = Array.isArray(jsonData.ptype) ? jsonData.ptype : [jsonData.ptype];
	    let rcountArray = Array.isArray(jsonData.rcount) ? jsonData.rcount : [jsonData.rcount];
	    let rtotalArray = Array.isArray(jsonData.rtotal) ? jsonData.rtotal : [jsonData.rtotal];
	    let rdinfoArray = Array.isArray(jsonData.rdinfo) ? jsonData.rdinfo : [jsonData.rdinfo];
	    let rsdayArray = Array.isArray(jsonData.rsday) ? jsonData.rsday : [jsonData.rsday];
	    let rperiodArray = Array.isArray(jsonData.rperiod) ? jsonData.rperiod : [jsonData.rperiod];
	    let redayArray = Array.isArray(jsonData.reday) ? jsonData.reday : [jsonData.reday];
	    let rnumListArray = Array.isArray(jsonData.rnum) ? jsonData.rnum : [jsonData.rnum];
		
	    // orderName 생성
	    let orderName;
	    if (pnameArray.length === 1) {
	        orderName = pnameArray[0];
	    } else {
	        orderName = pnameArray[0] + " 외 " + (pnameArray.length - 1) + "개";
	    }
	    
		const result = pcodeArray.map((code, index) => ({
	        paymentId: jsonData.paymentId,
	        orderName: orderName,
	        totalAmount: jsonData.totalAmount,
	        uid: jsonData.uid,
	        uname: jsonData.uname,
	        utel: jsonData.utel,
	        addr: jsonData.addr,
	        zcode: jsonData.zcode,
	        pcode: code,
	        pname: pnameArray[index],
	        pimg1: pimg1Array[index],
	        pprice: ppriceArray[index],
	        ptype: ptypeArray[index],
	        rcount: rcountArray[index],
	        rtotal: rtotalArray[index],
	        rdinfo: rdinfoArray[index],
	        rsday: rsdayArray[index],
	        rperiod: rperiodArray[index],
	        reday: redayArray[index],
	        rnumList: [rnumListArray[index]]
		}));
		
		return JSON.stringify(result, null, 2);
	}
	
	async function doKakao() {
		const paymentId = createOrderNum();
		$('#paymentId').val(paymentId);
		const totalAmount = ${totalAmount};
		
		const queryString = $("#doPayForm").serialize();
		
		const jsonData = serializeToJson(queryString);
		console.log(jsonData);
		const orderName = jsonData.pname[0] + " 외 " + (jsonData.pname.length - 1) + "개";
		const jsonArray = serializeToArray(jsonData);
		console.log(jsonArray);
		
		try {
			// AJAX 요청
			const result = await new Promise((resolve, reject) => {
				$.ajax({
					type : 'POST',
					url : './insertKakaoPay',
					data : jsonArray,
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
			
			var rnumList;
			
			if (Array.isArray(result.rnumList)) {
				rnumList = result.rnumList; // 이미 배열이므로 그대로 사용
			} else {
				rnumList = [result.rnumList]; // 단일 값일 경우 배열로 변환
			}
			
			const response = await PortOne.requestPayment({
				// Store ID 설정
				storeId : "store-3e1256db-ab78-402b-b63f-03cf01111360",
				// 채널 키 설정
				channelKey : "channel-key-13721a43-0ead-4b1d-8767-00a623cf1571",
				paymentId : paymentId,
				orderName : orderName,
				totalAmount : totalAmount,
				currency : "KRW",
				isTestChannel : true,
				payMethod : "EASY_PAY",
				customer : {
					"customerId" : "${user.uid}",
					"fullName" : "${user.uname}",
					"phoneNumber" : "${user.utel}",
					"address" : {
						"country" : "KR",
						"addressLine1" : addr1,
						"addressLine2" : addr2,
						"zipcode" : "${user.zcode}"
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
			    	"status" : status,
			    	"rnumList" : rnumList
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
	<div class="container p-5 my-5">
		<div class="p-5 my-5 border rounded">
		<div class="row">
			<div class="col-sm-2"></div>
			<div class="col-sm-8">
		<h1 class="text-center">주문/결제</h1>
		<hr>
		<form action="/pay/doPay" method="post" class="" id="doPayForm">
			<div class="table-responsive">
			<table class="table">
				<tr>
					<td><label class="bold">배송지</label></td>
					<td><div class="d-flex justify-content-end">
						<input type="button" class="btn btn-dark" id="post" name="post" 
							data-bs-toggle="modal" data-bs-target="#myModal" value="변&nbsp;경" />
					</div></td>
				</tr>
				<tr>
					<td><label for="uname">이름</label></td>
					<td><input id="uname" class="form-control" name="uname" value="${user.uname}" readonly></td>
				</tr>
				<tr>
					<td><label for="utel">연락처</label></td>
					<td><input id="utel" class="form-control" name="utel" value="${user.utel}" readonly></td>
				</tr>
				<tr>
					<td><label for="addr">주소</label></td>
					<td><input id="addr" class="form-control" name="addr" value="${user.addr}" readonly></td>
				</tr>
				<tr>
					<td><label for="zcode">우편번호</label></td>
					<td><input id="zcode" class="form-control" name="zcode" value="${user.zcode}" readonly></td>
				</tr>
			</table>
			</div>
			<br>
			<div class="table-responsive">
			<table class="table">
				<tr><td><label class="bold">주문상품</label></td></tr>
				<c:forEach items="${res}" var="res">
					<tr>
						<td class="imgTd"><div class="image_wrap">
							<img class="img-thumbnail d-block" src="${pageContext.request.contextPath}/resources/upload/${res.pimg1}"
								title="${res.pimg1}" alt="${res.pimg1}" />
						</div></td>
						<td><div class="align">
							<input id="pname" class="form-control pname" name="pname" value="${res.pname}" readonly>
							<label class="pd"><fmt:formatNumber value="${res.pprice}" pattern="#,### 원" /></label>
							<div class="input-group pd">
								<label class="d-flex align-items-center">주문 수량 : </label>
								<input id="rcount" class="form-control rcount" name="rcount" value="${res.rcount}" readonly>
							</div>
							<label class="pd"><fmt:formatNumber value="${res.rtotal}" pattern="#,### 원" /></label>
							<input type="hidden" id="rtotal" class="form-control price" name="rtotal" value="${res.rtotal}">
							<input type="hidden" id="pprice" class="form-control pprice" name="pprice" value="${res.pprice}">
							<input type="hidden" id="pcode" class="form-control pcode" name="pcode" value="${res.pcode}">
							<input type="hidden" id="ptype" class="form-control ptype" name="ptype" value="${res.ptype}">
							<input type="hidden" id="pimg1" class="form-control pimg1" name="pimg1" value="${res.pimg1}">
							<input type="hidden" id="rnum" class="form-control rnum" name="rnum" value="${res.rnum}">
							<input type="hidden" id="rdinfo" class="form-control rdinfo" name="rdinfo" value="${res.rdinfo}">
							<input type="hidden" id="rsday" class="form-control rsday" name="rsday" value="${res.rsday}">
							<input type="hidden" id="rperiod" class="form-control rperiod" name="rperiod" value="${res.rperiod}">
							<input type="hidden" id="reday" class="form-control reday" name="reday" value="${res.reday}">
						</div></td>
					</tr>
				</c:forEach>
			</table></div>
			<br> <br>
			<div class="table-responsive">
			<table class="table">
				<tr>
					<td><label class="bold">총 주문금액</label></td>
					<td>
						<label id="final" class="d-flex justify-content-end bold"></label></td>
				</tr>
			</table></div>
			<input type="hidden" id="uid" class="form-control" name="uid" value="${user.uid}">
			<input type="hidden" id="paymentId" name="paymentId" />
			<input type="hidden" class="form-control" id="totalAmount" name="totalAmount" value="${totalAmount}">
			<div class="d-flex justify-content-end">
				<div class="mr-1">
					<input type="button" value="카드 결제" class="btn btn-secondary" onclick="doKcp()">
				</div>
				<div class="mx-1">
					<input type="button" value="KaKaoPay 결제" class="btn btn-warning text-white" onclick="doKakao()">
				</div>
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
	function getOrderData() {
	    const orderItems = [];
	    
	    // 각 <tr> 요소 내의 'input' 요소들을 선택합니다.
	    document.querySelectorAll('tr').forEach(function(row) {
	        const rtotalElement = row.querySelector('.price');
	        if (rtotalElement) {
	            const item = {
	                rtotal: parseInt(rtotalElement.value) || 0,
	                rcount: parseInt(row.querySelector('.rcount')?.value) || 0,
	                pname: row.querySelector('.pname')?.value || '',
	                pprice: parseInt(row.querySelector('.pprice')?.value) || 0,
	                pcode: row.querySelector('.pcode')?.value || '',
	                ptype: row.querySelector('.ptype')?.value || '',
	                pimg1: row.querySelector('.pimg1')?.value || '',
	                rnum: row.querySelector('.rnum')?.value || '',
	                rdinfo: row.querySelector('.rdinfo')?.value || '',
	                rsday: row.querySelector('.rsday')?.value || '',
	                rperiod: row.querySelector('.rperiod')?.value || '',
	                reday: row.querySelector('.reday')?.value || '',
	            };
	            orderItems.push(item);
	        }
	    });

	    return orderItems;
	}

	function doKcp(){
		const paymentId = createOrderNum();
		document.getElementById('paymentId').value = paymentId;
		
		console.log("paymenyId : " + paymentId);
		
		const userInfo = {
		        paymentId: paymentId,
		        totalAmount: $('#totalAmount').val(),
		        uname: $('#uname').val(),
		        utel: $('#utel').val(),
		        addr: $('#addr').val(),
		        zcode: $('#zcode').val()
		}
		
		const orderData = getOrderData();
		
	    const payload = [];

	    orderData.forEach(item => {
	        const orderPayload = {
	            ...userInfo,  // 회원정보
	            pcode: item.pcode,
	            pname: item.pname,
	            pprice: item.pprice,
	            rcount: item.rcount,
	            rtotal: item.rtotal,
	            ptype: item.ptype,
	            pimg1: item.pimg1,
	            rnum: item.rnum,
	            rsday: item.rsday,
	            rperiod: item.rperiod,
	            reday: item.reday,
	            rdinfo: item.rdinfo
	        };
	        payload.push(orderPayload);
	    });
		
		console.log("Payload data:");
	    console.log(JSON.stringify(payload, null, 2)); // 예쁘게 포맷된 JSON 출력
		
		$.ajax({
			type: 'POST',
			url: '/pay/insertKcplist',
			data: JSON.stringify(payload),
			contentType: 'application/json',
			dataType: 'json',
			success: function(result){
				console.log(result);
				if(result.msg === "success"){
					console.log("결제 데이터 입력 완료");
					doPortOne(result.orderName);
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
	
	async function doPortOne(orderName){
		const rnumList = [];

        const rnumInputs = document.querySelectorAll('input[name="rnum"]');
        
        // rnum 입력 요소에서 값을 추출하여 배열에 추가
        rnumInputs.forEach(input => {
            if (input.value) {
                rnumList.push(input.value);
            }
        });
        
		let paymentId =  document.getElementById('paymentId').value;
		console.log("orderName : " + orderName);
		console.log("paymentId : " + paymentId);
		try {
			const response = await PortOne.requestPayment({
				storeId: "store-3e1256db-ab78-402b-b63f-03cf01111360",
				channelKey: "channel-key-16845740-5013-443f-a6ba-152e597437f9",
				paymentId: paymentId,
				orderName: orderName,
				totalAmount: parseInt($('#totalAmount').val(), 10),
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
			
			console.log("response 전체:", response);
			
			const txId = response.txId;
			const transactionType = response.transactionType;
			
			console.log("Transaction ID:", txId);
		    console.log("Transaction Type:", transactionType);
		    
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
		    		"paymentId": paymentId,
		    		"rnumList": rnumList
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