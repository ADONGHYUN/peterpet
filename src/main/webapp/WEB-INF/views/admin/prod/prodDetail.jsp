<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko"><head>
<title>Admin</title>
<meta charset="utf-8">
<style>
	textarea {resize: none !important;}
</style>
<script>
	function back(){
		document.getElementById("listForm").submit();
	}
	
</script>
<script>
	function previewImage(event){
		const MAX_FILE_SIZE = 3 * 1024 * 1024; //파일 크기 제한
		const file = event.target.files[0];
		console.log("파일 이름 : " + file.name);
		
		if(file.size > MAX_FILE_SIZE){
			$('#chkFile').css('color', 'red');
			$('#chkFile').html("&nbsp;파일 크기가 3MB를 초과합니다.");
			$('#chkFile').css('display', 'block');
			var preview = document.getElementById("preview");
			preview.src="/resources/noImg.png";
			return;
		}
		if(file.name.length > 20){
			alert("파일 글자 수 제한: 20글자");
			 event.target.value = "";
			 preview.src="/resources/noImg.png";
		}
		
		$('#chkFile').css('display', 'none');
		
		var preview = document.getElementById("preview");
		preview.src = URL.createObjectURL(file);
	}
	
</script>
</head>
<body>
<%@ include file="/WEB-INF/views/module/anav.jsp"%>
<div class="container mt-3">
  <h2 class="text-center">상품 상세</h2>
  <form action= "/admin/prod/list/${page}" method="post" id="listForm">
  	<input type="hidden" id=searchCondition name="searchCondition" value="${prod.searchCondition}" />
  	<input type="hidden" id=searchKeyword name="searchKeyword" value="${prod.searchKeyword}" />
  </form>
  <form id="insertForm" action="/admin/prod/updateProd/${page}" method="post" enctype="multipart/form-data">
  	<div class="mt-5">
    	<div class="row">
    		<div class="col-sm-1"></div>
    		<div class="col-sm-5">
    			<div class="row">
    				<label class="text-center form-label">이미지</label>
    			</div>
    			<div class="row">
                    <img id="preview" class="img-thumbnail d-block" src="${pageContext.request.contextPath}/resources/upload/${prod.pimg1}" title="상품 이미지" alt="${prod.pname}"/><br>
                </div>
                <div class="row mt-1">
                	<div class="col-sm-4"></div>
                	<div class="col-sm-8">
                    	<span class="d-flex justify-content-end">기존 업로드 이미지 : ${prod.pimg1}</span>
                    	<input type="hidden" id="pimg1" name="pimg1" value="${prod.pimg1}"/>
                	</div>
    			</div>
                <div class="row">
                	<div class="col-sm-4"><label class="form-label">대표 이미지*</label></div>
                	<div class="col-sm-8">
                		<input class="form-control" name="uploadFile1" type="file" id="uploadFile1" accept="image/*" 
                			onchange="previewImage(event)" maxlength="20" oninput="validation()"/>
                		<div class="row mb-1">
                			<div id="chkFile"></div>
                		</div>
                	</div>
    			</div>
    			<div class="row">
                	<div class="col-sm-4"><label class="form-label">추가 이미지</label></div>
                	<div class="col-sm-8">
                    	<input class="form-control" name="uploadFile2" type="file" id="uploadFile2" accept="image/*" multiple oninput="validation()"/>
                    	<input type="hidden" id="pimg2" name="pimg2" value="${prod.pimg2}"/>
                	</div>
    			</div>
    		</div>
    		<div class="col-sm-5">
    			<div class="row mt-4">
    				<div class="col-sm-1"></div>
    				<div class="col-sm-11">
    					<div class="row"><label for="ptype">종류*</label></div>
    					<div class="row"><input type="text" class="form-control" value="${prod.ptype}" disabled /></div>
    				</div>
    			</div>
    			<div class="row mt-5">
    				<div class="col-sm-1"></div>
    				<div class="col-sm-11">
    					<div class="row"><label class="form-label" for="pcode" >상품코드*</label></div>
    				<div class="row">
						<input class="form-control" type="text" value="${prod.pcode}" disabled>
						<input type="hidden" id="pcode" name="pcode" value="${prod.pcode}" /></div>
    				</div>
    			</div>
    			<div class="row mt-5">
    				<div class="col-sm-1"></div>
    				<div class="col-sm-11">
    					<div class="row"><label class="form-label" for="pname">상품명*</label></div>
    					<div class="row"><textarea class="form-control" id="pname" name="pname" cols="10" rows="2" onchange="validation()">${prod.pname}</textarea></div>
    				</div>
    			</div>
    			<div class="row mt-5">
    				<div class="col-sm-1"></div>
    				<div class="col-sm-11">
    					<div class="row"><label class="form-label" for="pprice">가격*</label></div>
    					<div class="row"><input class="form-control" type="text" id="pprice" name="pprice" value="${prod.pprice}" onchange="validation()"></div>
    					<input type="hidden" id=searchCondition name="searchCondition" value="${prod.searchCondition}" />
  						<input type="hidden" id=searchKeyword name="searchKeyword" value="${prod.searchKeyword}" />
    				</div>
    			</div>
    		</div>
   			<div class="col-sm-1"></div>
    	</div>
    	<div class="row mt-5">
    		<div class="col-sm-1"></div>
    		<div class="col-sm-10">
    			<div class="row">
    				<div class="col-sm-2">설명*</div>
    				<div class="col-sm-10"><textarea class="form-control" id="pdes" name="pdes" cols="80" rows="20" onchange="validation()" oninput="validation()">${prod.pdes}</textarea></div>
    			</div>
    			<div class="row mt-3">
    				<div class="col-sm-3"></div>
    				<div class="col-sm-5"></div>
    				<div class="col-sm-2 d-flex justify-content-end"><input type="button" onclick="back()" class="btn btn-outline-secondary" value="상품 목록"></div>
    				<div class="col-sm-1"><input type="submit" id="submitBtn" onclick="handleSubmit()" disabled class="btn btn-outline-secondary" value="수정"></div>
    				<div class="col-sm-1"><input type="button" onclick="back()" class="btn btn-outline-secondary" value="취소"></div>
    			</div>
    		</div>
    		<div class="col-sm-1"></div>
    	</div>
    </div>
  </form>
</div>
<script>
function handleSubmit() {
    if (validation()) {
        // 폼을 제출합니다.
        document.getElementById("insertForm").submit();
    } else {
        console.log("폼 검증 실패");
    }
}

	function validation() {
		var pname = document.getElementById("pname");
		var pprice = document.getElementById("pprice");
		var pdes = document.getElementById("pdes");
		
	    var isPnameNotEmpty = pname.value.trim().length > 0;
	    var isPpriceNotEmpty = pprice.value.trim().length > 0;
	    var isPdesNotEmpty = pdes.value.trim().length > 0;
	
	    var able = isPnameNotEmpty && isPpriceNotEmpty && isPdesNotEmpty;
	    
	    if(able) {
	    	document.getElementById("submitBtn").disabled = false;
	    } else {
	    	document.getElementById("submitBtn").disabled = true;
	    }
	    
	    return able;
	}
</script>
<%@ include file="/WEB-INF/views/module/footer.jsp"%>
</body></html>




