<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>Peterpet</title>
<%@ include file="/WEB-INF/views/module/c_header.jsp"%>
<style>
.custom-size {
	transform: scale(2);
    transform-origin: center;
}
.td_width_1{
	width: 5%;
}	 	 	 
.td_width_2{
	width: 10%;
}	 	 
.td_width_3{
	width: 22%;
}	 
.td_width_4{
	width: 15%;
}
/* 이미지 */
.image_wrap{
	width: 100%;
	height: 100%;
}
.image_wrap img{
	max-width: 85%;
	height: auto;
	display: block;		
}
.pagination { display: flex; justify-content: center; margin: 20px; bottom: 20px; }
.pagination a { padding: 5px 10px; text-decoration: none; border: 1px solid #ccc; margin: 0 3px; color: #333; border-radius:10px;}
.pagination a:hover { background-color: #f0f0f0; }
.pagination .active { background-color: black; color: white; }

@media (max-width: 576px) {
    body {
        font-size: 0.8rem !important;
    }
}
</style>
</head>
<body>

<div class="container-fluid container-expand-sm mt-5">
	<%@ include file="/WEB-INF/views/module/myinfonav.jsp"%>
	
	<h1 class="text-center mt-3">예약 목록</h1>

<script>
function searchAction(event) {
    event.preventDefault();
    var searchText = document.getElementById("searchTextInput").value;
    if (searchText === null || searchText.trim() === "") {
        alert("검색어를 입력하세요.");
        return;
    }
    var url = "/res/resList/searchText/" + encodeURIComponent(searchText) + "/page/1";
    window.location.href = url;
}

</script>
<div class="row">
<div class="col-sm-2"></div>
<div class="col-sm-8">
<div class="wrapper">
	<div class="wrap">
		<div class="row">
			<div class="col-sm-4">
				<div class="input-group">
    				<input type="text" name="searchText" class="form-control" placeholder="검색어를 입력하세요" id="searchTextInput">
    				<button class="btn btn-primary" id="searchButton" onclick="searchAction(event)">검색</button>
				</div>
			</div>
			<div class="col-sm-8"></div>
		
		<div class="content_area">
		<c:choose>
		<c:when test="${empty resList}">
			<div class="content_middle_section"></div>
			<!-- 장바구니 가격 합계 -->
			<div class="mb-3 mt-3">
				<table class="table">
					<thead class="table-primary">
						<tr class="text-center">
							<th class="td_width_2"></th>
							<th class="td_width_3">상품명</th>
							<th class="td_width_2">가격</th>
							<th class="td_width_4">수량</th>
							<th class="td_width_2">합계</th>
							<th class="td_width_4">수정/삭제</th>
							<th class="td_width_4"></th>
						</tr>
					</thead>
					<tbody class="table-borderless">
						<tr><td colspan="7" class="text-center">장바구니에 담긴 상품이 없습니다.</td></tr>
					</tbody>
		</table>
		</div>
		</c:when>
		<c:otherwise>
			<!-- 장바구니 가격 합계 -->
			<div class="mb-3 mt-3">
				<table class="table">
					<thead class="table-primary">
						<tr class="text-center">
							<th class="td_width_2"></th>
							<th class="td_width_3">상품명</th>
							<th class="td_width_2">가격</th>
							<th class="td_width_4">수량</th>
							<th class="td_width_2">합계</th>
							<th class="td_width_4">수정/삭제</th>
							<th class="td_width_4">
								<div class=" form-check">
									<label class="form-check-label text-right" for="allChk">
										<input type="checkbox" class="form-check-input custom-size all_check" checked="checked" id="allChk">
										전체선택</label>
								</div>
							</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${resList}" var="res">
							<tr data-rnum="${res.rnum}">
								<td class="td_width_2">
									<div class="image_wrap">
										<img src="${pageContext.request.contextPath}/resources/upload/${res.pimg1}"
                            				title="${res.pimg1}" alt="${res.pimg1}"/>
                            		</div>
								</td>
								<td class="td_width_3">
									${res.pname}<br>
									<c:if test="${res.ptype == '패키지'}">
        								기간: ${res.rsday}~${res.reday}
    								</c:if>
								</td>
								<td class="td_width_2 text-center"><fmt:formatNumber value="${res.pprice}" pattern="#,### 원" /></td>
								<td class="td_width_4">
									<div class="input-group">
										<button class="btn btn-outline-secondary minus">-</button>
										<input type="text" value="${res.rcount}" class="form-control rcount text-center">
										<button class="btn btn-outline-secondary plus">+</button>
									</div>
								</td>
								<td class="td_width_2 text-center"><input type="text" class="rtotal border border-0 text-center" value="<fmt:formatNumber value="${res.rtotal}" pattern="#,### 원" />" />
								</td>
								<td class="td_width_4 text-center">
									<c:choose>
										<c:when test="${res.ptype == '패키지'}">
        									<button class="btn btn-outline-secondary btn-sm m-1" data-bs-toggle="modal" data-rnum="${res.rnum}" data-bs-target="#updateModal">예약 수정</button>
        									<button class="btn btn-outline-secondary btn-sm m-1" data-bs-toggle="modal" data-rnum="${res.rnum}" data-bs-target="#deleteModal">삭제</button>
    									</c:when>
    									<c:otherwise>
											<input type="button" class="btn btn-outline-secondary btn-sm" data-rnum="${res.rnum}" onclick="deleteProdRes(this)" value="삭제" />
										</c:otherwise>
									</c:choose>
								</td>
								<td class="td_width_4 res_info_td text-center">
									<input type="checkbox" class="form-check-input custom-size mr-1 res_checkbox" checked="checked">
									<input type="hidden" class="pprice_input" value="${res.pprice}">
									<input type="hidden" class="rcount_input" value="${res.rcount}">
									<input type="hidden" class="rnum_input" value="${res.rnum}">
									<input type="hidden" class="rtotal_input" value="${res.rtotal}">
									<input type="hidden" class="pcode_input" value="${res.pcode}">								
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			<div class="row">
				<div class="col-md-10"></div>
				<div class="col-md-2 d-flex justify-content-center">
					<input type="button" id="checkRes" name="checkRes" value="선택 삭제" class="btn btn-primary" />
				</div>
			</div>
					
					
			<!-- 가격 종합 -->
			<div class="bg-light p-4 m-3">
				<div class="container">
                <!-- Total Count -->
                <div class="row">
                	<div class="col-md-7"></div>
                    <div class="col-md-3">총 주문 상품수</div>
                    <div class="col-md-2 totalCount">0</div>
                </div>
                <!-- Total Price -->
                <div class="row">
                	<div class="col-md-7"></div>
                    <div class="col-md-3">총 상품 가격</div>
                    <div class="col-md-1 totalPrice">0</div>
                    <div class="col-md-1">원</div>
                </div>
            </div>
			</div>
			<!-- 구매 버튼 영역 -->
			<div class="mt-4 mx-3 d-flex justify-content-end">
				<button class="btn btn-primary orders">주문하기</button>
			</div>
			
			<!-- 주문 form -->
			<form action="/pay/goResPay" method="post" id="orderForm">

			</form>
			</c:otherwise>
		</c:choose>
		</div>
	</div>	<!-- class="wrap" -->
</div>
</div>

	<!-- class="wrapper" -->
	<!-- 페이징 네비게이션 -->
    <div class="pagination">
    <c:if test="${empty searchText}">
    	<c:if test="${rpage.startPage != 1}">
            <a href="/res/resList/page/${rpage.startPage - 5}">이전</a>
        </c:if>
        <c:forEach var="pageNo" begin="${rpage.startPage}" end="${rpage.endPage}">
            <a href="/res/resList/page/${pageNo}" class="${pageNo == rpage.currentPage ? 'active' : ''}">${pageNo}</a>
        </c:forEach>
        <c:if test="${rpage.lastStartPage != rpage.startPage}">
            <a href="/res/resList/page/${rpage.startPage + 5}">다음</a>
        </c:if>
    </c:if>
    <c:if test="${not empty searchText}">
        <c:if test="${rpage.startPage != 1}">
            <a href="/res/resList/searchText/${searchText}/page/${rpage.startPage - 5}">이전</a>
        </c:if>
        <c:forEach var="pageNo" begin="${rpage.startPage}" end="${rpage.endPage}">
            <a href="/res/resList/searchText/${searchText}/page/${pageNo}" class="${pageNo == rpage.currentPage ? 'active' : ''}">${pageNo}</a>
        </c:forEach>
        <c:if test="${rpage.lastStartPage != rpage.startPage}">
            <a href="/res/resList/searchText/${searchText}/page/${rpage.startPage + 5}">다음</a>
        </c:if>
    </c:if>
    </div>
</div>
<div class="col-sm-2"></div>
	</div>

</div>

<!-- 모달 -->
    <div id="updateModal" class="modal">
    	<div class="modal-dialog">
        	<div class="modal-content">
				<div class="modal-header">
        			<h4 class="modal-title">돌봄 예약 수정</h4>
        			<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      			</div>
      			<div class="modal-body">
        			<form action="/res/packageForm/update/update" method="post" id="updateForm">
            			<input type="hidden" class="rnum" name="rnum" value="">
                		<div class="d-flex justify-content-center">
                        		<div class="form-check mx-3">
                            		<input type="checkbox" class="form-check-input" id="school" name="packName" value="school" checked readonly 
                                    data-bs-toggle="tooltip" data-bs-placement="top" title="유치원은 필수입니다">
                            		<label class="form-check-label">유치원</label>
                        		</div>
                        		<div class="form-check mx-2">
                            		<input type="checkbox" class="form-check-input" id="hotel" name="packName" value="hotel">
                            		<label class="form-check-label">호텔</label>
                        		</div>
                        		<div class="form-check mx-3">
                            		<input type="checkbox" class="form-check-input" id="beauty" name="packName" value="beauty">
                            		<label class="form-check-label">미용</label>
                        		</div>
                		</div>
                		<div class="form-group">
                    		<div>돌봄 시작일:</div>
                    		<input class="form-control" type="date" id="rsday" name="rsday" required>
                		</div>
                		<div class="form-group">
                    		<div>돌봄 기간:</div>
                    		<input class="form-control" type="number" id="rperiod" name="rperiod" min="1" max="7" value="1" required>
                		</div>
                		<hr>
                		<div class="form-group">
                    		<div class="text-center">반려견 정보</div>
                		</div>
                		<div class="form-group">
                    	<div>반려견 수:</div>
                    		<input class="form-control" type="number" id="rcount" name="rcount" min="1" max="10" value="1" onchange="calculatePrice()" required>
                		</div>
                		<div class="form-group">
                    	<div>특이사항:</div>
                    		<textarea class="form-control" id="rdinfo" name="rdinfo" rows="4" placeholder="특별한 요구사항이 있다면 적어주세요.(예: 강아지 이름, 접종여부, 성격 등)"></textarea>
                		</div>
                		<div id="price">가격: 0원</div>
                		<input type="hidden" id="totalPrice" name="totalPrice" value="">
                		<input type="button" class="btn btn-dark" data-bs-dismiss="modal" id="update" value="예약 수정">
            		</form>
      			</div>
      		</div>
        </div>
    </div>
    
 
    <!-- 삭제 모달 창 -->
    <div id="deleteModal" class="modal">
    	<div class="modal-dialog">
        	<div class="modal-content">
        		<div class="modal-header">
        			<h4 class="modal-title">돌봄 예약 삭제</h4>
        			<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      			</div>
      			<div class="modal-body">
        			돌봄 패키지 예약을 삭제할 경우 입력하신 내용은 복구가 불가능합니다.
        			정말로 돌봄 예약을 삭제하시겠습니까?
      				<input type="hidden" class="rnum" name="rnum">
      			</div>
      			<div class="modal-footer">
      				<button class="btn btn-dark" onclick="confirmDelete()" data-bs-dismiss="modal">확인</button>
        			<button class="btn btn-dark" data-bs-dismiss="modal">취소</button>
      			</div>
        	</div>
        </div>
    </div>
<%@ include file="/WEB-INF/views/module/footer.jsp"%>
<script>
$(document).ready(function(){
	setTotal();
	var searchText = '${searchText != null ? searchText : ""}';
	if (searchText) {
	    document.getElementById("searchTextInput").value = searchText;
	}
	
	var checkbox = document.getElementById('school');
    var tooltip = new bootstrap.Tooltip(checkbox);


    checkbox.addEventListener('change', function (event) {
        if (!checkbox.checked) {
            tooltip.show();
        }
    });
    
    $('#updateModal').on('show.bs.modal', function (event) {
        var button = $(event.relatedTarget);
        var rnum = button.data('rnum');
        $('.rnum').val(rnum);
        
        $.ajax({
            url: '/res/getMyRes/rnum/' + rnum,
            method: 'GET',
            data: { rnum: rnum }, // 요청 파라미터
            success: function (response) {
            	document.getElementById("rdinfo").value = response.myRes.rdinfo;
                document.getElementById("rperiod").value = response.myRes.rperiod;
                document.getElementById("rsday").value = response.myRes.rsday;
                document.getElementById("rcount").value = response.myRes.rcount;
                document.getElementById("totalPrice").value = response.myRes.rtotal;
                document.getElementById("price").innerText = "가격: " +response.myRes.rtotal+"원";
                
                var pname = response.myRes.pname;
                var mappings = {
                	'호텔': 'hotel',
                    '미용': 'beauty'
                };
                
                for (var key in mappings) {
                    if (mappings.hasOwnProperty(key)) {
                        var checkboxId = mappings[key];
                        var checkbox = document.getElementById(checkboxId);
                        if (pname.includes(key)) {
                            checkbox.checked = true;
                        } else {
                            checkbox.checked = false;
                        }
                    }
                }
            },
            error: function (xhr, status, error) {
            	console.log("getMyRes ajax요청 실패");
            }
        });
    });
});

function confirmDelete() {
	var rnum = $('#deleteModal .rnum').val();
	if(rnum){
		$.ajax({
            url: '/res/deleteRes/rnum/'+rnum,
            type: 'POST',
            success: function(response) {
                alert("예약이 삭제되었습니다");
                $('tr[data-rnum="' + rnum + '"]').remove();
                setTotal();
            },
            error: function(xhr, status, error) {
                alert("예약 삭제에 실패했습니다");
            }
        });
	} 
}
	
$(".res_checkbox").on("change", function(){
	setTotal($(".res_info_td"));
	
	 if ($(".res_checkbox:checked").length === $(".res_checkbox").length) {
	        $(".all_check").prop("checked", true);
	    } else {
	        $(".all_check").prop("checked", false);
	    }
});

$(".all_check").on("click", function(){
	if($(".all_check").prop("checked")){
		$(".res_checkbox").prop("checked", true);
	} else{
		$(".res_checkbox").prop("checked", false);
	}
	setTotal($(".res_info_td"));
});

function setTotal(){
	let totalPrice = 0;				// 총 가격
	let totalKind = 0;				// 총 종류
	
	$('.res_info_td').each(function(index, element) {
		if($(element).find(".res_checkbox").prop("checked")){
        	totalPrice += parseInt($(element).find(".rtotal_input").val());
        	totalKind += 1;
        }
    });

    console.log('총 가격:', totalPrice);
    
    $(".totalPrice").text(totalPrice.toLocaleString());
    $(".totalCount").text(totalKind);
}	
	
$(".plus").on("click", function(){
	let count = $(this).parent("div").find("input").val();
	$(this).parent("div").find("input").val(++count);
	changeCount($(this).closest('tr'));
});

$(".minus").on("click", function(){
	let count = $(this).parent("div").find("input").val();
	if($(this).parent("div").find("input").val()>1){
		$(this).parent("div").find("input").val(--count);
	}
	changeCount($(this).closest('tr'));
	
});	

function changeCount($row){
	let rcount = parseInt($row.find(".rcount").val());
	let rtotal = parseInt($row.find(".rtotal_input").val());
	let pprice = parseInt($row.find(".pprice_input").val());
	let rnum = $row.find(".rnum_input").val();
	
	rtotal = rcount * pprice;
	let fmtRtotal = rtotal.toLocaleString();
	$row.find(".rcount_input").val(rcount);
	$row.find(".rtotal_input").val(rtotal);
	$row.find(".rtotal").val(fmtRtotal + " 원");
	 
	$.ajax({
	    url: '/res/updateCount',
	    type: 'POST',
	    contentType: 'application/json', // JSON 데이터 전송을 위한 설정
	    data: JSON.stringify({
	        rnum: rnum,
	        rcount: rcount,
	        rtotal: rtotal
	    }),
	    dataType: 'json',
	    success: function(result) {
	        console.log(result);
	    },
	    error: function(xhr, error) {
	        console.error('AJAX 요청 오류:', error);
	    }
	});
	
	setTotal();
}

function calculatePrice() {
	var price = 100000;
	var quantity = parseInt(document.getElementById('rcount').value);
	if (isNaN(quantity) || quantity < 1) {
    	quantity = 1;
    }
	var total = price * quantity;
	document.getElementById('price').innerText = "가격: " +total+"원";
	document.getElementById('totalPrice').value = total;
	console.log("total값 : " + document.getElementById('totalPrice').value);
}

$('#update').on('click', function(event) {

    var formData = $('#updateForm').serialize(); // 폼 데이터를 직렬화
    console.log("formData :" +formData);
    console.log("formData.값 :" +formData.totalPrice);

    $.ajax({
        url: $('#updateForm').attr('action'), // 폼의 action 속성에서 URL 가져오기
        type: 'POST',
        data: formData,
        success: function(response) {
            alert("예약이 수정되었습니다");
            window.location.reload();
            // setTotal();
        },
        error: function(xhr, status, error) {
            alert("예약 수정에 실패했습니다");
        }
    });
});

function deleteProdRes(buttonElement){
	var rnum = $(buttonElement).data('rnum');
	if(rnum){
		$.ajax({
            url: '/res/deleteRes/rnum/'+rnum,
            type: 'POST',
            success: function(response) {
                $('tr[data-rnum="' + rnum + '"]').remove();
                window.location.reload();
                
            },
            error: function(xhr, status, error) {
                alert("예약 삭제에 실패했습니다");
            }
        });
	} 
}
</script>
<script>
$("#checkRes").on("click", function() {
	var rnumList = [];
	
	$(".res_info_td").each(function(index, element) {
        if ($(element).find(".res_checkbox").is(":checked")) {
            let rnum = $(element).find(".rnum_input").val();
            rnumList.push(rnum);
        }
	});
	if (rnumList.length === 0) {
        alert("삭제할 상품을 선택해주세요.");
        return;
    }
	$.ajax({
        url: '/res/deleteCartList',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({ rnumList: rnumList }),
        success: function(response) {
        	if(response.msg === "success"){
            	alert("선택한 상품이 삭제되었습니다.");
            	rnumList.forEach(function(rnum) {
                	$('tr[data-rnum="' + rnum + '"]').remove();
            	});
            	$(".res_info_td .res_checkbox").prop("checked", true);
            	$("#allChk").prop("checked", true);
            	setTotal();
        	}else{
        		alert("선택 상품 제거에 실패했습니다.");
        	}
        },
        error: function(xhr, status, error) {
        	console.error("AJAX 요청 오류:", status, error);
        }
    });
});

$(".orders").on("click", function() {
    let form_contents = '';
    let orderNumber = 0;
    let rnumExists = false;

    $(".res_info_td").each(function(index, element) {
        if ($(element).find(".res_checkbox").is(":checked")) {
            let rnum = $(element).find(".rnum_input").val();
            
            if (rnum) {
                rnumExists = true;
                let rnum_input = "<input name='rnumList' type='hidden' value='" + rnum + "'>";
                form_contents += rnum_input;
                orderNumber += 1;
            }
        }
    });

    if (!rnumExists) {
        alert("선택된 상품이 없습니다.");
        return; 
    }

    $("#orderForm").html(form_contents);
    $("#orderForm").submit();
});
</script>
</body>
</html>