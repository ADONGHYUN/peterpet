package kr.co.peterpet.pay.impl;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.peterpet.pay.PayBean;

@Repository
public class PayDAO {
	@Autowired 
	private SqlSessionTemplate sqlSessionTemplate;
	
	public List<PayBean> getPayList(PayBean pay) {
		System.out.println("===> Mybatis로 getPayList() 기능 처리");
		return sqlSessionTemplate.selectList("payDAO.getPayList", pay);
	}
	
	public int insertPay(PayBean pay) {
		System.out.println("===> Mybatis로 insertPay() 기능 처리");
		return sqlSessionTemplate.insert("payDAO.insertPay", pay);
	}
	
	public int insertPayProd(PayBean pay) {
		System.out.println("===> Mybatis로 insertPayProd() 기능 처리");
		return sqlSessionTemplate.insert("payDAO.insertPayProd", pay);
	}
	
	public int findAmount(String paymentId) {
		System.out.println("===> Mybatis로 findAmount() 기능 처리");
		return sqlSessionTemplate.selectOne("payDAO.findAmount", paymentId);
	}
	
	public List<PayBean> getMypayList(String uid) {
		System.out.println("===> Mybatis로 getMypayList() 기능 처리");
		return sqlSessionTemplate.selectList("payDAO.getMypayList", uid);
	}
	
	public int updatePayStatus(PayBean pay) {
		System.out.println("===> Mybatis로 updatePayStatus() 기능 처리");
		return sqlSessionTemplate.update("payDAO.updatePayStatus", pay);
	}
	
	public List<PayBean> getPayDetail(String paymentId){
		System.out.println("===> Mybatis로 getPayDetail() 기능 처리");
		return sqlSessionTemplate.selectList("payDAO.getPayDetail", paymentId);
	}

	public List<PayBean> getAdPayList(PayBean pay) {
		System.out.println("===> Mybatis로 getAdPayList() 기능 처리");
		return sqlSessionTemplate.selectList("payDAO.getAdPayList", pay);
	}
	
	public int getListCount() {
		System.out.println("===> Mybatis로 getListCount() 기능 처리");
		return sqlSessionTemplate.selectOne("payDAO.getListCount");
	}
	public int deleteByPaymentId(String paymentId) {
		System.out.println("===> Mybatis로 deleteByPaymentId() 기능 처리");
		return sqlSessionTemplate.delete("payDAO.deleteByPaymentId", paymentId);
	}
	public List<PayBean> getBestProdList() {
		System.out.println("===> Mybatis로 getBestProdList() 기능 처리");
		return sqlSessionTemplate.selectList("payDAO.bestProdList");
	}
}


