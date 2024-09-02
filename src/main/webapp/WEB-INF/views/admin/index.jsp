<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
response.setHeader("Pragma", "no-cache");
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Cache-Control", "no-store");
response.setDateHeader("Expires", 0L);
%>
<!DOCTYPE html>
<html>
<head> 
    <meta charset="UTF-8">
    <title>로그인</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #f4f4f4;
        }

        h1 {
            text-align: center;
        }

        /* Modal Styling */
        .modal {
            display: none; /* Hidden by default */
            position: fixed; /* Stay in place */
            z-index: 1; /* Sit on top */
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto; /* Enable scroll if needed */
            background: rgba(0,0,0,0.5); /* Black w/ opacity */
        }

        .modal.on {
            display: block; /* Show the modal */
            /* No animation applied here, just the background */
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-100%);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .modal .modal_popup {
            position: relative;
            margin: 5% auto;
            padding: 20px;
            background: #ffffff;
            border-radius: 10px;
            width: 100%;
            max-width: 500px; /* Changed width to 500px */
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            animation: slideIn 0.4s ease; /* Apply slide-in animation */
        }

        .modal_popup h3 {
            margin-top: 0;
        }

        .modal .modal_popup .close_btn {
            position: absolute;
            top: 10px;
            right: 10px;
            padding: 10px 20px;
            background-color: rgb(116, 0, 0);
            border: none;
            border-radius: 5px;
            color: #fff;
            cursor: pointer;
            transition: background-color 0.1s;
        }

        .modal .modal_popup .close_btn:hover {
            background-color: darkred;
        }

        /* Form Styling */
        .form-container {
            width: 100%;
            max-width: 600px;
            padding: 20px;
            background: #ffffff;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            text-align: center;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin: 0 auto; /* Center the table horizontally */
        }

        td {
            padding: 10px;
        }

        input[type="text"], input[type="password"] {
            width: 80%;
            padding: 10px;
            margin: 5px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        input[type="submit"] {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            background-color: #000; /* Changed background color to black */
            color: #fff;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        input[type="submit"]:hover {
            background-color: #333; /* Darker shade of black for hover effect */
        }
    </style>
</head>
<body>
<body>
    <div class="modal ${not empty errorMessage ? 'on' : ''}" id="errorModal">
        <div class="modal_popup" onclick="event.stopPropagation()">
            <button type="button" class="close_btn" onclick="closeModal()">닫기</button>
            <h3>오류 발생</h3>
            <p>${errorMessage != null ? errorMessage : ''}</p>
        </div>
    </div>

    <div class="form-container">
        <h1>peterpet</h1>
        <form action="/admin/login" method="post">
            <table border="1" cellpadding="0" cellspacing="0">
                <tr>
                    <td>아이디</td>
                    <td><input type="text" name="uid" /></td>
                </tr>
                <tr>
                    <td>비밀번호</td>
                    <td><input type="password" name="upw" /></td>
                </tr>
                <tr>
                    <td colspan="2" align="center">
                        <input type="submit" value="로그인" />
                    </td>
                </tr>
            </table>
        </form>
    </div>

    <script>
        window.onload = function() {
            var errorMessage = '${errorMessage}';
            var redirectUrl = '${redirectUrl}';

            if (errorMessage) {
                var modal = document.getElementById('errorModal');
                modal.classList.add('on');
                
                // 잠시 후 자동으로 리디렉션
                setTimeout(function() {
                    window.location.href = redirectUrl;
                }, 3000); // 3초 후 리디렉션
            }
        };

        function closeModal(event) {
            if (event) event.stopPropagation();
            document.getElementById('errorModal').classList.remove('on');
            // 사용자가 모달을 닫으면 짧은 시간 후 리디렉션
            var redirectUrl = '${redirectUrl}';
            if (redirectUrl) {
                setTimeout(function() {
                    window.location.href = redirectUrl;
                }, 300); // 모달 닫은 후 0.3초 후 리디렉션
            }
        }

        document.querySelector('.modal').addEventListener('click', function(event) {
            if (event.target === this) {
                closeModal(event);
            }
        });
        
        
     
    </script>
</body>
</body>
</html>
