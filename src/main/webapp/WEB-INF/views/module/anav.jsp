<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
response.setHeader("Pragma", "no-cache");
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Cache-Control", "no-store");
response.setDateHeader("Expires", 0L);
%>
<%
HttpSession session = request.getSession();
String userId = request.getParameter("userId");

if ( userId != null &&  userId.equals("admin")) {
    session.setAttribute(" userId",  userId);
}
%>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
#header {
	padding-left: 40px;
}

header nav {
	vertical-align: middle;
	background-color: #343a40;
}

header a.navbar-brand {
	padding: 10px 0;
	font-size: 40px;
	font-weight: bold;
	color: white;
}

header .navbar {
	font-size: 30px;
	color: white;
	margin: auto;
	width: 100%;
}

header .nav-link {
	color: white;
	margin: 0 20px;
}

header .nav-link:hover {
	font-weight: bold;
	color: white;
}

header .navbar-toggler {
	background-color: #343a40;
}

</style>


<header>
	<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
		<div id="header" class="container-fluid">

			<a class="navbar-brand ms-0" href="/admin/user/index"> peterpet </a>

			<button class="navbar-toggler" type="button"
				data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent">
				<span class="navbar-toggler-icon"></span>
			</button>

			<div class="collapse navbar-collapse" id="navbarSupportedContent">
				<ul class="navbar-nav me-auto mb-2 mb-lg-0">
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<li class="nav-item"><a class="nav-link" href="/admin/user/getlist/1/uname">회원 관리</a></li>
					&nbsp;&nbsp;
					<li class="nav-item"><a class="nav-link" href="/admin/prod/list/1">상품 관리</a></li>
					&nbsp;
					&nbsp;
					<li class="nav-item"><a class="nav-link" href="/admin/res/list/">예약 관리</a></li>
					&nbsp;
					&nbsp;
					<li class="nav-item"><a class="nav-link" href="/admin/pay/list/1">결제 관리</a></li>
				
				</ul>
				<ul class="navbar-nav">
					<li class="nav-item"><a class="nav-link" href="/">CLIENT</a></li>
					<li class="nav-item"><a class="nav-link" href="/adminlogout">로그아웃</a></li>
				</ul>
			</div>
		</div>
	</nav>
</header>

