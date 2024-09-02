<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html><html><head><meta charset="UTF-8">
<title>돌봄</title>
<style>
	#innerdiv, #consection {
		font-size: 20px;
		padding: 0px;
	}
	.info-nav:hover {
		cursor: pointer;
	}
	.resbtn {
		border-radius: 10px !important;
		padding: 10px 15px !important;
		font-size: 20px !important;
	}
	img {
		border: 1px solid #e9ecef;
		border-radius: 10px;
		background-color: white;
	}
</style>
</head>
<body>
<%@ include file="/WEB-INF/views/module/c_header.jsp"%>
<div class="container mt-5">
	<h2 class="text-center mb-5">돌봄 안내</h2>
		<div id="consection" class="container-fluid">
			<div id="innerdiv" class="container">
				<ul class="nav nav-tabs nav-justified">
					<li class="nav-item">
					<a class="info-nav nav-link active" data-num="1">유치원</a></li>
					<li class="nav-item">
					<a class="info-nav nav-link" data-num="2">호텔</a></li>
					<li class="nav-item">
					<a class="info-nav nav-link" data-num="3">미용</a></li>
				</ul>
			</div>
		</div>
	
	<div id="info-section" class="container mt-3 rounded-3 px-0">
		<div class="my-3">
		<img src="${pageContext.request.contextPath}/resources/petschool.png"
				alt="petschool" class="d-block" style="width: 100%">
		</div>
		
		<table class="table border-white mb-0">
			<tbody class="row">
				<tr class="col-sm-6 col-lg-6 d-flex justify-content-center mb-4">
				<td class="p-0">
					<h3>반려견 놀이방</h3>
					<p>견주가 급한 약속이 있거나 볼일을 봐야 할 경우, 우리 댕댕이를 믿고 안전하게 맡길 수 있는 서비스입니다.</p>
					<p>
						<strong>* 여러 아이들이 함께 사용하는 공간입니다. 깨끗한 상태로 맡겨주세요 *</strong>
					</p>
					<p>
						<strong>* 놀이방 또는 호텔 예약/이용 시, 신분증 검사를 합니다 *</strong>
					</p>
					<p>
						<strong>* 18시 이후 시간 초과 시, 시간당 5,000원의 요금이 추가됩니다 *</strong>
					</p>
				</td></tr>
				<tr class="col-sm-6 col-lg-6 d-flex justify-content-center mb-4">
				<td class="p-0">
					<h3>유치원 등록</h3>
					<p>모든 아이들은 성향(적응) 테스트 후 입학 여부가 결정됩니다.</p>
					<p>아이들이 안전할 수 있도록 하기 위함이니 이해 바랍니다.</p>
					<h3>목적에 맞는 유치원 운영</h3>
					<p>
						교육기관이 아닌 <strong>*산책/놀이/스트레스 해소*</strong> 목적의 유치원입니다.
					</p>
					<p>
						<strong>* 8kg 미만 소형견 유치원/놀이방이므로, 중대형견은 이용이 어려운 점 미리 안내해드립니다. *</strong>
					</p>
						</td></tr>
					<tr class="col-sm-6 col-lg-6 d-flex justify-content-center mb-4">
					<td class="p-0">
					<h3>유의사항</h3>
					<ul>
						<li>☑ 반려견 특성에 따라 교육 과정이 변경되거나 다를 수 있습니다.</li>
						<li>☑ 3개월 등록 시와 스페셜 패키지의 할인은 중복 적용되지 않습니다.</li>
						<li>☑ 유치원은 평일만 운영합니다. (월요일 ~ 금요일)</li>
						<li>☑ 정기요일형은 정해진 요일 외 변경이 어렵습니다.</li>
					</ul>
					<h3>환불규정</h3>
					<p>☑ 이용횟수 X 정가(할인 전 금액)로 계산하여 요금 차감 후 환불처리 됩니다.</p>
				</td></tr>
			</tbody>
		</table>
		
	</div>
	<div class="text-right my-3">
		<a href="/res/packageForm" class="resbtn btn btn-primary">돌봄 예약</a>
	</div>
</div>

<%@ include file="/WEB-INF/views/module/footer.jsp"%>

<script>
	$(document).ready(function() {
		$('.info-nav').on('click', function(event) {
			event.preventDefault();
			
			var num = $(this).data('num');
			setActiveTab(num);
			fetchInfo(num);
			console.log('클릭한 num: ', num);
		});
		
		function fetchInfo(num) {
			$.ajax({
				method: 'GET',
				url: './info/' + num,
				success: function(response) {
					
					if (!response || response.length === 0) {
                        $('#info-section').html('<p>안내 사항이 없습니다.</p>');
                        return;
                    }
					
					$('#info-section').html(response);
				},
				error: function(xhr, status, error) {
					console.error('AJAX 오류 발생:', status, error);
					$('#info-section').html('<p>안내 사항을 가져오는 데 실패했습니다.</p>');
				}
			});
		}
		
		function setActiveTab(num) {
            $('.info-nav').removeClass('active');

            $('.info-nav').each(function() {
                if ($(this).data('num') === num) {
                    $(this).addClass('active');
                }
            });
        }

	});
</script>
</body></html>
