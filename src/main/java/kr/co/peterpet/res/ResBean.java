package kr.co.peterpet.res;

import java.sql.Date;
import java.util.List;

public class ResBean {
	private int rnum;
	private String uid;
	private String uname;
	private String utel;
	private String addr;
	private String addr2;
	private String zcode;
	private String pcode;
	private String pname;
	private String pimg1;
	private int pprice;
	private String ptype;
	private String rsday;
	private String rperiod;
	private int rcount;
	private String rdinfo;
	private int rtotal;
	private Date reday;
	private Date rdate;
	private String searchText;
	private int offset;
	private List<Integer> rnumList;
	
	public int getRnum() {
		return rnum;
	}
	public void setRnum(int rnum) {
		this.rnum = rnum;
	}
	public String getUid() {
		return uid;
	}
	public void setUid(String uid) {
		this.uid = uid;
	}
	public String getPcode() {
		return pcode;
	}
	public void setPcode(String pcode) {
		this.pcode = pcode;
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
	public String getAddr2() {
		return addr2;
	}
	public void setAddr2(String addr2) {
		this.addr2 = addr2;
	}
	public String getZcode() {
		return zcode;
	}
	public void setZcode(String zcode) {
		this.zcode = zcode;
	}
	public String getPname() {
		return pname;
	}
	public void setPname(String pname) {
		this.pname = pname;
	}
	public String getPtype() {
		return ptype;
	}
	public void setPtype(String ptype) {
		this.ptype = ptype;
	}
	public int getPprice() {
		return pprice;
	}
	public void setPprice(int pprice) {
		this.pprice = pprice;
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
	public int getRcount() {
		return rcount;
	}
	public void setRcount(int rcount) {
		this.rcount = rcount;
	}
	public String getRdinfo() {
		return rdinfo;
	}
	public void setRdinfo(String rdinfo) {
		this.rdinfo = rdinfo;
	}
	public int getRtotal() {
		return rtotal;
	}
	public void setRtotal(int rtotal) {
		this.rtotal = rtotal;
	}
	public Date getReday() {
		return reday;
	}
	public void setReday(Date reday) {
		this.reday = reday;
	}
	public Date getRdate() {
		return rdate;
	}
	public void setRdate(Date rdate) {
		this.rdate = rdate;
	}
	public String getPimg1() {
		return pimg1;
	}
	public void setPimg1(String pimg1) {
		this.pimg1 = pimg1;
	}
	public String getSearchText() {
		return searchText;
	}
	public void setSearchText(String searchText) {
		this.searchText = searchText;
	}
	public int getOffset() {
		return offset;
	}
	public void setOffset(int offset) {
		this.offset = offset;
	}
	public List<Integer> getRnumList() {
		return rnumList;
	}
	public void setRnumList(List<Integer> rnumList) {
		this.rnumList = rnumList;
	}
	
	
	public void merge(ResBean other) {
        if (other == null) return;

        // 기존 데이터는 유지하고, 다른 객체의 데이터로 업데이트
        if (other.getRsday() != null) {
            this.rsday = other.getRsday();
        }
        if (other.getRcount() > 0) {
            this.rcount = other.getRcount();
        }
        if (other.getRdinfo() != null) {
            this.rdinfo = other.getRdinfo();
        }
        if (other.getRperiod() != null) {
            this.rperiod = other.getRperiod();
        }
        if (other.getRnum() > 0) {
            this.rnum = other.getRnum();
        }
        if (other.getRtotal() > 0) {
            this.rtotal = other.getRtotal();
        }
	}
	@Override
	public String toString() {
		return "ResBean [rnum=" + rnum + ", rcount=" + rcount + ", uid=" + uid + ", pcode=" + pcode + ", uname=" + uname
				+ ", utel=" + utel + ", addr=" + addr + ", addr2=" + addr2 + ", zcode=" + zcode + ", pname=" + pname
				+ ", ptype=" + ptype + ", pimg1=" + pimg1 + ", pprice=" + pprice + ", rsday=" + rsday + ", rperiod="
				+ rperiod + ", rdinfo=" + rdinfo + ", rtotal=" + rtotal + ", reday=" + reday + ", rdate=" + rdate
				+ ", searchText=" + searchText + ", offset=" + offset + "]";
	}
}
