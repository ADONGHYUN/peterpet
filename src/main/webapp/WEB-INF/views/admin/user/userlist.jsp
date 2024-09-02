<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Pragma", "no-cache");
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Cache-Control", "no-store");
response.setDateHeader("Expires", 0L);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>회원 관리</title>
<style>
/* 스타일은 그대로 유지 */
</style>
</head>
<body>
    <%@ include file="/WEB-INF/views/module/anav.jsp"%>
    <div class="container">
        <h2 class="text-center mt-5">회원 관리</h2>

        <!-- 검색 폼 -->
        <form id="searchForm" action="#" method="get">
            <table>
                <tr>
                    <td align="right">
                        <select name="searchCondition">
                            <c:forEach items="${conditionMap}" var="option">
                                <option value="${option.value}" ${option.value == vo.searchCondition ? 'selected' : ''}>${option.key}</option>
                            </c:forEach>
                        </select>
                        <input name="searchKeyword" type="text" value="${vo.searchKeyword}" />
                        <input type="submit" value="검색" />
                    </td>
                </tr>
            </table>
        </form>

        <!-- 사용자 목록 테이블 -->
        <div class="table-responsive mt-3">
            <table class="table table-striped table-bordered" id="userTable">
                <thead class="text-center">
                    <tr>
                        <th>아이디</th>
                        <th>이름</th>
                        <th>전화번호</th>
                        <th>이메일</th>
                        <th>생년월일</th>
                        <th>우편번호</th>
                        <th>주소</th>
                        <th>관리</th>
                    </tr>
                </thead>
                <tbody class="text-center">
                    <!-- 사용자 목록이 여기에 동적으로 삽입됩니다 -->
                </tbody>
            </table>
        </div>

        <!-- 회원 등록 버튼 -->
        <div class="col text-end mt-3">
            <button type="button" class="btn btn-sm btn-dark mt-3 mb-3" style="width:90px; font-size: 16px;" onclick="location.href='/admin/user/insert'">회원등록</button>
        </div>

        <!-- 페이지네이션 -->
        <nav id="paginationNav">
            <ul class="pagination justify-content-center mb-5">
                <!-- 페이지네이션 링크가 여기에 동적으로 삽입됩니다 -->
            </ul>
        </nav>

        <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
        <script>
        $(document).ready(function() {
            var currentPage = ${vo.page};  // JSP에서 현재 페이지 값을 JavaScript 변수로 설정
            var initialSearchCondition = '${vo.searchCondition}';  // JSP에서 검색 조건 값을 문자열로 설정
            var initialSearchKeyword = '${vo.searchKeyword}';  // JSP에서 검색어 값을 문자열로 설정

            loadUserList(currentPage, initialSearchCondition, initialSearchKeyword);  // 페이지 로드 시 현재 페이지 데이터 로드

            // 검색 폼 제출 이벤트
            $('#searchForm').on('submit', function(e) {
                e.preventDefault();  // 폼 기본 제출 동작 방지
                var searchCondition = $('select[name="searchCondition"]').val() || 'uname';  // 검색 조건
                var searchKeyword = $('input[name="searchKeyword"]').val() || '';  // 검색어
                loadUserList(1, searchCondition, searchKeyword);  // 첫 페이지부터 데이터 로드
            });
        });

        function loadUserList(page, searchCondition, searchKeyword) {
            var url = '/admin/user/getlistAjax/' + page + '/' + encodeURIComponent(searchCondition) + '?searchKeyword=' + encodeURIComponent(searchKeyword);
            $.ajax({
                url: url,
                type: 'GET',
                success: function(response) {
                    console.log(response);
                    updateTable(response.user, page, searchCondition, searchKeyword);
                    updatePagination(response.vo);
                    $('#currentPage').text(page);
                },
                error: function(xhr, status, error) {
                    console.error('AJAX Error:', status, error);
                }
            });
        }

        function updateTable(users, currentPage, searchCondition, searchKeyword) {
            var tbody = $('#userTable tbody');
            tbody.empty();  // 기존 내용 삭제

            if (users.length > 0) {
                $.each(users, function(index, user) {
                    var row = '<tr>' +
                        '<td><a href="/admin/user/getdetail/' + encodeURIComponent(user.uid) + '/' + encodeURIComponent(currentPage) + '/' + encodeURIComponent(searchCondition) + '?searchKeyword=' + encodeURIComponent(searchKeyword) +
                        '" class="btn btn-sm editBtn" style="border:0; font-weight: bold; font-size:16px; text-decoration: none; color: black;" ' +
                        'onmouseover="this.style.textDecoration=\'underline\'" onmouseout="this.style.textDecoration=\'none\'">' + user.uid + '</a></td>' +
                        '<td>' + user.uname + '</td>' +
                        '<td>' + user.utel + '</td>' +
                        '<td>' + user.uemail + '</td>' +
                        '<td>' + user.ubirth + '</td>' +
                        '<td>' + user.zcode + '</td>' +
                        '<td>' + user.addr + '</td>' +
                        '<td>' +
                        '<button type="button" class="btn btn-sm btn-outline-dark editBtn" style="width:50px; font-size: 16px;" onclick="location.href=\'/admin/user/getdetail/' + encodeURIComponent(user.uid) + '/' + encodeURIComponent(currentPage) + '/' + encodeURIComponent(searchCondition) + '?searchKeyword=' + encodeURIComponent(searchKeyword) + '\'">수정</button>' +
                        '<button type="button" onclick="confirmAndDelete(\'' + encodeURIComponent(user.uid) + '\', ' + encodeURIComponent(currentPage) + ', \'' + encodeURIComponent(searchCondition) + '\', \'' + encodeURIComponent(searchKeyword) + '\')" class="btn btn-sm btn-outline-dark" style="width:50px; font-size: 16px;">삭제</button>' +
                        '</td>' +
                        '</tr>';
                    tbody.append(row);
                });
            } else {
                tbody.append('<tr><td colspan="8" class="text-center">등록된 글이 없습니다.</td></tr>');
            }
        }

        function updatePagination(vo) {
            var ul = $('#paginationNav ul');
            ul.empty();  // 기존 페이지네이션 삭제

            var searchCondition = $('select[name="searchCondition"]').val() || 'uname';  // 검색 조건
            var searchKeyword = $('input[name="searchKeyword"]').val() || '';  // 검색어

            // 이전 페이지 버튼
            if (vo.page > 1) {
                ul.append('<li class="page-item"><a class="page-link text-dark" href="#" onclick="loadUserList(' + (vo.page - 1) + ', \'' + encodeURIComponent(searchCondition) + '\', \'' + encodeURIComponent(searchKeyword) + '\'); return false;">이전</a></li>');
            } else {
                ul.append('<li class="page-item disabled"><span class="page-link text-dark">이전</span></li>');
            }

            // 페이지 버튼
            for (var i = vo.startPage; i <= vo.endPage; i++) {
                if (i === vo.page) {
                    ul.append('<li class="page-item active"><span class="page-link">' + i + '</span></li>');
                } else {
                    ul.append('<li class="page-item"><a class="page-link text-dark" href="#" onclick="loadUserList(' + i + ', \'' + encodeURIComponent(searchCondition) + '\', \'' + encodeURIComponent(searchKeyword) + '\'); return false;">' + i + '</a></li>');
                }
            }

            // 다음 페이지 버튼
            if (vo.page < vo.maxPage) {
                ul.append('<li class="page-item"><a class="page-link text-dark" href="#" onclick="loadUserList(' + (vo.page + 1) + ', \'' + encodeURIComponent(searchCondition) + '\', \'' + encodeURIComponent(searchKeyword) + '\'); return false;">다음</a></li>');
            } else {
                ul.append('<li class="page-item disabled"><span class="page-link text-dark">다음</span></li>');
            }
        }

        function confirmAndDelete(userId, page, searchCondition, searchKeyword) {
            if (confirm('정말로 삭제하시겠습니까?')) {
                var deleteUrl = '/admin/user/delete/' + encodeURIComponent(userId) + '/' + encodeURIComponent(page) + '/' + encodeURIComponent(searchCondition) + '?searchKeyword=' + encodeURIComponent(searchKeyword);
                location.href = deleteUrl;
            }
        }
        </script>

    </div>
    <br />
    <jsp:include page="/WEB-INF/views/module/footer.jsp" />
</body>
</html>
