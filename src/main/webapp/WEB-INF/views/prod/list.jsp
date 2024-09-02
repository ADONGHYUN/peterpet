<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html><html><head><meta charset="UTF-8">
<title>상품 목록</title>
<style>
	body {
		font-family: Arial, sans-serif;
		margin: 20px;
	}
	
	h1 {
		color: #333;
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
<%@ include file="/WEB-INF/views/module/c_header.jsp" %>
<div class="container mt-5">
	<h2 class="text-center mb-5">상품 목록</h2>
		<div id="consection" class="container-fluid">
			<div id="innerdiv" class="container">
				<ul class="nav nav-tabs nav-justified">
					<li class="nav-item">
					<a class="prod-nav nav-link active" data-ptype="all">전체보기</a></li>
					<li class="nav-item">
					<a class="prod-nav nav-link" data-ptype="간식">간식</a></li>
					<li class="nav-item">
					<a class="prod-nav nav-link" data-ptype="미용">미용</a></li>
					<li class="nav-item">
					<a class="prod-nav nav-link" data-ptype="사료">사료</a></li>
					<li class="nav-item">
					<a class="prod-nav nav-link" data-ptype="영양제">영양제</a></li>
					<li class="nav-item">
					<a class="prod-nav nav-link" data-ptype="장난감">장난감</a></li>
				</ul>
			</div>
		</div>
		<!-- 검색 폼 -->
		<div class="container mt-3">
			<div class="row align-items-center justify-content-center">
				<div class="col-1"></div>
				<div class="col-1 d-flex justify-content-center align-items-center flex-wrap">
					<select id="arrayprod" name="arrayprod" class="form-select me-2" style="width: 150px;">
						<option value="pname" selected>상품 이름순</option>
						<option value="pregdate desc">최신 상품순</option>
						<option value="pprice desc">높은 가격순</option>
						<option value="pprice asc">낮은 가격순</option>
					</select>
				</div>
				<div class="col-5"></div>
				<div class="col-4 d-flex justify-content-center align-items-center flex-wrap">
					<div class="input-group d-flex align-items-center">
						<select id="searchProd" name="searchProd" class="form-select">
							<option value="pname" selected>상품명</option>
						</select>
						<input type="text" id="searchKeyword" name="searchKeyword" class="form-control"
							placeholder="검색어 입력" style="flex-grow: 1; max-width: 400px;"/>
						<input type="submit" id="srchbtn" class="btn btn-primary" style="white-space: nowrap;" value="검색" />
					</div>
				</div>
				<div class="col-1"></div>
			</div>
		</div>

		<div class="container mt-3 rounded-3 px-0">
			<table id="prodlist" class="table border-white mb-0">
				<tbody id="product-body" class="row">
					<c:forEach var="prod" items="${prodList}">
						<tr class="col-sm-6 col-lg-4 d-flex justify-content-center mb-4">
							<td class="p-0">
								<div class="pt-3 d-flex justify-content-center">
									<a id="prodlink" href="detail/pcode/${prod.pcode}">
										<img class="d-block img-thumbnail" title="${prod.pimg1}" alt="${prod.pimg1}"
										src="${pageContext.request.contextPath}/resources/upload/${prod.pimg1}" />
									<br>
									<span class="text-center align-middle d-block fs-5 pname-span">${prod.pname}</span>	
									</a>
								</div>
								<div class="text-center">
									<hr>
									<span class="d-block pt-3 fs-4">
									<fmt:formatNumber value="${prod.pprice}" groupingUsed="true" />원
									</span>
									<input type="hidden" name="ptype" value="${prod.ptype}">
								</div>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		<nav aria-label="Page navigation example">
			<ul class="pagination justify-content-center" id="pagination"></ul>			
		</nav>
	</div>
<%@ include file="/WEB-INF/views/module/footer.jsp"%>

<script>
    $(document).ready(function() {
    	var ptype = $('.prod-nav.active').data('ptype') || 'all';
        console.log('페이지 로딩 시 ptype: ', ptype);

        function fetchProducts() {
        	var ptype = $('.prod-nav.active').data('ptype') || 'all';
        	var arrayprod = $('#arrayprod').val();
            var searchKeyword = $('#searchKeyword').val();
        	
            $.ajax({
                type: 'POST',
                url: './list',
                data: {
                	ptype: ptype,
                	arrayprod: arrayprod,
                	searchKeyword: searchKeyword,
                	type: 'ajax' // AJAX 요청을 식별하기 위한 파라미터
                },
                success: function(response) {
                	
                    if (!response || response.length === 0) {
                    	var html = '';
                    	html += '<tr class="col-sm-6 col-lg-4 d-flex justify-content-center mb-4">';
                    	html += '<td class="p-0">';
                    	html += '<div class="pt-3 d-flex justify-content-center">';
                    	html += '<h3>해당 상품이 없습니다.</h3>';
                    	html += '</div></td></tr>';
                    	
                        $('#product-body').html(html);
                        return;
                    }
                    // 상품 목록 HTML 업데이트
                    var html = '';
                    response.forEach(function(prod) {
                    	var formattedPrice = formatPrice(prod.pprice); // 포맷팅된 가격
                    	
                    	html += '<tr class="col-sm-6 col-lg-4 d-flex justify-content-center mb-4">';
                        html += '<td class="p-0">';
                        html += '<div class="pt-3 d-flex justify-content-center">';
                        html += '<a id="prodlink" href="detail/pcode/' + prod.pcode + '">';
                        html += '<img class="d-block img-thumbnail" title="' + prod.pimg1 + '" alt="' + prod.pimg1 + '" src="/resources/upload/' + prod.pimg1 + '"><br>';
                        html += '<span class="text-center align-middle d-block fs-5 pname-span">' + prod.pname + '</span></a>';
                        html += '</div>';
                        html += '<div class="text-center">';
                        html += '<hr>';
                        html += '<span class="d-block pt-3 fs-4">' + formattedPrice + '원</span>'; // 포맷팅된 가격
                        html += '<input type="hidden" name="ptype" value="' + prod.ptype + '">';
                        html += '</div>';
                        html += '</td>';
                        html += '</tr>';
                    });

                    $('#product-body').html(html);
                },
                error: function(xhr, status, error) {
                    console.error('AJAX 오류 발생:', status, error);
                    var html = '';
                	html += '<tr class="col-sm-6 col-lg-4 d-flex justify-content-center mb-4">';
                	html += '<td class="p-0">';
                	html += '<div class="pt-3 d-flex justify-content-center">';
                	html += '<h3>상품 목록을 불러오는 데 실패했습니다.</h3>';
                	html += '</div></td></tr>';
                	
                    $('#product-body').html(html);
                }
            });
        }
        
     	// 카테고리 링크 클릭 이벤트 핸들러
        $('.prod-nav').on('click', function(event) {
            event.preventDefault(); // 링크 기본 동작 방지
            
            var ptype = $(this).data('ptype'); // 클릭한 링크의 데이터 속성 값 가져오기
            $('.prod-nav').removeClass('active');
            $('.prod-nav').each(function() {
                if ($(this).data('ptype') === ptype) {
                    $(this).addClass('active');
                }
            });
            
            fetchProducts(); // 선택된 카테고리의 상품 목록 불러오기
        });
        
     	// 상품 검색 버튼 클릭 이벤트 핸들러
        $('#srchbtn').on('click', function(event) {
            event.preventDefault();
            fetchProducts(); // 검색 조건으로 상품 목록 불러오기
        });
    	
     	// 상품 목록 정렬 변경 이벤트 핸들러
        $('#arrayprod').on('change', function(event) {
            fetchProducts(); // 정렬 기준으로 상품 목록 불러오기
        });
		
        // 페이지 로딩 시 상품 목록을 불러옵니다
        fetchProducts();
    });
    
	function formatPrice(price) {
		return new Intl.NumberFormat('ko-KR', {
			style : 'decimal',
			minimumFractionDigits : 0, // 소수점 이하 자리 수
			maximumFractionDigits : 0  // 소수점 이하 자리 수
		}).format(price);
	}
</script>
</body>
</html>
