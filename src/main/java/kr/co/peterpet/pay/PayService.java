package kr.co.peterpet.pay;

import java.util.List;

public interface PayService {
	public List<PayBean> getPayList(PayBean pay);
	public int insertPay(PayBean pay);
	public int insertPayProd(PayBean pay);
	public int findAmount(String paymentId);
	public List<PayBean> getMypayList(String uid);
	public int updatePayStatus(PayBean pay);
	public List<PayBean> getPayDetail(String paymentId);
	public List<PayBean> getAdPayList(PayBean pay);
	public int getListCount();
	public int deleteByPaymentId(String paymentId);
	List<PayBean> getBestProdList();
}
