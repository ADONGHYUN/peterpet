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
ul {
	margin: 0 auto;
}
</style>
<%
HttpSession session = request.getSession();
String loginID = (String) session.getAttribute("userId");
String btnValue1 = "";
String btnHref1 = "";
String btnValue2 = "";
String btnHref2 = "";

if (loginID == null || loginID.trim().equals("")) {
	btnValue1 = "로그인";
	btnHref1 = "/login";
	btnValue2 = "회원가입";
	btnHref2 = "/user/join";
} else if (loginID.equals("admin")) {
	btnValue1 = "관리자";
	btnHref1 = "/admin/user/index";
	btnValue2 = "로그아웃";
	btnHref2 = "/logout";
} else {
	btnValue1 = "내정보";
	btnHref1 = "/user/myInfo";
	btnValue2 = "로그아웃";
	btnHref2 = "/logout";
}
%>

<header>
	<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
		<div id="header" class="container-fluid">

			<a class="navbar-brand ms-0" href="<%=request.getContextPath()%>/"> peterpet </a>

			<button class="navbar-toggler" type="button"
				data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent">
				<span class="navbar-toggler-icon"></span>
			</button>

			<div class="collapse navbar-collapse" id="navbarSupportedContent">
				<ul class="navbar-nav me-auto mb-2 mb-lg-0">
					<li class="nav-item"><a class="nav-link" href="/prod/list">상품</a></li>
					<li class="nav-item"><a class="nav-link" href="/prod/info">돌봄</a></li>
					<li class="nav-item"><a id="loginButton" class="nav-link"
						href="<%=btnHref1%>"><%=btnValue1%></a></li>
					<li class="nav-item"><a id="joinButton" class="nav-link"
						href="<%=btnHref2%>"><%=btnValue2%></a></li>
				</ul>
			</div>
		</div>
	</nav>
</header>

