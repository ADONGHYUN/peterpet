package kr.co.peterpet.prod;

import java.sql.Date;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

public class ProdBean {
	private String pcode;
	private String pname;
	private String pdes;
	private String pimg1;
	private String pimg2;
	private int pprice;
	private String ptype;
	private Date pregdate;
	private MultipartFile uploadFile1;
	private List<MultipartFile> uploadFile2;
	private String arrayprod;
	private String searchCondition;
	private String searchKeyword;
	private int offset;
	//
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
	public String getPdes() {
		return pdes;
	}
	public void setPdes(String pdes) {
		this.pdes = pdes;
	}
	public String getPimg1() {
		return pimg1;
	}
	public void setPimg1(String pimg1) {
		this.pimg1 = pimg1;
	}
	public String getPimg2() {
		return pimg2;
	}
	public void setPimg2(String pimg2) {
		this.pimg2 = pimg2;
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
	public Date getPregdate() {
		return pregdate;
	}
	public void setPregdate(Date pregdate) {
		this.pregdate = pregdate;
	}
	public MultipartFile getUploadFile1() {
		return uploadFile1;
	}
	public void setUploadFile1(MultipartFile uploadFile1) {
		this.uploadFile1 = uploadFile1;
	}
	public List<MultipartFile> getUploadFile2() {
		return uploadFile2;
	}
	public void setUploadFile2(List<MultipartFile> uploadFile2) {
		this.uploadFile2 = uploadFile2;
	}
	public String getArrayprod() {
		return arrayprod;
	}
	public void setArrayprod(String arrayprod) {
		this.arrayprod = arrayprod;
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
	
}
