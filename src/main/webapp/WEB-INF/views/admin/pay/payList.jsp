<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 결제 관리</title>
<style>
.ellipsis {
    		overflow: hidden;
    		white-space: normal;
    		text-overflow: ellipsis;
    		display: -webkit-box;
    		-webkit-line-clamp: 1;
    		-webkit-box-orient: vertical;
    		word-break: keep-all; 
		}
.width_1{width: 5%;}	 	 	 
.width_2{width: 10%;}	 	 
.width_3{width: 20%;}
.edit{
	border:0;
	font-weight:bold;
	text-decoration:none;
	color:black;
}
.edit:hover{text-decoration:underline;}
.pagination .page-item.active .page-link {
	background-color: black; /* 블랙 배경색 */
	border-color: black; /* 블랙 테두리 색 */
	color: #fff; /* 흰색 글자색 */
}

</style>
</head>
<body>
<%@ include file="/WEB-INF/views/module/anav.jsp"%>
    <div class="container-fluid">
        <h2 class="text-center mt-5">결제 관리</h2>
        <input type="hidden" id="currentPage" value="${page.currentPage}" />
        <div class="row">
        	<div class="col-sm-6 d-flex align-items-center">
        		<form action="/admin/pay/list/1" method="post">
						<div class="input-group">
							<select class="form-select" name="searchCondition">
							<c:forEach items="${payconditionMap}" var="option">
								<option value="${option.value}" <c:if test="${option.value == pay.searchCondition}">selected</c:if>>${option.key}</option>
							</c:forEach>
							</select>
							<input class="form-control" name="searchKeyword" type="text" value="${pay.searchKeyword}" />
							<input class="btn btn-dark" type="submit" value="검색" />
					</div>
				</form>
			
				<input type="hidden" id="condition" name="condition" value="${pay.searchCondition}" />
                <input type="hidden" id="keyword" name="keyword" value="${pay.searchKeyword}" />
        	</div>
        </div>

		<div class="table-responsive mt-3">
        <table class="table table-striped table-bordered" id="payTable">
        	<thead class="text-center">
            <tr>
                <th class="width_1">주문번호</th>
                <th class="width_3">주문명</th>
                <th class="width_1">가격</th>
                <th class="width_1">결제상태</th>
                <th class="width_1">결제시간</th>
                <th class="width_1">배송상태</th>
                <th class="width_2">관리</th>
            </tr>
        </thead>
        <tbody class="text-center">
            <!-- JSTL 사용하여 prodList를 반복 -->
            <c:forEach var="pay" items="${payList}">
                <tr>
                    <td><a href="#" class="edit detail" data-paymentid="${pay.paymentId}">${pay.paymentId}</a></td>
                    <td><div class="ellipsis"><c:out value="${pay.orderName}"/></div></td>
                    <td><fmt:formatNumber type="number" value="${pay.totalAmount}" pattern="#,##0" /></td>
                    <td><c:out value="${pay.status}"/></td>
                    <td><c:out value="${pay.paydate}"/></td>
                    <td><c:out value="${pay.delistate}"/></td>
                    <td><a href="#" class="btn btn-outline-dark" data-paymentid="${pay.paymentId}">배송시작</a>
                    <a href="#" class="btn btn-outline-dark" data-paymentid="${pay.paymentId}">결제취소</a></td>
                </tr>
            </c:forEach>
        </tbody>
    	</table>
    	</div>
    	<div class="mt-5 mb-5"></div>
		<nav>
			<ul class="pagination justify-content-center">
				<c:if test="${page.startPage > page.pageBlock}">
					<li class="page-item">
                	<a class="page-link text-dark" href="#" data-page="${page.startPage - page.pageBlock}">이전</a>
            		</li>
        		</c:if>
			
				<c:forEach var="current" begin="${page.startPage}" end="${page.endPage}">
            		<c:choose>
                		<c:when test="${current == page.currentPage}">
                    		<li class="page-item active">
                        		<span class="page-link"><c:out value="${current}"/></span>
                    		</li>
                		</c:when>
                		<c:otherwise>
                    		<li class="page-item">
                        		<a class="page-link text-dark" href="#" data-page="${current}"><c:out value="${current}"/></a>
                    		</li>
                		</c:otherwise>
            		</c:choose>
        		</c:forEach>
	
				<c:if test="${page.endPage < page.totalPages}">
           			<li class="page-item">
                		<a class="page-link text-dark" href="#" data-page="${page.startPage + page.pageBlock}">다음</a>
            		</li>
        		</c:if>
			</ul>
		</nav>
		<script>
			$(document).ready(function() {
				$(document).on('click', '.detail', function(event) {
			        event.preventDefault();

			        let baseUrl = '/admin/pay/getPayDetail/';
			        let paymentId = $(this).data('paymentid');
			        let searchCondition = $('#condition').val();
			        let searchKeyword = $('#keyword').val();
			        let page = $('#currentPage').val();
					console.log("currentPage : " + page);
			        let url = baseUrl + page + '/' + paymentId;
			        if (searchKeyword && searchKeyword.trim() !== "") {
			            url += '/' + searchCondition + '/' + searchKeyword;
			        }
			        window.location.href = url;
			    });
				
				$(document).on('click', '.pagination .page-link', function(e) {
					e.preventDefault();
					var page = $(this).data('page');
					var condition = document.getElementById("condition").value;
					var keyword = document.getElementById("keyword").value;
					console.log("condition : " + condition);
					console.log("keyword : " + keyword);
					if(page){ 
						$.ajax({
							url : '/admin/pay/list/' + page,
							type : 'GET',
							data : { 
								condition : condition,
								keyword : keyword
								
							},
							success : function(response) {
								$('#payTable').html($(response).find('#payTable').html());
								$('.pagination').html($(response).find('.pagination').html());
								
								var newUrl = '/admin/pay/list/' + page;
								history.pushState(null, '', newUrl);
								$('#currentPage').val(page);
							},
							error : function(xhr, status, error) { console.error("Ajax Error " + status); }
						});
					}
				});
			});
		</script>
    </div>
<%@ include file="/WEB-INF/views/module/footer.jsp"%>
</body>
</html>