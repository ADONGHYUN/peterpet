document.addEventListener('DOMContentLoaded', function() {
    const login = document.getElementById('login');
    document.getElementById('uid').addEventListener('keydown', handleKeyPress);
    document.getElementById('upw').addEventListener('keydown', handleKeyPress);
    function handleKeyPress(event) {
        if (event.key === 'Enter') {
            event.preventDefault();
            login.click(); // login버튼을 클릭했다는 처리
        }
    }
	
    if (login) {
        login.addEventListener('click', function() {
            const uid = document.getElementById('uid').value.trim();
            const upw = document.getElementById('upw').value.trim();

            if (uid === "") {
                alert("아이디를 입력해주세요.");
                document.getElementById('uid').focus();
                return;
            } else if (upw === "") {
                alert("비밀번호를 입력해주세요.");
                document.getElementById('upw').focus();
                return;
            }

            const formData = new FormData(document.getElementById('loginForm'));

            fetch('/login', {
                method: 'POST',
                body: formData
            })
            .then(response => response.text())
            .then(result => {
                if(result === '0') {
                    alert('아이디 또는 비밀번호가 일치하지 않습니다.');
                } else {
                	window.location.replace(result);
                }
            })
            .catch(error => {
                alert('로그인 중 오류가 발생했습니다.');
                console.error('Error:', error);
            });
        });
    }
    
    if (document.getElementById('kakao')) {
    	let kakaoWindow = null;
        kakao.addEventListener('click', function() {
            fetch('/kakaoapi', { method: 'POST' })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('서버 응답 에러: ' + response.status);
                    }
                    return response.text();
                })
                .then(url => {
                    if (!url) {
                        throw new Error('URL 정보가 없습니다.');
                    }

                    const width = 771;
                    const height = 710;
                    const screenWidth = window.innerWidth;
                    const screenHeight = window.innerHeight;
                    const left = (screenWidth - width) / 2;
                    const top = (screenHeight - height) / 2;

                    if (kakaoWindow && !kakaoWindow.closed) {
                        kakaoWindow.focus();
                        kakaoWindow.location.href = url;
                    } else {
                        kakaoWindow = window.open(url, '_blank', `width=${width},height=${height},left=${left},top=${top}`);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                });
        });
    }
    
	// Naver 로그인
	if (document.getElementById('naver')) {
    	let naverWindow = null;
        naver.addEventListener('click', function() {
        console.log("123");
            fetch('/naverapi', { method: 'POST' })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('서버 응답 에러: ' + response.status);
                    }
                    return response.text();
                })
                .then(url => {
                    if (!url) {
                        throw new Error('URL 정보가 없습니다.');
                    }

                    const width = 771;
                    const height = 710;
                    const screenWidth = window.innerWidth;
                    const screenHeight = window.innerHeight;
                    const left = (screenWidth - width) / 2;
                    const top = (screenHeight - height) / 2;

                    if (naverWindow && !naverWindow.closed) {
                        naverWindow.focus();
                        naverWindow.location.href = url;
                    } else {
                        naverWindow = window.open(url, '_blank', `width=${width},height=${height},left=${left},top=${top}`);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                });
        });
    }
});