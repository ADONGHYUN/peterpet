package kr.co.peterpet.pay.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import kr.co.peterpet.pay.PayBean;
import kr.co.peterpet.pay.PayService;
import kr.co.peterpet.res.ResBean;

@Service("payService")
public class PayServiceImpl implements PayService{
	@Autowired
	private PayDAO payDAO;
	
	@Override
	public List<PayBean> getPayList(PayBean pay){
		return payDAO.getPayList(pay);
	}

	@Override
	public int insertPay(PayBean pay) {
		return payDAO.insertPay(pay);
	}

	@Override
	public int insertPayProd(PayBean pay) {
		return payDAO.insertPayProd(pay);
	}

	@Override
	public int findAmount(String paymentId) {
		return payDAO.findAmount(paymentId);
	}
	
	@Override
	public List<PayBean> getMypayList(String uid) {
		return payDAO.getMypayList(uid);
	}

	@Override
	public int updatePayStatus(PayBean pay) {
		return payDAO.updatePayStatus(pay);
	}

	@Override
	public List<PayBean> getPayDetail(String paymentId) {
		return payDAO.getPayDetail(paymentId);
	}
	@Override
	public List<PayBean> getAdPayList(PayBean pay) {
		return payDAO.getAdPayList(pay);
	}
	@Override
	public int getListCount() {
		return payDAO.getListCount();
	}
	@Override
	public int deleteByPaymentId(String paymentId) {
		return payDAO.deleteByPaymentId(paymentId);
	}
	@Override
	public List<PayBean> getBestProdList() {
		return payDAO.getBestProdList();
	}
}
