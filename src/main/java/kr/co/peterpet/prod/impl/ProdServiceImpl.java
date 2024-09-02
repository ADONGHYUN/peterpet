package kr.co.peterpet.prod.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.peterpet.prod.ProdBean;
import kr.co.peterpet.prod.ProdChartBean;
import kr.co.peterpet.prod.ProdService;

@Service("prodService")
public class ProdServiceImpl implements ProdService{
	@Autowired
	private ProdDAO prodDAO;

	public ProdBean getProd(ProdBean prod) {
		return prodDAO.getProd(prod);
	}
	
	public List<ProdBean> getProdList(ProdBean prod) {
		return prodDAO.getProdList(prod);
	}
	
	public List<ProdBean> getListAjax(ProdBean prod) {
		return prodDAO.getListAjax(prod);
	}
	
	
	// admin
	
	@Override
	public ProdChartBean getChart() {
		return prodDAO.getChart();
	}

	@Override
	public ProdChartBean getPtype() {
		return prodDAO.getPtype();
	}
	
	@Override
	public List<ProdBean> getAdProdList(ProdBean prod) {
		return prodDAO.getAdProdList(prod);
	}
	public void insertProd(ProdBean prod) {
		prodDAO.insertProd(prod);
	}
	
	public void updateProd(ProdBean prod) {
		prodDAO.updateProd(prod);
	}

	public int deleteProd(String pcode) {
		return prodDAO.deleteProd(pcode);
	}
	@Override
	public String getPcode(String ptype) {
		return prodDAO.getPcode(ptype);
	}

	@Override
	public int checkPcode(String pcode) {
		return prodDAO.checkPcode(pcode);
	}

	@Override
	public int getListCount(ProdBean prod) {
		return prodDAO.getListCount(prod);
	}
	
	// reserve admin
	public List<ProdBean> getProdListbyPtype(ProdBean prod) {
		return prodDAO.getProdListbyPtype(prod);
	}
	
}
