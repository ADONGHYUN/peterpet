package kr.co.peterpet.prod;

public class ProdChartBean {
	private int count1;
	private int count2;
	private int count3;
	private int ptype1;
	private int ptype2;
	private int ptype3;
	private int ptype4;
	private int ptype5;
	private int ptype6;
	
	public int getPtype1() {
		return ptype1;
	}

	public void setPtype1(int ptype1) {
		this.ptype1 = ptype1;
	}

	public int getPtype2() {
		return ptype2;
	}

	public void setPtype2(int ptype2) {
		this.ptype2 = ptype2;
	}

	public int getPtype3() {
		return ptype3;
	}

	public void setPtype3(int ptype3) {
		this.ptype3 = ptype3;
	}

	public int getPtype4() {
		return ptype4;
	}

	public void setPtype4(int ptype4) {
		this.ptype4 = ptype4;
	}

	public int getPtype5() {
		return ptype5;
	}

	public void setPtype5(int ptype5) {
		this.ptype5 = ptype5;
	}

	public int getPtype6() {
		return ptype6;
	}

	public void setPtype6(int ptype6) {
		this.ptype6 = ptype6;
	}

	public ProdChartBean() {}
	
	 public ProdChartBean(int count1, int count2, int count3) {
	        this.count1 = 100; // 기준값 100으로 설정
	        this.count2 = (int) ((double) count2 / count1 * 100);
	        this.count3 = (int) ((double) count3 / count1 * 100);
	    }
	
	public int getCount1() {
		return count1;
	}
	public void setCount1(int count1) {
		this.count1 = count1;
	}
	public int getCount2() {
		return count2;
	}
	public void setCount2(int count2) {
		this.count2 = count2;
	}
	public int getCount3() {
		return count3;
	}
	public void setCount3(int count3) {
		this.count3 = count3;
	}

}
