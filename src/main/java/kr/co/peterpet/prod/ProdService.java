package kr.co.peterpet.prod;

import java.util.List;

public interface ProdService {
	ProdBean getProd(ProdBean prod);
	List<ProdBean> getProdList(ProdBean prod);
	List<ProdBean> getListAjax(ProdBean prod);
	
	// admin
	List<ProdBean> getAdProdList(ProdBean prod);
	void insertProd(ProdBean prod);
	void updateProd(ProdBean prod);
	int deleteProd(String pcode);
	String getPcode(String ptype);
	int checkPcode(String pcode);
	int getListCount(ProdBean prod);
	ProdChartBean getChart();
	ProdChartBean getPtype();
	
	// reserve admin
	List<ProdBean> getProdListbyPtype(ProdBean prod);
}
