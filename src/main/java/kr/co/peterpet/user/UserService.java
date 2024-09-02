package kr.co.peterpet.user;

import java.util.List;
import java.util.Map;

public interface UserService {
	public int insertUser(UserBean user);
	public String getSameMail(String uemail);
	public String getMail(String uemail) throws Exception;
	public String getMailCode(UserBean user);
	public UserBean getFindId(String uemail);
	public String getFid(String uid, String uemail) throws Exception;
	public String getMailCodePw(UserBean user);
	String getFindPw(String uid);
	public String pwChange(UserBean user);
	
	public String getKaUrl();
	public String getNaUrl();
	public boolean getID(String userId);
	public String kaVerify(String code);
	public String naVerify(String code);
	public boolean verify(UserBean userBean);
	public UserBean getUser(String userId);
	public int update(UserBean userBean);
	public int pwUpdate(UserBean userBean);
	public int delete(String uId);
	public int dconKka(String kakao);
	public int dconNa(String naver);
	
	
	// Admin
	public int getmail(String email);
	public int getUserCount(UserBean vo);
	public List<Map<String, Object>> getChart1(UserBean vo);
	public List<Map<String, Object>> getChart2(UserBean vo);
	public List<UserBean> getUserList(UserBean vo);
	public int getListCount(UserBean vo);
	public void adInsert(UserBean vo);
	public void adUpdate(UserBean vo);
}
