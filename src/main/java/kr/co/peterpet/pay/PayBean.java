package kr.co.peterpet.pay;

import java.sql.Date;
import java.util.List;

public class PayBean {
	private String paymentId;
	private String orderName;
	private int totalAmount;  //결제 시 총 가격
	private String uid;
	private String uname;
	private String utel;
	private String addr;
	private String zcode;
	private String pcode;
	private String pname;
	private String pimg1;
	private int pprice;
	private String ptype;
	private int rcount;
	private int rtotal; //상품 총 가격
	private String rdinfo;
	private String rsday;
	private String rperiod;
	private String reday;
	private String status;
	private String transactionType;
	private String txId;
	private String code;
	private Date paydate;
	private String delistate;
	private Date cancledate;
	private List<Integer> rnumList;
	private String searchCondition;
	private String searchKeyword;
	private int offset;
	
	public String getPaymentId() {
		return paymentId;
	}
	public void setPaymentId(String paymentId) {
		this.paymentId = paymentId;
	}
	public String getOrderName() {
		return orderName;
	}
	public void setOrderName(String orderName) {
		this.orderName = orderName;
	}
	public int getTotalAmount() {
		return totalAmount;
	}
	public void setTotalAmount(int totalAmount) {
		this.totalAmount = totalAmount;
	}
	public String getUid() {
		return uid;
	}
	public void setUid(String uid) {
		this.uid = uid;
	}
	public String getUname() {
		return uname;
	}
	public void setUname(String uname) {
		this.uname = uname;
	}
	public String getUtel() {
		return utel;
	}
	public void setUtel(String utel) {
		this.utel = utel;
	}
	public String getAddr() {
		return addr;
	}
	public void setAddr(String addr) {
		this.addr = addr;
	}
	public String getZcode() {
		return zcode;
	}
	public void setZcode(String zcode) {
		this.zcode = zcode;
	}
	public String getPcode() {
		return pcode;
	}
	public void setPcode(String pcode) {
		this.pcode = pcode;
	}
	public String getPname() {
		return pname;
	}
	public void setPname(String pname) {
		this.pname = pname;
	}
	public String getPimg1() {
		return pimg1;
	}
	public void setPimg1(String pimg1) {
		this.pimg1 = pimg1;
	}
	public int getPprice() {
		return pprice;
	}
	public void setPprice(int pprice) {
		this.pprice = pprice;
	}
	public String getPtype() {
		return ptype;
	}
	public void setPtype(String ptype) {
		this.ptype = ptype;
	}
	public int getRcount() {
		return rcount;
	}
	public void setRcount(int rcount) {
		this.rcount = rcount;
	}
	public int getRtotal() {
		return rtotal;
	}
	public void setRtotal(int rtotal) {
		this.rtotal = rtotal;
	}
	public String getRdinfo() {
		return rdinfo;
	}
	public void setRdinfo(String rdinfo) {
		this.rdinfo = rdinfo;
	}
	public String getRsday() {
		return rsday;
	}
	public void setRsday(String rsday) {
		this.rsday = rsday;
	}
	public String getRperiod() {
		return rperiod;
	}
	public void setRperiod(String rperiod) {
		this.rperiod = rperiod;
	}
	public String getReday() {
		return reday;
	}
	public void setReday(String reday) {
		this.reday = reday;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getTransactionType() {
		return transactionType;
	}
	public void setTransactionType(String transactionType) {
		this.transactionType = transactionType;
	}
	public String getTxId() {
		return txId;
	}
	public void setTxId(String txId) {
		this.txId = txId;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public Date getPaydate() {
		return paydate;
	}
	public void setPaydate(Date paydate) {
		this.paydate = paydate;
	}
	public String getDelistate() {
		return delistate;
	}
	public void setDelistate(String delistate) {
		this.delistate = delistate;
	}
	public Date getCancledate() {
		return cancledate;
	}
	public void setCancledate(Date cancledate) {
		this.cancledate = cancledate;
	}
	public List<Integer> getRnumList() {
		return rnumList;
	}
	public void setRnumList(List<Integer> rnumList) {
		this.rnumList = rnumList;
	}
	public String getSearchCondition() {
		return searchCondition;
	}
	public void setSearchCondition(String searchCondition) {
		this.searchCondition = searchCondition;
	}
	public String getSearchKeyword() {
		return searchKeyword;
	}
	public void setSearchKeyword(String searchKeyword) {
		this.searchKeyword = searchKeyword;
	}
	public int getOffset() {
		return offset;
	}
	public void setOffset(int offset) {
		this.offset = offset;
	}
	@Override
	public String toString() {
		return "PayBean [paymentId=" + paymentId + ", orderName=" + orderName + ", totalAmount=" + totalAmount
				+ ", uid=" + uid + ", uname=" + uname + ", utel=" + utel + ", addr=" + addr + ", zcode=" + zcode
				+ ", pcode=" + pcode + ", pname=" + pname + ", pimg1=" + pimg1 + ", pprice=" + pprice + ", ptype="
				+ ptype + ", rcount=" + rcount + ", rtotal=" + rtotal + ", rdinfo=" + rdinfo + ", rsday=" + rsday
				+ ", rperiod=" + rperiod + ", reday=" + reday + ", status=" + status + ", transactionType="
				+ transactionType + ", txId=" + txId + ", code=" + code + ", paydate=" + paydate + ", delistate="
				+ delistate + ", cancledate=" + cancledate + "]";
	}
	
}
