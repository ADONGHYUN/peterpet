document.addEventListener('DOMContentLoaded', function() {
    const editP = document.getElementById('editProfile');
    const cancle = document.getElementById('cancle');
    const save = document.getElementById('save');
    const deleteA = document.getElementById('deleteAccount');
    const PWtr = document.getElementById('PWtr');
    const cPW = document.getElementById('changePW');
    const sns = document.getElementById('snsTr');
    const button1 = document.getElementById('deleteAPI1');
    const button2 = document.getElementById('deleteAPI2');
	const type = JSON.parse(window.type);
	const email = document.getElementById('uemail');
	const tel = document.getElementById('utel');
	let pwWindow = null;
	let deleteWindow = null;
	
	// ID 표기
	document.getElementById('uid').value = type.id === 1 ? window.id : 'SNS 로그인';

	function setButton(button, text, bg, color, mR='0px') {
		button.textContent = text;
		button.style.backgroundColor = bg;
		button.style.color=color;
		button.style.marginRight=mR;
		button.style.fontSize = '14px';
	    button.style.borderRadius = '4px'; 
	    button.style.cursor = 'auto';
		button.style.pointerEvents = 'none';
		button.addEventListener('mouseout', () => {
		        button.style.backgroundColor = bg;
		    });
	    button.classList.remove('d-none');
	}
	
	function setButton2(button, text, hv, disabled=false) {
		button.textContent = text;
		button.style.cursor = disabled ? 'pointer' : 'auto';
		button.style.pointerEvents = disabled? 'auto' : 'none';
		if(disabled) {
			button.addEventListener('mouseover', () => {
	        button.style.backgroundColor = hv;
	    	});
	    }
	}
	
	function resetButton() {
	    if (type.kakao === 1 && type.naver === 1) {
	        setButton(button1, 'K', '#F7E300', '#000000', '10px', '#F0C000');
			setButton(button2, 'N', '#03C75A', 'white', '10px', '#028C4E');
	        sns.classList.remove('d-none');
	    } else if (type.kakao === 1) {
	        setButton(button1, 'K', '#F7E300', '#000000', '10px', '#F0C000');
	        sns.classList.remove('d-none');
	    } else if (type.naver === 1) {
	        setButton(button1, 'N', '#03C75A', 'white', '10px', '#028C4E');
	        sns.classList.remove('d-none');
	    }
    }
    resetButton();
    
    function setButtonStyle(disabled=false) {
	    if (type.kakao === 1 && type.naver === 1) {
	        	setButton2(button1, disabled ? 'K 연동해제' : 'K', '#F0C000', disabled);
				setButton2(button2, disabled ? 'N 연동해제' : 'N', '#028C4E', disabled);
	    	} else if (type.kakao === 1) {
	        	setButton2(button1, disabled ? 'K 연동해제' : 'K', '#F0C000', disabled);
	    	} else if (type.naver === 1) {
	        	setButton2(button1, disabled ? 'N 연동해제' : 'N', '#028C4E', disabled);
	    	}
	}
	
	editP.addEventListener('click', function() {
		document.getElementById('utel').disabled = false;
		document.getElementById('utel').disabled = false;
	    document.getElementById('uemail').disabled = false;
	    document.getElementById('findPostcode').disabled = false;
	    document.getElementById('sample4_detailAddress').disabled = false;
		
		setButtonStyle(true);
		
		if(type.id === 1) {
			PWtr.classList.remove('d-none');
			cPW.classList.remove('d-none');
			deleteA.classList.remove('d-none');
	    }
	        
	    this.classList.add('d-none');
	    cancle.classList.remove('d-none');
	    save.classList.remove('d-none');
	});
	
	function resetEdit() {
		PWtr.classList.add('d-none');
                    cPW.classList.add('d-none');
                    deleteA.classList.add('d-none');
                    cancle.classList.add('d-none');
                    save.classList.add('d-none');
					document.getElementById('editProfile').classList.remove('d-none');
                    const inputs = document.querySelectorAll('#info input');
                    inputs.forEach(input => input.disabled = true);
                    setButtonStyle();
                    msg="";
                    document.getElementById('telmsg').textContent = msg;
                    document.getElementById('mailmsg').textContent = msg;
	}
	
	let dccon;
	button1.addEventListener('click', function() {
		let disconnect;
		let url='';
		if (type.kakao === 1) {
			disconnect = confirm('Kakao 연동을 해제하시겠습니까?');
        	url='/user/disconnectKakao';
        } else if (type.naver === 1) {
        	disconnect = confirm('Naver 연동을 해제하시겠습니까?');
        	url='/user/disconnectNaver';
        }
        
        if(disconnect) {
        	if((type.id !== 1 && type.naver !== 1) || (type.id !== 1 && type.kakao !== 1)) {
        		dccon = confirm('가입된 계정이 유일할 경우 약관에 동의 하셔야 합니다.');
        		if(dccon) {
        		disconnect = false;
        		deleteA.click();
        		} else {
        			return;
        		}
        	} else {
        		fetch(url, {
		    	method: 'GET'
		    })	
	    	.then(response => response.text())
	        .then(data => {
	        	if(data){
	            	console.log(data);
	            	if(data === '1') {
		            	alert('카카오 연동이 해제 되었습니다.');
		            	delete type.kakao;
		            	if(type.naver === 1) {
		                	button2.classList.add('d-none');
		                	resetButton();
		                	setButtonStyle(true);
		                } else {
		                	sns.classList.add('d-none');
		                }
		            } else if (data === '2') {
		                alert('네이버 연동이 해제되었습니다.');
		                delete type.naver;
		                sns.classList.add('d-none');
		            }
	            } else {
	            	alert('연동 해제 중 오류가 발생했습니다.\n고객센터로 문의주세요.');
	            }
			})
	        .catch(error => {
	        	alert('연동 해제 중 오류가 발생했습니다.');
	            console.error('Error:', error);
	         });
        	}
        }
   	});
   	
   	button2.addEventListener('click', function() {
		let disconnect;
		
		disconnect = confirm('Naver 연동을 해제하시겠습니까?');
        	url='/user/disconnectNaver';
        	
        if(disconnect) {
			fetch('/user/disconnectNaver', {
	        	method: 'GET'
	        	})	
	        	.then(response => response.text())
	            .then(data => {
	            	if(data) {
		            	if (data === '2') {
		            		alert('네이버 연동이 해제되었습니다.');
		                	delete type.naver;
		                	if(type.kakao === 1) {
		                		button2.classList.add('d-none');
		                	} else {
		                		sns.classList.add('d-none');
		                	}
		                }
	                } else {
	                    alert('연동 해제 중 오류가 발생했습니다.\n고객센터로 문의주세요.');
	                }
	            })
	            .catch(error => {
	                alert('연동 해제 중 오류가 발생했습니다.');
	                console.error('Error:', error);
	         });
   		}
   	});
   	
   	let cehckPhone = true;
	let msg = '';
	const oldTel = tel.value;
	tel.addEventListener('input', function() {
	    const teltype = /^01([0|1|6|7|8|9])([0-9]{3,4})([0-9]{4})$/;
	    if (this.value === '' || this.value === oldTel) {
	        msg = '';
	        cehckPhone = (this.value === oldTel);
	    } else if (!teltype.test(this.value)) {
	        msg = '잘못된 핸드폰 번호 입니다.';
	        document.getElementById('telmsg').style.color = 'red';
	        cehckPhone = false;
	    } else {
	    	msg = '등록가능한 핸드폰 번호 입니다.';
	    	document.getElementById('telmsg').style.color = 'green';
			cehckPhone = true;
    	}
    	document.getElementById('telmsg').textContent = msg;
	});

	let checkEmail = true;
	const oldEmail = email.value;
	email.addEventListener('input', function() {
	    const emailtype = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*$/
	    if (this.value === '' || this.value === oldEmail) {
	        msg = '';
	        checkEmail = (this.value === oldEmail);
	    } else if (!emailtype.test(this.value)) {
	        msg = '잘못된 이메일 형식입니다.';
	        document.getElementById('mailmsg').style.color = 'red';
	        checkEmail=false;
	    } else {
	        const formData = new FormData();
	        formData.append('uemail', this.value);
	
	        fetch('/user/join/getMail', {
	            method: 'POST',
	            body: formData
	        })
	        .then(response => response.text())
	        .then(data => {
	            if (data === 'yes') {
	                msg = '이미 등록된 이메일입니다.';
	                document.getElementById('mailmsg').style.color = 'red';
	                checkEmail=false;
	            } else if (data === 'no') {
	                msg = '등록 가능한 이메일입니다.';
	                document.getElementById('mailmsg').style.color = 'green';
	                checkEmail = true;
	            } else {
	                msg = '이메일 확인 중 오류가 발생했습니다.\n관리자에게 문의하십시오.';
	                document.getElementById('mailmsg').style.color = 'red';
	                checkEmail=false;
	            }
	            document.getElementById('mailmsg').textContent = msg;
	        })
	        .catch(error => {
	            alert('이메일 확인 중 오류가 발생했습니다.\n관리자에게 문의하십시오.');
	            console.error('Error:', error);
	            document.getElementById('mailmsg').textContent = '서버와 통신 중 오류가 발생했습니다.';
	            document.getElementById('mailmsg').style.color = 'red';
	            checkEmail=false;
	        });
    	}
    	document.getElementById('mailmsg').textContent = msg;
	});

	const oldPost = document.getElementById('sample4_postcode').value;
	const oldRoad = document.getElementById('sample4_roadAddress').value;
	const oldDetail = document.getElementById('sample4_detailAddress').value;
	cancle.addEventListener('click', function() {
		document.getElementById('sample4_postcode').value = oldPost;
		document.getElementById('sample4_roadAddress').value = oldRoad;
		document.getElementById('sample4_detailAddress').value = oldDetail;
		tel.value = oldTel;
		email.value = oldEmail;
		resetEdit();
	});

	save.addEventListener('click', function() {
        if (!cehckPhone) {
        	alert('잘못된 휴대폰 번호입니다.');
            tel.focus();
            return;
        }

        if (!checkEmail) {
        	alert('이메일을 확인해주세요.');
            email.focus();
            return;
        }
        const formData = new FormData();
        formData.append('uid', window.id);
        formData.append('utel', tel.value);
        formData.append('uemail', email.value);
        formData.append('zcode', document.querySelector('input[name="zcode"]').value);
        formData.append('addr', document.querySelector('input[name="addr"]').value);
        formData.append('addr2', document.querySelector('input[name="addr2"]').value);
        
		fetch('/user/myInfo', {
        	method: 'POST',
            body: formData
        	})	
        	.then(response => response.text())
            .then(data => {
                if (data === '1') {
                    alert('수정되었습니다.');
                    resetEdit();
                } else {
                    alert('저장 중 오류가 발생했습니다.');
                }
            })
            .catch(error => {
                alert('저장 중 오류가 발생했습니다.');
                console.error('Error:', error);
         });
   	});
 
   cPW.addEventListener('click', function() {
		if (pwWindow && !pwWindow.closed) {
        	pwWindow.focus();
        } else {
        	pwWindow = window.open('/user/changepw', '', `width=500, height=500, left=${(window.innerWidth - 500) / 2}, top=${(window.innerHeight - 500) / 2}`);
        }
   	});
 
	deleteA.addEventListener('click', function() {
		if (deleteWindow && !deleteWindow.closed) {
            deleteWindow.focus();
        } else {
        	deleteWindow = window.open('/user/delete', '탈퇴', `width=790, height=600, left=${(window.innerWidth - 790) / 2}, top=${(window.innerHeight - 600) / 2}`);
        }
        
        deleteWindow.addEventListener('load', function() {
    		deleteWindow.postMessage(dccon, '*');
		});
    });    
});

//본 예제에서는 도로명 주소 표기 방식에 대한 법령에 따라, 내려오는 데이터를 조합하여 올바른 주소를 구성하는 방법을 설명합니다.
function sample4_execDaumPostcode() {
	new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 도로명 주소의 노출 규칙에 따라 주소를 표시한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var roadAddr = data.roadAddress; // 도로명 주소 변수
                var extraRoadAddr = ''; // 참고 항목 변수

                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraRoadAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if(data.buildingName !== '' && data.apartment === 'Y'){
                   extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if(extraRoadAddr !== ''){
                    extraRoadAddr = ' (' + extraRoadAddr + ')';
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('sample4_postcode').value = data.zonecode;
                document.getElementById("sample4_roadAddress").value = roadAddr;
                document.getElementById("sample4_jibunAddress").value = data.jibunAddress;
                document.querySelector('input[name="addr2"]').value = '';
                
                // 참고항목 문자열이 있을 경우 해당 필드에 넣는다.
                if(roadAddr !== ''){
                    document.getElementById("sample4_extraAddress").value = extraRoadAddr;
                } else {
                    document.getElementById("sample4_extraAddress").value = '';
                }

                var guideTextBox = document.getElementById("guide");
                // 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
                if(data.autoRoadAddress) {
                    var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
                    guideTextBox.innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';
                    guideTextBox.style.display = 'block';

                } else if(data.autoJibunAddress) {
                    var expJibunAddr = data.autoJibunAddress;
                    guideTextBox.innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';
                    guideTextBox.style.display = 'block';
                } else {
                    guideTextBox.innerHTML = '';
                    guideTextBox.style.display = 'none';
                }
            }
        }).open();
    }
    

