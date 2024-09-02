<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약 목록 관리자 :: peterpet</title>
<script type="text/javascript">
$(document).ready(function() {
    $('#searchForm').on('submit', function(event) {
        event.preventDefault(); // 폼의 기본 제출 동작을 막습니다.

        var searchKeyword = $('input[name="searchKeyword"]').val();
        var searchType = $('#searchres').val();

        if ((searchType === 'ptype' || searchType === 'uid') && !searchKeyword.trim()) {
            // 검색 타입이 'ptype' 또는 'uid'이고 검색어가 비어있으면 아무 요청도 하지 않음
            $('#resTable tbody').html('<tr><td colspan="11" class="text-center">검색어를 입력하세요.</td></tr>');
            return;
        }

        $.ajax({
            type: 'POST',
            url: $(this).attr('action'),
            data: $(this).serialize(),
            success: function(response) {
                // 응답으로 받은 HTML을 테이블에 삽입합니다.
                $('#resTable tbody').html($(response).find('#resTable tbody').html());
                $('#searchres').val($(response).find('#searchres').val());
                $('input[name="searchKeyword"]').val($(response).find('input[name="searchKeyword"]').val());
            },
            error: function() {
                alert('검색 중 오류가 발생했습니다.');
            }
        });
    });

    $('#searchres').on('change', function() {
        // 선택된 옵션이 변경될 때마다 검색어를 초기화
        $('input[name="searchKeyword"]').val('');
    });

	
</script>
<script>
function openModal(rnum) {
	document.getElementById("deleteModal").style.display = "block";
   	document.getElementById("deleteRnum").value = rnum;
}

function closeModal() {
	document.getElementById("deleteModal").style.display = "none";
}

	function confirmDelete() {
    var rnum = document.getElementById("deleteRnum").value;
    window.location.href = "/admin/res/deleteRes/rnum/" + rnum;
}
	
	function formatNumber(value) {
	    return new Intl.NumberFormat('ko-KR', { style: 'decimal', maximumFractionDigits: 0 }).format(value);
	}
	
	function calPriceAll() {
	    if ($("#cbx_chkAll").is(":checked")) {
	        $("input[name=chk]").prop("checked", true);
	    } else {
	        $("input[name=chk]").prop("checked", false);
	    }
	    
	    calPrice(); // 가격 계산을 업데이트하기 위해 호출
	}

function calPrice() {
	 var priceArray = [];
	    
	    $("input[name=chk]:checked").each(function() {
	        priceArray.push(parseInt($(this).val(), 10));
	    });

	    var ptotal = priceArray.reduce((sum, price) => sum + price, 0);
	    
	    $('#ptotal1').val(ptotal);
	    
	    var formattedTotal = formatNumber(ptotal);
	    $('#ptotal2').text(formattedTotal);

	    var total = $("input[name=chk]").length;
	    var checked = $("input[name=chk]:checked").length;
	    
	    $("#cbx_chkAll").prop("checked", total === checked);
}
</script>
<style>
		body {
			font-size: 20px !important;
		}
        /* 모달 스타일 */
        .modal {
            display: none;
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgb(0, 0, 0);
            background-color: rgba(0, 0, 0, 0.4);
            padding-top: 60px;
        }

        .modal-content {
            background-color: #fefefe;
            margin: 5% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 30% !important;
            text-align: center;
        }

        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
        }

        .close:hover,
        .close:focus {
            color: black;
            text-decoration: none;
            cursor: pointer;
        }
        table {
        	width: 100%;
        }
        td, th {
        	height: 45px;
        	width: 45px;
			overflow: hidden;
			white-space: nowrap;
			text-overflow: ellipsis;
			text-align: center !important;
			vertical-align: middle;
		}
		.form-check .form-check-input {
			height: 25px;
			width: 25px;
		}
		.form-check-label {
			text-align: right;
    		vertical-align: middle;
		}
		.listsect {
			margin: 24px !important;
		}
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/module/anav.jsp" %>

	<div class="listsect">
		<h1 class="text-center">예약 목록</h1>
		<hr>
		<div class="row mb-2">
			<div class="col-sm-2">
				<input type="button" value="상품 예약하기" class="btn btn-primary"
					onClick="location.href='./insertResProd'">
			</div>
			<div class="col-sm-2">
				<input type="button" value="패키지 예약하기" class="btn btn-primary"
					onClick="location.href='./insertResPack'">
			</div>
			<div class="col-sm-6"></div>
			<div class="col-sm-2">
			</div>
		</div>
		
		<!-- 검색 폼 -->
    <div class="row mb-4">
        <div class="col-md-6 offset-md-6">
            <form id="searchForm" action="./searchRes" method="post" class="d-flex">
                <select id="searchres" name="searchres" class="form-select me-2" style="width: 150px;">
                    <option value="all" ${searchCondition == 'all' ? 'selected' : ''}>전체 보기</option>
                    <option value="ptype" ${searchCondition == 'ptype' ? 'selected' : ''}>상품</option>
                    <option value="uid" ${searchCondition == 'uid' ? 'selected' : ''}>아이디</option>
                </select>
                <input type="text" name="searchKeyword" class="form-control me-2" placeholder="검색어 입력" style="max-width: 300px;" value="${searchKeyword}" />
                <input type="submit" class="btn btn-primary" value="검색" />
            </form>
        </div>
    </div>
		
		<table border="1">
			<thead>
				<tr>
					<th>번호</th>
					<th>이름</th>
					<th>연락처</th>
					<th>상품명</th>
					<th>상품 종류</th>
					<th>돌봄 시작일</th>
					<th>반려견 수(상품 수량)</th>
					<th>돌봄 종료일</th>
					<th>합계</th>
					<th>수정</th>
					<th>삭제</th>
					<th><div class="form-check">
							<label class="form-check-label" for="cbx_chkAll"> <input
								type="checkbox" class="form-check-input" id="cbx_chkAll"
								name="cbx_chkAll" onClick="calPriceAll()"> 전체 선택
							</label>
						</div></th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="res" items="${resList}">
					<tr>
						<td><a href="/admin/res/detail/rnum/${res.rnum}"><c:out
									value="${res.rnum}" /></a></td>
						<td><c:out value="${res.uname}" /></td>
						<td><c:out value="${res.utel}" /></td>
						<td class="ellipsis"><c:out value="${res.pname}" /></td>
						<td><c:out value="${res.ptype}" /></td>
						<td><c:out value="${res.rsday}" /></td>
						<td><c:out value="${res.rcount}" /></td>
						<td><fmt:formatDate value="${res.reday}" pattern="yyyy-MM-dd" /></td>
						<td><fmt:formatNumber value="${res.rtotal}"
								groupingUsed="true" />원</td>
						<td><div>
								<a href="/admin/res/updateRes/rnum/${res.rnum}">수정</a>
							</div></td>
						<td><div>
								<a href="javascript:void(0);" onclick="openModal('${res.rnum}')">삭제</a>
							</div></td>
						<td>
							<div class="form-check">
								<label for="chk">
								<input type="checkbox" class="form-check-input" name="chk" onClick="calPrice()" value="${res.rtotal}">
								</label>
							</div>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		<br />
		<hr />
		<br />
		<div>
			<form action="/admin/pay/" method="post">
				<div class="row mb-2">
					<div class="col-sm-2"></div>
					<div class="col-sm-4">
						<label for="ptotal">결제 예상 금액:</label>
					</div>
					<div class="col-sm-4">
						<input type="hidden" id="ptotal1" name="ptotal" value="0">
						<span id="ptotal2">0</span>원
					</div>
					<div class="col-sm-2">
						<input type="submit" value="결제하기" class="btn btn-primary">
					</div>
				</div>
			</form>
		</div>
	</div>
	<!-- 모달 창 -->
    <div id="deleteModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <p>정말 이 상품을 삭제하시겠습니까?</p>
            <input type="hidden" id="deleteRnum" value="${res.rnum}">
            <button onclick="confirmDelete()">확인</button>
            <button onclick="closeModal()">취소</button>
        </div>
    </div>
    
<%@ include file="/WEB-INF/views/module/footer.jsp"%>
</body>
</html>