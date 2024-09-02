<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>관리자 상품 관리</title>
<style>
        /* 모달 스타일 */
        .myModal {
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

        .myModal-content {
            background-color: #fefefe;
            margin: 5% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 30%;
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
		.edit:hover{
			text-decoration:underline;
		}
/* 현재 페이지의 배경색과 글자색을 블랙으로 변경 */
.pagination .page-item.active .page-link {
	background-color: black; /* 블랙 배경색 */
	border-color: black; /* 블랙 테두리 색 */
	color: #fff; /* 흰색 글자색 */
}

</style>
<script type="text/javascript">
	function openModal(pcode) {
		document.getElementById("deleteModal").style.display = "block";
       	document.getElementById("deletePcode").value = pcode;
    }

    function closeModal() {
    	document.getElementById("deleteModal").style.display = "none";
    }

   	function confirmDelete() {
        var pcode = document.getElementById("deletePcode").value;
        let baseUrl = '/admin/prod/delete/';
        let searchCondition = $('#condition').val();
        let searchKeyword = $('#keyword').val();
        let page = $("#currentPage").val();

        let url = baseUrl + ${page.currentPage}+ '/' + pcode;
        if (searchKeyword && searchKeyword.trim() !== "") {
            url += '/' + searchCondition + '/' + searchKeyword;
        }
        window.location.href = url;
    }
</script>
</head>
<body>
<%@ include file="/WEB-INF/views/module/anav.jsp"%>
    <div class="container">
        <h2 class="text-center mt-5">상품 관리</h2>
        <input type="hidden" id="currentPage" value="${page.currentPage}" />
        <div class="row">
        	<div class="col-sm-6 d-flex align-items-center">
        		<form action="/admin/prod/list/1" method="post">
						<div class="input-group">
							<select class="form-select" name="searchCondition">
							<c:forEach items="${conditionMap}" var="option">
								<option value="${option.value}" <c:if test="${option.value == prod.searchCondition}">selected</c:if>>${option.key}</option>
							</c:forEach>
							</select>
							<input class="form-control" name="searchKeyword" type="text" value="${prod.searchKeyword}" />
							<input class="btn btn-dark" type="submit" value="검색" />
					</div>
				</form>
			
				<input type="hidden" id="condition" name="condition" value="${prod.searchCondition}" />
                <input type="hidden" id="keyword" name="keyword" value="${prod.searchKeyword}" />
        	</div>
        	<div class="col-sm-6 d-flex justify-content-end">
        		<button type="button" class="btn btn-dark mt-3 mb-3" onclick="location.href='/admin/prod/insertProd'">상품등록</button>
        	</div>
        </div>

		<div class="table-responsive mt-3">
        <table class="table table-striped table-bordered" id="prodTable">
        	<thead class="text-center">
            <tr>
                <th class="width_1">상품 코드</th>
                <th class="width_2">상품 이름</th>
                <th class="width_1">분류</th>
                <th class="width_1">가격</th>
                <th class="width_3">설명</th>
                <th class="width_1">대표 이미지</th>
                <th class="width_2">관리</th>
            </tr>
        </thead>
        <tbody class="text-center">
            <!-- JSTL 사용하여 prodList를 반복 -->
            <c:forEach var="product" items="${prodList}">
                <tr>
                    <td><a href="#" class="edit detail" data-pcode="${product.pcode}">${product.pcode}</a></td>
                    <td><div class="ellipsis"><c:out value="${product.pname}"/></div></td>
                    <td><c:out value="${product.ptype}"/></td>
                    <td><fmt:formatNumber type="number" value="${product.pprice}" pattern="#,##0" /></td>
                    <td><div class="ellipsis"><c:out value="${product.pdes}"/></div></td>
                    <td><c:out value="${product.pimg1}"/></td>
                    <td><a href="#" class="btn btn-outline-dark detail" data-pcode="${product.pcode}">수정</a>
                    <!-- 삭제 링크에 onclick 이벤트 추가 -->
                    <a href="javascript:void(0);" onclick="openModal('${product.pcode}')" class="btn btn-outline-dark">삭제</a></td>
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

			        let baseUrl = '/admin/prod/getProdDetail/';
			        let pcode = $(this).data('pcode');
			        let searchCondition = $('#condition').val();
			        let searchKeyword = encodeURIComponent($('#keyword').val());
			        let page = $('#currentPage').val();
					console.log("currentPage : " + page);
					
			        let url = baseUrl + page + '/' + pcode;
			        if (searchKeyword && searchKeyword.trim() !== "") {
			            url += '/' + searchCondition + '/' + searchKeyword;
			        }
			  
			        window.location.href = encodeURI(url);
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
							url : '/admin/prod/list/' + page,
							type : 'GET',
							data : { 
								condition : condition,
								keyword : keyword
								
							},
							success : function(response) {
								$('#prodTable').html($(response).find('#prodTable').html());
								$('.pagination').html($(response).find('.pagination').html());
								
								var newUrl = '/admin/prod/list/' + page;
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

    <!-- 모달 창 -->
    <div id="deleteModal" class="myModal">
        <div class="myModal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <p>정말 이 상품을 삭제하시겠습니까?</p>
            <input type="hidden" id="deletePcode" value="">
            <button onclick="confirmDelete()">확인</button>
            <button onclick="closeModal()">취소</button>
        </div>
    </div>
    <%@ include file="/WEB-INF/views/module/footer.jsp"%>
</body>
</html>