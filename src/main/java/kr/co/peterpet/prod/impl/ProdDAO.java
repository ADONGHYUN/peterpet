package kr.co.peterpet.prod.impl;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.peterpet.prod.ProdBean;
import kr.co.peterpet.prod.ProdChartBean;

@Repository
public class ProdDAO {
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	public List<ProdBean> getProdList(ProdBean prod) {
		System.out.println("===> Mybatis로 getProdList() 기능 처리");
		return sqlSessionTemplate.selectList("prodDAO.getProdList", prod);
	}
	
	public ProdBean getProd(ProdBean prod) {
		System.out.println("===> Mybatis로 getProd() 기능 처리");
		return (ProdBean) sqlSessionTemplate.selectOne("prodDAO.getProd", prod);
	}
	
	public List<ProdBean> getListAjax(ProdBean prod) {
		System.out.println("===> Mybatis로 getListAjax() 기능 처리");
		return sqlSessionTemplate.selectList("prodDAO.getListAjax", prod);
	}
	
	
	// admin
	public ProdChartBean getChart() {
		System.out.println("===> Mybatis로 getChart() 기능 처리");
		int count1 = sqlSessionTemplate.selectOne("prodDAO.count1");
		int count2 = sqlSessionTemplate.selectOne("prodDAO.count2");
		int count3 = sqlSessionTemplate.selectOne("prodDAO.count3");
		ProdChartBean ProdChartBean = new ProdChartBean(count1, count2, count3);
		return ProdChartBean;
	}
	public ProdChartBean getPtype() {
	    List<Map<String, Object>> getPtypeMapList = sqlSessionTemplate.selectList("prodDAO.getPtype");
	    ProdChartBean prodChartBean = new ProdChartBean();

	    for (Map<String, Object> map : getPtypeMapList) {
	        String ptype = (String) map.get("ptype");
	        Long count = (Long) map.get("count"); // Long 타입으로 읽기, count는 ProdMapper에서의 count(*)

	        switch (ptype) {
	            case "패키지":
	                prodChartBean.setPtype1(count.intValue()); // Long을 int로 변환
	                break;
	            case "간식":
	                prodChartBean.setPtype2(count.intValue());
	                break;
	            case "미용":
	                prodChartBean.setPtype3(count.intValue());
	                break;
	            case "사료":
	                prodChartBean.setPtype4(count.intValue());
	                break;
	            case "영양제":
	                prodChartBean.setPtype5(count.intValue());
	                break;
	            case "장난감":
	                prodChartBean.setPtype6(count.intValue());
	                break;
	        }
	    }

System.out.println("dao의 차트값 : "+prodChartBean.getPtype1()+prodChartBean.getPtype2()+prodChartBean.getPtype3()+prodChartBean.getPtype4()+prodChartBean.getPtype5()+prodChartBean.getPtype6());
	    return prodChartBean;
	}
	
	public List<ProdBean> getAdProdList(ProdBean prod) {
		System.out.println("===> Mybatis로 getProdList() 기능 처리");
		return sqlSessionTemplate.selectList("prodDAO.getAdProdList", prod);
	}
	
	public void insertProd(ProdBean prod) {
		System.out.println("===> Mybatis로 insertProd() 기능 처리");
		sqlSessionTemplate.insert("prodDAO.insertProd", prod);
	}
	
	public void updateProd(ProdBean prod) {
		System.out.println("===> Mybatis로 updateProd() 기능 처리");
		sqlSessionTemplate.update("prodDAO.updateProd", prod);
	}
	
	public int deleteProd(String pcode) {
		System.out.println("===> Mybatis로 deleteProd() 기능 처리");
		sqlSessionTemplate.delete("resDAO.deleteResPcode", pcode);
		return sqlSessionTemplate.delete("prodDAO.deleteProd", pcode);
	}
	
	public String getPcode(String ptype) {
		System.out.println("===> Mybatis로 getPcode() 기능 처리");
		return sqlSessionTemplate.selectOne("prodDAO.getPcode", ptype);
	}
	public int checkPcode(String pcode) {
		System.out.println("===> Mybatis로 checkPcode() 기능 처리");
		return sqlSessionTemplate.selectOne("prodDAO.checkPcode", pcode);
	}
	public int getListCount(ProdBean prod) {
		System.out.println("===> Mybatis로 getListCount() 기능 처리");
		return sqlSessionTemplate.selectOne("prodDAO.getListCount", prod);
	}
	
	//reserve admin
	public List<ProdBean> getProdListbyPtype(ProdBean prod) {
		System.out.println("===> Mybatis로 getProdListbyPtype() 기능 처리");
		return sqlSessionTemplate.selectList("prodDAO.getProdListbyPtype", prod);
	}
}
