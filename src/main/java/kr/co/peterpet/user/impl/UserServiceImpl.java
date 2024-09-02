package kr.co.peterpet.user.impl;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;

import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.peterpet.user.UserBean;
import kr.co.peterpet.user.UserService;

@Service
public class UserServiceImpl implements UserService {
	@Autowired
	private UserDAO userDAO;
	@Autowired
	private SendMail sendMail;
	@Autowired
	KakaoAPI kakaoAPI;
	@Autowired
	NaverAPI naverAPI;
	@Autowired
	State state;

	@Override
	public int insertUser(UserBean user) {
		user.setUpw(hashPW(user.getUpw()));
		return userDAO.insertUser(user);
	}
	
	@Override
	public String getSameMail(String uemail) {
		List<UserBean> mails = userDAO.getSameMail(uemail);
		if (mails.isEmpty()) {
			return null;
		}
		return "yes";
	}

	@Override
	public String getMail(String uemail) throws Exception {

		List<UserBean> oldUsers = userDAO.getSameMail(uemail);
		UserBean user = new UserBean();//메일 보낼 때 쓸 빈
		if (oldUsers.isEmpty()) {
			return "no";
		}
		user.setUemail(uemail);
		
		//리스트 내용물을 담는 빈
		UserBean useris = new UserBean();
		
		for (UserBean oldUser : oldUsers) {
			if (oldUser.getUid().length()<=12) {//아이디 값이 12자리 이하면 소셜회원이 아니니 담음
				useris = oldUser;
			}
		}
		
		System.out.println(useris);
		if(useris.getUid() == null) {//소셜계정만 있는 경우
			return "api";
		}

		user = sendMail.sendMail(user);

		int codeConfirm = -1;

		if (user != null) {
			System.out.println(user.getExdate());
			codeConfirm = userDAO.updateMailCode(user);
		} else {
			return "mfail";
		}

		System.out.println(codeConfirm);

		if (codeConfirm > 0) {
			return "yes";
		} else {
			return "yesb";
		}
	}

	@Override
	public String getMailCode(UserBean user) {
		UserBean result = userDAO.getMailCode(user);
		if (result == null) {
			return "un";
		}

		String icode = user.getMailcode().trim();
		String rcode = result.getMailcode().trim();

		System.out.println(icode);
		System.out.println(rcode);

		if (rcode.equals(icode)) {
			return "yes";
		}
		return "no";
	}

	@Override
	public UserBean getFindId(String uemail) {
		UserBean user = new UserBean();
		user.setUemail(uemail);
		user.setMailcode("000000");
		userDAO.updateMailCode(user);//인증완료 코드 초기화
		List<UserBean> users = userDAO.getSameMail(uemail);//이메일이 동일한 계정들 불러오기
		
		for (UserBean userr : users) {
			if (userr.getUid().length()<=12) {// 아이디가 12자리 이하면 일반회원
				user=userr;//일반회원정보 담기
			}
		}
		return user;//고객에게 보여줄 일반회원 정보
	}

	@Override
	public String getFid(String uid, String uemail) throws Exception {

		UserBean user = userDAO.getUser(uid);
		System.out.println(user);
		if (user == null) {
			return "no";
		} else if (!user.getUemail().equals(uemail)) {
			System.out.println(user.getUemail());
			System.out.println(uemail);
			return "nmail";
		}
		System.out.println(user);
		int codeConfirm = -1;
		user = sendMail.sendMail(user);

		if (user != null) {
			codeConfirm = userDAO.updateMailCodeId(user);
		} else {
			return "mfail";
		}

		System.out.println(codeConfirm);

		if (codeConfirm > 0) {
			return "yes";
		} else {
			return "yesb";
		}
	}

	@Override
	public String getMailCodePw(UserBean user) {
		UserBean result = userDAO.getMailCodePw(user);

		if (result == null) {
			return "un";
		}

		String icode = user.getMailcode().trim();
		String rcode = result.getMailcode().trim();

		System.out.println(icode);
		System.out.println(rcode);

		if (rcode.equals(icode)) {
			return "yes";
		}
		return "no";
	}

	@Override
	public String getFindPw(String uid) {
		UserBean user = new UserBean();
		user.setUid(uid);
		user.setMailcode("000000");
		int codeConfirm = userDAO.updateMailCodeId(user);
		if(codeConfirm>0) {
			return "yes";
		}
		return "no";
	}
	
	@Override
	public String pwChange(UserBean user) {
		user.setUpw(hashPW(user.getUpw()));
		int confirm = userDAO.pwChange(user);
		if(confirm>0) {
			return "yes";
		}
		return "no";
	}
	
	// kakao url 가져오기
	@Override
	public String getKaUrl() {
		return "https://kauth.kakao.com/oauth/authorize?client_id="
				+ URLEncoder.encode(kakaoAPI.getKey(), StandardCharsets.UTF_8) + "&redirect_uri="
				+ URLEncoder.encode(kakaoAPI.getLoginURI(), StandardCharsets.UTF_8) + "&response_type=code&state=";
	}
	
	// naver url 가져오기
	@Override
	public String getNaUrl() {
		return "https://nid.naver.com/oauth2.0/authorize?response_type=code&client_id="
				+ URLEncoder.encode(naverAPI.getClient_id(), StandardCharsets.UTF_8) + "&redirect_uri="
				+ URLEncoder.encode(naverAPI.getLoginURI(), StandardCharsets.UTF_8) + "&state=";
	}
	
	// id만 가져오기
	@Override
	public boolean getID(String userID) {
		return userDAO.getID(userID)==null ? false : true;
	}
	
	// 카카오 회원 검증
	@Override  
	public String kaVerify(String code) {
		UserBean userBean = new UserBean();
		userBean = kakaoAPI.getProfile(userBean, kakaoAPI.getAccessToken(code, userBean));
		if (userBean.getAddr() == null) {
			userBean.setAddr(" , ");
		}
		UserBean userInfo = userDAO.getUser(userBean.getKapi());
		if (userInfo == null) {
			String id = userDAO.searchAPI(userBean);
			if (id == null) {
				while(true) {
					id = sendMail.getRId();
					if(userDAO.getID(id) == null) {
						userBean.setUid(sendMail.getRId());
						userBean.setUpw("0000");
						userDAO.insertUser(userBean);
						return userBean.getUid();
					}
				}
			} else {
				userBean.setUid(id);
			}
		} else {
			userBean.setUid(userInfo.getUid());
		}
		userDAO.setKAPI(userBean);
		return userBean.getUid();
	}
	
	// 네이버 회원 검증
	@Override
	public String naVerify(String code) {
		UserBean userBean = new UserBean();
		naverAPI.getProfile(userBean, naverAPI.getAccessToken(code, userBean));
		UserBean userInfo = userDAO.getUser(userBean.getNapi());
		if(userInfo==null) { // 신규
			String id = userDAO.searchAPI(userBean);
			if(id==null) {
				while(true) {
					id = sendMail.getRId();
					if(userDAO.getID(id) == null) {
						userBean.setUid(sendMail.getRId());
						userBean.setUpw("0000");
						userDAO.insertUser(userBean);
						return userBean.getUid();
					}
				}
			} else {
				userBean.setUid(id);
			}
		} else {
			userBean.setUid(userInfo.getUid());
		}
		userDAO.setNAPI(userBean);
		return userBean.getUid();
	}
	
	// 로그인시 id로 pw가져와서 pw 검증
	@Override
	public boolean verify(UserBean userBean) {
		if(userBean.getUid().equals("admin") || userBean.getUpw().equals("0000")) {
			return userBean.getUpw().equals(userDAO.getPW(userBean.getUid())) ? true : false;
		} else {
			return checkPW(userBean.getUpw(), userDAO.getPW(userBean.getUid()));
		}
	}
	
	// id로 유저 정보 가져옴
	@Override
	public UserBean getUser(String userId) {
		UserBean userBean = userDAO.getUser(userId);
		if(userBean != null) {
			String[] addr = userBean.getAddr().split(",", 2);
			userBean.setAddr(addr[0]);
			userBean.setAddr2(addr[1]);
		}
		return userBean;
	}

	// 정보 수정
	@Override
	public int update(UserBean userBean) {
		return userDAO.update(userBean);
	}
	
	// 비밀번호 수정
	@Override
	public int pwUpdate(UserBean userBean) {
		if(verify(userBean)) {
			userBean.setNpw(hashPW(userBean.getNpw()));
			return userDAO.pwUpdate(userBean);
		} else {
			return 0;
		}
	}

	// 카카오 연동 해제
	@Override
	public int dconKka(String userId) {
		UserBean userBean = userDAO.getUser(userId);
		if(kakaoAPI.dcconKa(userBean.getKRToken())) {
			userBean.setKapi(null);
			userBean.setKRToken(null);
			userDAO.setKAPI(userBean);
			return 1;
		} 
		return 4;
	}
	
	// naver 연동 해제
	@Override
	public int dconNa(String userId) {
		UserBean userBean = userDAO.getUser(userId);
		if(naverAPI.dcconNa(userBean.getNRToken())) {
			userBean.setNapi(null);
			userBean.setNRToken(null);
			userDAO.setNAPI(userBean);
			return 2;	
		}
		return 4;
	}
	
	// 회원탈퇴
	@Override
	public int delete(String userId) {
		UserBean userBean = userDAO.getUser(userId);
		if(userBean.getKapi()!=null) {
			kakaoAPI.dcconKa(userBean.getKRToken());
		}
		if(userBean.getNapi()!=null) {
			naverAPI.dcconNa(userBean.getNRToken());
		}
		return userDAO.delete(userId);
	}
	
	// 관리자
	@Override
	public int getmail(String email) {
		return userDAO.getmail(email);
	}
	
	@Override
	public int getUserCount(UserBean vo) {
		return userDAO.getUserCount(vo);
	}
	
	
	
	@Override
	 public List<Map<String, Object>> getChart1(UserBean vo) {
       return userDAO.getChart1(vo);
   }
	
	 public List<Map<String, Object>> getChart2(UserBean vo) {
	       return userDAO.getChart2(vo);
	   }
	
	@Override
	public void adInsert(UserBean vo) {
		userDAO.adInsert(vo);
	}

	@Override
	public void adUpdate(UserBean vo) {
		userDAO.update(vo);
	}

	@Override
	public int getListCount(UserBean vo) {
		return userDAO.getListCount(vo);
	}

	@Override
	public List<UserBean> getUserList(UserBean vo) {
		return userDAO.getUserList(vo);
	}
	
	
	///////////////////// 따로 만든 함수들
	// 암호화
	public String hashPW(String upw) {
		return BCrypt.hashpw(upw, BCrypt.gensalt());
	}
	
	// 비밀번호 확인
	public boolean checkPW(String upw, String dbpw) {
		if(dbpw == null) {
			return false;
		}
		return BCrypt.checkpw(upw, dbpw);
	}
}
