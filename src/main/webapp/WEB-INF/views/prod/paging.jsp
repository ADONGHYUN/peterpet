<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="kr.co.peterpet.prod.PageInfo"%>
<%
    PageInfo pageInfo = (PageInfo)request.getAttribute("pageInfo");
	int listCount=pageInfo.getListCount();
	int nowPage=pageInfo.getPage();
	int maxPage=pageInfo.getMaxPage();
	int startPage=pageInfo.getStartPage();
	int endPage=pageInfo.getEndPage();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<script>
$(document).ready(function() {   	
    if(document.location.hash){
    	var page = document.location.hash.replace("#","");
    	loadPage(page)
    }else{ 
    	history.pushState({page:1},null,'./list/1');
		loadPage(1);
    } 
        
});

$(document).on('click', '.page-link', function(e) {
	e.preventDefault();
    var page = $(this).data('page');
    console.log(page);            
    loadPage(page);
    history.pushState({page:page},null,'./list/' + page);             
});

$(window).on('popstate', function(event) {
	  var data = event.originalEvent.state;
	   loadPage(data.page);
	});

function loadPage(page) {
   	 $.ajax({
            url: './list/' + page,
            method: 'GET',
            success: function(response) {
               $('#product-body').empty();
               
               if (!response || response.length === 0) {
                   $('#product-body').html('<tr><td colspan="6" class="text-center">상품이 없습니다.</td></tr>');
                   return;
               }
               var html = '';

				$.each(response, function(index, prod) {
				    var formattedPrice = formatPrice(prod.pprice);
				    
				    html += '<tr class="col-sm-6 col-lg-4 d-flex justify-content-center mb-4">';
				    html += '<td class="p-0">';
				    html += '<div class="pt-3 d-flex justify-content-center">';
				    html += '<a id="prodlink" href="detail/pcode/' + prod.pcode + '">';
				    html += '<img class="d-block img-thumbnail" title="' + prod.pimg1 + '" alt="' + prod.pimg1 + '" src="/resources/upload/' + prod.pimg1 + '"><br>';
				    html += '<span class="text-center align-middle d-block fs-5">' + prod.pname + '</span></a>';
				    html += '</div>';
				    html += '<div class="text-center">';
				    html += '<hr>';
				    html += '<span class="d-block pt-3 fs-4">' + formattedPrice + '원</span>';
				    html += '<input type="hidden" name="ptype" value="' + prod.ptype + '">';
				    html += '</div>';
				    html += '</td>';
				    html += '</tr>';
				});
				
               $('#product-body').html(html);
               
               var pagination = $('#pagination');
               pagination.empty();
               var start = Math.floor((page-1)/5)*5+1;
               var end = start+4;
               var max = <%=maxPage%>;
               if((page-1)/5 >=1){
            	   var jeon = ((Math.floor((page-5.95)/5))*5)+1;
            	   pagination.append('<li class="page-item"><a class="page-link" data-page="'+ jeon +'">〈</a><li>');
               }
               if(end<max){
            	   for(var i = start ;  i <=end; i++){
                	   if(i == page){
                		   pagination.append('<li class="page-item active"><a class="page-link" data-page='+i+'>'+i+'</a></li>');
                	   }else{
                		   pagination.append('<li class="page-item"><a class="page-link" data-page='+i+'>'+i+'</a></li>');
                	   }
                   }
            	   var daum = end+1;
            	   pagination.append('<li class="page-item"><a class="page-link" data-page="'+ daum +'">〉</a></li>');
               }else{
            	   for(var i = start ;  i <=max; i++){
                	   if(i == page){
                		   pagination.append('<li class="page-item active"><a class="page-link" data-page='+i+'>'+i+'</a></li>');
                	   }else{
                		   pagination.append('<li class="page-item"><a class="page-link" data-page='+i+'>'+i+'</a></li>');
                	   }
                   } 
               }                                
           },
           error: function(request, status, error) {
               console.log("code:"+request.status+"\n"+"error:"+error);
           }
       });       	
   }
</script>
</body>
</html>