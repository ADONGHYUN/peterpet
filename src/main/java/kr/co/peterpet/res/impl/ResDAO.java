package kr.co.peterpet.res.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.peterpet.res.ResBean;

@Repository
public class ResDAO {
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	public ResBean getSelectInfo(ResBean res) {
		System.out.println("===> Mybatis로 getSelectInfo() 기능 처리");
		return sqlSessionTemplate.selectOne("resDAO.getSelectInfo", res);
	}

	public int insertResProd(ResBean res) {
		System.out.println("===> Mybatis로 insertResProd() 기능 처리");
		return sqlSessionTemplate.insert("resDAO.insertResProd", res);
	}

	public int reservePackage(ResBean resBean) {
		return sqlSessionTemplate.insert("resDAO.reservePackage", resBean);
	}

	public void updatePack(ResBean res) {
		sqlSessionTemplate.update("resDAO.updatePack", res);
	}

	public int updateRes(ResBean res) {
		System.out.println("===> Mybatis로 updateRes() 기능 처리");
		return sqlSessionTemplate.update("resDAO.updateRes", res);
	}

	public ResBean getExist(ResBean res) {
		System.out.println("===> Mybatis로 getExist() 기능 처리");
		return sqlSessionTemplate.selectOne("resDAO.getExist", res);
	}

	public ResBean getMyRes(int rnum) {
		return sqlSessionTemplate.selectOne("resDAO.getMyRes", rnum);
	}

	public int getReserveCount(String uid, String searchText) {
		Map<String, Object> params = new HashMap<>();
		params.put("uid", uid);
		params.put("searchText", searchText);
		Integer reserveCount = sqlSessionTemplate.selectOne("resDAO.getReserveCount", params);
		return reserveCount != null ? reserveCount : 0;
	}

	public List<ResBean> getResList(ResBean res, String searchText, int num) {
		System.out.println("===> Mybatis로 getResList() 기능 처리");
		Map<String, Object> params = new HashMap<>();
		params.put("res", res);
		params.put("searchText", searchText);
		params.put("num", num);
		return sqlSessionTemplate.selectList("resDAO.getResList", params);
	}

	public List<ResBean> getResList1(ResBean res) {
		System.out.println("===> Mybatis로 getResList() 기능 처리");
		return sqlSessionTemplate.selectList("resDAO.getResList1", res);
	}

	// admin

	public void insertResPack(ResBean res) {
		System.out.println("===> Mybatis로 insertResPack() 기능 처리");
		sqlSessionTemplate.insert("resDAO.insertResPack", res);
	}

	public void updateAdRes(ResBean res) {
		System.out.println("===> Mybatis로 updateAdRes() 기능 처리");
		sqlSessionTemplate.update("resDAO.updateAdRes", res);
	}

//	public int deleteProd(String pcode) {
//		System.out.println("===> Mybatis로 deleteProd() 기능 처리");
//		return sqlSessionTemplate.delete("prodDAO.deleteProd", pcode);
//	}

	public int deleteRes(int rnum) {
		System.out.println("===> Mybatis로 deleteRes() 기능 처리");
		return sqlSessionTemplate.delete("resDAO.deleteRes", rnum);
	}

	public ResBean getRes(ResBean res) {
		System.out.println("===> Mybatis로 getRes() 기능 처리");
		return (ResBean) sqlSessionTemplate.selectOne("resDAO.getRes", res);
	}

	public List<ResBean> getAdResList(ResBean res) {
		System.out.println("===> Mybatis로 getAdResList() 기능 처리");
		return sqlSessionTemplate.selectList("resDAO.getAdResList", res);
	}

	public List<ResBean> getResList(ResBean res) {
		System.out.println("===> Mybatis로 getResList() 기능 처리");
		return sqlSessionTemplate.selectList("resDAO.getResList", res);
	}

	public int delete(String uid) {
		return sqlSessionTemplate.delete("resDAO.delete", uid);
	}

	// pay
	public int deleteResList(List<Integer> rnumList) {
		System.out.println("===> Mybatis로 deleteResList() 기능 처리");

		int totalDeleted = 0;

		for (Integer rnum : rnumList) {
			int result = sqlSessionTemplate.delete("ResDAO.deleteRes", rnum);
			totalDeleted += result;
		}

		return totalDeleted;
	}

}
