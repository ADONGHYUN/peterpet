<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>애완동물 돌봄 예약</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        form {
            max-width: 500px;
            margin: auto;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group div {
            margin-top: 25px;
            margin-bottom: 5px;
        }
        input[type="text"],
        input[type="date"],
        select,
        textarea {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 3px;
        }
        .checkbox-group {
            display: flex;
            justify-content: space-between;
        }
        .checkbox-label {
            display: flex;
            align-items: center;
        }
        input[type="submit"] {
            background-color: #4CAF50;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }
        .price-display {
            font-weight: bold;
            color: #333;
            margin-top: 10px;
        }
         .tooltip {
 		   position: absolute;
  		  background-color: rgb(244, 67, 54);
  		  color: rgb(255, 255, 255);
   		 padding: 5px;
  		  border-radius: 5px;
    		box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
    		font-size: 12px;
    		z-index: 1000;
    		white-space: nowrap;
    		opacity: 1;
		}
    </style>
</head>
<body>
	<script>
        function calculatePrice() {
        	var price = 100000;
        	var quantity = parseInt(document.getElementById('rcount').value);
        	if (isNaN(quantity) || quantity < 1) {
            	quantity = 1;
            }
        	var total = price * quantity;
        	document.getElementById('price').innerText = "가격: " +total+"원";
        	document.getElementById('totalPrice').value = total;
        }
        window.onload = calculatePrice;
    </script>
    <h2>애완동물 돌봄 예약</h2>
    <form action="/res/packageForm/state/insert" method="post">
        <div class="form-group">
            <div class="checkbox-group">
                <div class="checkbox-label">
                    <input type="checkbox" id="school" name="packName" value="school" checked="checked" readonly="readonly" onclick="showTooltip(); return false;">
                    <div>유치원</div>
                </div>
                <div class="checkbox-label">
                    <input type="checkbox" id="hotel" name="packName" value="hotel">
                    <div>호텔</div>
                </div>
                <div class="checkbox-label">
                    <input type="checkbox" id="beauty" name="packName" value="beauty">
                    <div>미용</div>
                </div>
            </div>
        </div>
        <div class="form-group">
            <div>맡기는 시작일:</div>
            <input type="date" id="rsday" name="rsday" required>
        </div>
        <div class="form-group">
            <div>맡기는 기간:</div>
            <input type="number" id="rperiod" name="rperiod" min="1" max="7" value="1" required>
        </div>
        <hr>
        <div class="form-group">
        	<div style="text-align: center;">펫정보</div>
        </div>
        <div class="form-group">
            <div>펫 수:</div>
            <input type="number" id="rcount" name="rcount" min="1" max="10" value="1" onchange="calculatePrice()" required>
        </div>
        <div class="form-group">
            <div>특이사항:</div>
            <textarea id="rdinfo" name="rdinfo" rows="4" placeholder="특별한 요구사항이 있다면 적어주세요."></textarea>
        </div>
        <div class="price-display" id="price">가격: 0원</div>
        <input type="hidden" id="totalPrice" name="totalPrice" value="">
        <input type="submit" value="예약하기">
    </form>
    
    <%@ include file="/WEB-INF/views/module/footer.jsp"%>
<script>
    function showTooltip() {
    	console.log("showTooltip()호출");
        var checkbox = document.getElementById("school");
        var tooltip = document.createElement("div");

        tooltip.className = "tooltip";
        tooltip.innerText = "유치원은 필수입니다";

        var rect = checkbox.getBoundingClientRect();
        tooltip.style.top = (rect.top + window.scrollY - 30) + "px";
        tooltip.style.left = (rect.left + window.scrollX + 20) + "px";

        document.body.appendChild(tooltip);
     
        setTimeout(function() {
            document.body.removeChild(tooltip);
        }, 2000); 
    }
</script>

</body>
</html>
