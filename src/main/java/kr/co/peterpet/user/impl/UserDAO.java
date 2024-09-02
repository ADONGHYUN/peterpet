package kr.co.peterpet.user.impl;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.peterpet.user.UserBean;

@Repository
public class UserDAO {
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	public int insertUser(UserBean user) {
		System.out.println("UserDAO insert");
		return sqlSessionTemplate.insert("userDAO.insertUser",user);
	}
	
	public List<UserBean> getSameMail(String uemail) {
		return this.sqlSessionTemplate.selectList("userDAO.getSameMail", uemail);
	}
	
	public int updateMailCode(UserBean user) {
		System.out.println("UserDAO updateMailCode");
		return sqlSessionTemplate.update("userDAO.updateMailCode",user);
	}
	
	public UserBean getMailCode(UserBean user) {
		System.out.println("UserDAO getMailCode");
		return sqlSessionTemplate.selectOne("userDAO.getMailCode",user);
	}
	
	public int updateMailCodeId(UserBean user) {
		System.out.println("UserDAO updateMailCodeId");
		return sqlSessionTemplate.update("userDAO.updateMailCodeId",user);
	}
	
	public UserBean getMailCodePw(UserBean user) {
		System.out.println("UserDAO getMailCodePw");
		return sqlSessionTemplate.selectOne("userDAO.getMailCodePw",user);
	}
	
	public int pwChange(UserBean user) {
		System.out.println("UserDAO pwChange");
		return sqlSessionTemplate.update("userDAO.pwChange",user);
	}
	
	public String getID(String userID) {
		return this.sqlSessionTemplate.selectOne("userDAO.getID", userID);
	}
	
	public String searchAPI(UserBean userBean) {
		return this.sqlSessionTemplate.selectOne("userDAO.searchAPI", userBean);
	}
	
	public int setKAPI(UserBean userBean) {
		return this.sqlSessionTemplate.update("userDAO.setKAPI", userBean);
	}
	
	public int setNAPI(UserBean userBean) {
		return this.sqlSessionTemplate.update("userDAO.setNAPI", userBean);
	}
	
	public String getPW(String userID) {
		return this.sqlSessionTemplate.selectOne("userDAO.getPW", userID);
	}
	
	public UserBean getUser(String userId) {
		return this.sqlSessionTemplate.selectOne("userDAO.getUser", userId);
	}
	
	public int update(UserBean userBean) {
		return this.sqlSessionTemplate.update("userDAO.update", userBean);
	}
	
	public int pwUpdate(UserBean userBean) {
		return this.sqlSessionTemplate.update("userDAO.pwUpdate", userBean);
	}
	
	public int delete(String uId) {
		return this.sqlSessionTemplate.delete("userDAO.delete", uId);
	}
	
	// 관리자
	public int getmail(String email) {
		return sqlSessionTemplate.selectOne("userDAO.getmail", email);
	}
	
	public int getUserCount(UserBean vo) {
		return sqlSessionTemplate.selectOne("userDAO.getUserCount",vo);
	}
	
	public  List<Map<String, Object>> getChart1(UserBean vo) {
		return sqlSessionTemplate.selectList("userDAO.getChart1", vo);
	}
	
	
	public  List<Map<String, Object>> getChart2(UserBean vo) {
		return sqlSessionTemplate.selectList("userDAO.getChart2", vo);
	}
	
	
	public void adInsert(UserBean vo) {
		System.out.println("insert");
		sqlSessionTemplate.insert("userDAO.adInsert", vo);
		
	}
	
	public void adUpdate(UserBean vo) {
		System.out.println("update");
		sqlSessionTemplate.update("userDAO.adUpdate", vo);
		
	}
	
	public int getListCount(UserBean vo) {
		System.out.println(vo.getLimit());
		return sqlSessionTemplate.selectOne("userDAO.getListCount",vo);
	}
	
	public List<UserBean> getUserList(UserBean vo) {
		return sqlSessionTemplate.selectList("userDAO.getUserList", vo);
	}	
}

