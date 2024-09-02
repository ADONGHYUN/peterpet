<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko"><head>
<title>Admin</title>
<meta charset="utf-8">
<style>
	textarea {resize: none !important;}
	#preview { display:none;}
	#chkDuplicate{ width: 100%;}
	#chkID{
		color:#999;
		padding: 5px 12px;
		display:none;
	}
</style>
<script>
	function back(){
		location.href="/admin/prod/list";
	}
	
	function getPcode(){
		var ptype = document.getElementById("ptype").value;
		$.ajax({
			type: 'GET',
			url: '/admin/prod/getPcode',
			data: {ptype: ptype},
			dataType: 'json',
			success: function(result){
				var pcode = document.getElementById("pcode");
				if (result && result.pcode) {
	                pcode.placeholder = result.pcode;
	            } else {
	                console.error("응답 데이터에 pcode가 없음:", result);
	            }
			},
			error: function(xhr, status, error) {
		        console.error("AJAX 요청 오류:", status, error);
		 	}
		});
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
	
	function checkEnter(event) {
	    if (event.key === "Enter") {
	    	checkID();
	    }
	}
	
	function checkID(){
		var status = $('#pcode').attr('data-status');
		console.log("가져온 status : " + status);
		var pcode = $('#pcode').val();
		console.log("pcode = " + pcode);
		$('#chkPcode').html("");
		
		if(pcode == ""){
			$('#chkPcode').css('display', 'block');
			$('#chkPcode').html("&nbsp;상품코드를 입력해주세요.");
			$('#chkPcode').css('color', 'gray');
			$('#pcode').focus();
			return
		}
		
		$.ajax({
			url: '/admin/prod/checkPcode',
			type: 'POST',
			data: { pcode : pcode },
			success: function(result){
				if(result.exist === "1"){
					$('#pcode').attr('data-status', 'no');
					$('#chkPcode').css('color', 'red');
					$('#chkPcode').html("&nbsp;이미 존재하는 상품코드입니다.");
					$('#chkPcode').css('display', 'block');
					$('#pcode').focus();
					$('#pcode').value="";
				} else{
					$('#pcode').attr('data-status', 'yes');
					$('#chkPcode').css('color', 'blue');
					$('#chkPcode').html("&nbsp;사용 가능한 상품코드입니다.");
					$('#chkPcode').css('display', 'block');
				}
			},
			error: function(xhr, status, error){console.error("Ajax Error " + status);}
		});
	}
	
</script>
</head>
<body>
<%@ include file="/WEB-INF/views/module/anav.jsp"%>
<div class="container mt-3">
  <h2 class="text-center">상품 등록</h2>
  <form id="insertForm" action="./insertProd" method="post" enctype="multipart/form-data">
  	<div class="mt-5">
    	<div class="row">
    		<div class="col-sm-1"></div>
    		<div class="col-sm-5">
    			<div class="row">
    				<label class="text-center form-label">이미지</label>
    			</div>
    			<div class="row">
                    <img id="preview" class="img-thumbnail d-block" src="${pageContext.request.contextPath}/resources/noImg.png" title="상품 이미지" alt="이미지 미리보기"/><br>
                </div>
                <div class="row mt-3">
                	<div class="col-sm-4"><label class="form-label">대표 이미지*</label></div>
                	<div class="col-sm-8">
                		<input class="form-control" name="uploadFile1" type="file" id="uploadFile1" accept="image/*" onchange="previewImage(event)" required/>
                		<div class="row mb-1">
                			<div id="chkFile"></div>
                		</div>
                	</div>
    			</div>
    			<div class="row">
                	<div class="col-sm-4"><label class="form-label">추가 이미지</label></div>
                	<div class="col-sm-8">
                    	<input class="form-control" name="uploadFile2" type="file" id="uploadFile2" accept=".jpg,.png" multiple/>
                	</div>
    			</div>
    		</div>
    		<div class="col-sm-5">
    			<div class="row mt-5">
    				<div class="col-sm-1"></div>
    				<div class="col-sm-3"><label for="ptype">종류*</label></div>
    				<div class="col-sm-8">
    					<select class="form-select" name="ptype" id="ptype" onchange="getPcode()" required>
    						<option value="null">---종류를 선택해주세요---</option>
    						<option value="간식">간식</option>
    						<option value="미용">미용</option>
    						<option value="사료">사료</option>
    						<option value="영양제">영양제</option>
    						<option value="장난감">장난감</option>
    					</select>
    				</div>
    			</div>
    			<div class="row mt-5">
    				<div class="col-sm-1"></div>
    				<div class="col-sm-3"><label class="form-label" for="pcode" >상품코드*</label></div>
    				<div class="col-sm-8">
    					<div class="row">
    						<div class="col"><input class="form-control" type="text" id="pcode" name="pcode" data-status="" placeholder="" onkeypress="checkEnter(event)" required></div>
    						<div class="col-auto"><button id=chkDuplicate type="button" class="btn btn-outline-secondary" onclick="checkID()">중복확인</button></div>
    					</div>
    					<div class="row">
    						<div id="chkPcode"></div>
    					</div>
    				</div>
    			</div>
    			<div class="row mt-5">
    				<div class="col-sm-1"></div>
    				<div class="col-sm-3"><label class="form-label" for="pname">상품명*</label></div>
    				<div class="col-sm-8"><input class="form-control" type="text" id="pname" name="pname" required></div>
    			</div>
    			<div class="row mt-5">
    				<div class="col-sm-1"></div>
    				<div class="col-sm-3"><label class="form-label" for="pprice">가격*</label></div>
    				<div class="col-sm-8"><input class="form-control" type="text" id="pprice" name="pprice" required></div>
    			</div>
    		</div>
   			<div class="col-sm-1"></div>
    	</div>
    	<div class="row mt-5">
    		<div class="col-sm-1"></div>
    		<div class="col-sm-10">
    			<div class="row">
    				<div class="col-sm-2">설명*</div>
    				<div class="col-sm-10"><textarea class="form-control" id="pdes" name="pdes" cols="80" rows="20" onchange="validation()" oninput="validation()" required></textarea></div>
    			</div>
    			<div class="row mt-3">
    				<div class="col-sm-3"></div>
    				<div class="col-sm-6"></div>
    				<div class="col-sm-1"><input type="submit" id="submitBtn" onclick="handleSubmit()" disabled class="btn btn-outline-secondary" value="등록"></div>
    				<div class="col-sm-1"><input type="button" onclick="back()" class="btn btn-outline-secondary" value="취소"></div>
    				<div class="col-sm-1"></div>
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
		var file = document.getElementById("uploadFile1");
		var ptype = document.getElementById("ptype");
		var pcode = document.getElementById("pcode");
		var pname = document.getElementById("pname");
		var pprice = document.getElementById("pprice");
		var pdes = document.getElementById("pdes");
		var pcodeStatus = pcode.getAttribute('data-status');
		
		var isPcodeValid = (pcodeStatus === 'yes');
	    var isPtypeValid = ptype.value && ptype.value !== 'null';
	    var isPcodeNotEmpty = pcode.value.trim().length > 0;
	    var isPnameNotEmpty = pname.value.trim().length > 0;
	    var isPpriceNotEmpty = pprice.value.trim().length > 0;
	    var isPdesNotEmpty = pdes.value.trim().length > 0;
	
	    var able = isPcodeValid && isPtypeValid && isPcodeNotEmpty && isPnameNotEmpty && isPpriceNotEmpty && isPdesNotEmpty;
	    
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




