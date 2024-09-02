package kr.co.peterpet.user;

import java.sql.Date;
import java.sql.Timestamp;

public class UserBean {
	private String uid;
	private String upw;
	private String uname;
	private String utel;
	private String uemail;
	private String ubirth;
	private String ugender;
	private String addr;
	private String zcode;
	private Date joindate;
	private String mailcode;
	private Timestamp exdate;
	private String kapi;
	private String napi;
	private String KRToken;
	private String NRToken;
	
	private String npw;
	private String addr2;
	
	private String searchCondition;
	private String searchKeyword;
	private int page;
	private int maxPage;
	private int startPage;
	private int endPage;
	private int listCount; // 총 예약 수
	private int limit;
	private int offset;
	public String getUid() {
		return uid;
	}
	public void setUid(String uid) {
		this.uid = uid;
	}
	public String getUpw() {
		return upw;
	}
	public void setUpw(String upw) {
		this.upw = upw;
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
	public String getUemail() {
		return uemail;
	}
	public void setUemail(String uemail) {
		this.uemail = uemail;
	}
	public String getUbirth() {
		return ubirth;
	}
	public void setUbirth(String ubirth) {
		this.ubirth = ubirth;
	}
	public String getUgender() {
		return ugender;
	}
	public void setUgender(String ugender) {
		this.ugender = ugender;
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
	public Date getJoindate() {
		return joindate;
	}
	public void setJoindate(Date joindate) {
		this.joindate = joindate;
	}
	public String getMailcode() {
		return mailcode;
	}
	public void setMailcode(String mailcode) {
		this.mailcode = mailcode;
	}
	public Timestamp getExdate() {
		return exdate;
	}
	public void setExdate(Timestamp exdate) {
		this.exdate = exdate;
	}
	public String getKapi() {
		return kapi;
	}
	public void setKapi(String kapi) {
		this.kapi = kapi;
	}
	public String getNapi() {
		return napi;
	}
	public void setNapi(String napi) {
		this.napi = napi;
	}
	public String getKRToken() {
		return KRToken;
	}
	public void setKRToken(String kRToken) {
		KRToken = kRToken;
	}
	public String getNRToken() {
		return NRToken;
	}
	public void setNRToken(String nRToken) {
		NRToken = nRToken;
	}
	public String getNpw() {
		return npw;
	}
	public void setNpw(String npw) {
		this.npw = npw;
	}
	public String getAddr2() {
		return addr2;
	}
	public void setAddr2(String addr2) {
		this.addr2 = addr2;
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
	public int getPage() {
		return page;
	}
	public void setPage(int page) {
		this.page = page;
	}
	public int getMaxPage() {
		return maxPage;
	}
	public void setMaxPage(int maxPage) {
		this.maxPage = maxPage;
	}
	public int getStartPage() {
		return startPage;
	}
	public void setStartPage(int startPage) {
		this.startPage = startPage;
	}
	public int getEndPage() {
		return endPage;
	}
	public void setEndPage(int endPage) {
		this.endPage = endPage;
	}
	public int getListCount() {
		return listCount;
	}
	public void setListCount(int listCount) {
		this.listCount = listCount;
	}
	public int getLimit() {
		return limit;
	}
	public void setLimit(int limit) {
		this.limit = limit;
	}
	public int getOffset() {
		return offset;
	}
	public void setOffset(int offset) {
		this.offset = offset;
	}
	@Override
	public String toString() {
		return "UserBean [uid=" + uid + ", upw=" + upw + ", uname=" + uname + ", utel=" + utel + ", uemail=" + uemail
				+ ", ubirth=" + ubirth + ", ugender=" + ugender + ", addr=" + addr + ", zcode=" + zcode + ", joindate="
				+ joindate + ", mailcode=" + mailcode + ", exdate=" + exdate + ", kapi=" + kapi + ", napi=" + napi
				+ ", KRToken=" + KRToken + ", NRToken=" + NRToken + ", npw=" + npw + ", addr2=" + addr2
				+ ", searchCondition=" + searchCondition + ", searchKeyword=" + searchKeyword + ", page=" + page
				+ ", maxPage=" + maxPage + ", startPage=" + startPage + ", endPage=" + endPage + ", listCount="
				+ listCount + ", limit=" + limit + ", offset=" + offset + "]";
	}
}
