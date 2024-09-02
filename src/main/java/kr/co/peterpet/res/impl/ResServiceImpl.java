package kr.co.peterpet.res.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import kr.co.peterpet.res.ResBean;
import kr.co.peterpet.res.ResService;

@Service("resService")
public class ResServiceImpl implements ResService{
	@Autowired
	private ResDAO resDAO;

	@Override
	public ResBean getSelectInfo(ResBean res) {
		return resDAO.getSelectInfo(res);
	}
	
	@Override
	public int insertResProd(ResBean res) {
		return resDAO.insertResProd(res);
	}
	
	@Override
	public int getReserveCount(String uid, String searchText) {
		int ReserveCount = resDAO.getReserveCount(uid, searchText);
		return ReserveCount;
	}
	
	@Override
	public List<ResBean> getResList(ResBean res) {
		return resDAO.getResList(res);
	}

	@Override
	public void insertResPack(ResBean res) {
		resDAO.insertResPack(res);
	}
	
	//admin
	@Override
	public void updateAdRes(ResBean res) {
		resDAO.updateAdRes(res);
	}

	@Override
	public List<ResBean> getAdResList(ResBean res) {
		return resDAO.getAdResList(res);
	}

	@Override
	public int updateRes(ResBean res) {
		return resDAO.updateRes(res);
	}

	@Override
	public int deleteRes(int rnum) {
		return resDAO.deleteRes(rnum);
	}

	@Override
	public ResBean getRes(ResBean res) {
		return resDAO.getRes(res);
	}
	
	@Override
	public ResBean getExist(ResBean res){
		return resDAO.getExist(res);
	}
	
	@Override
	public int delete(String uId) {
		return resDAO.delete(uId);
	}
	
	@Override
	public int reservePackage(ResBean resBean) {
		int reservePackage = resDAO.reservePackage(resBean);
		return reservePackage;
	}
	
	@Override
	public void updatePack(ResBean res) {
		resDAO.updatePack(res);
	}
	
	@Override
	public ResBean getMyRes(int rnum) {
		return resDAO.getMyRes(rnum);
	}
	
	@Override
	public List<ResBean> getChooseRes(List<Integer> rnum) {
		List<ResBean> result = new ArrayList<ResBean>();
		
		for(Integer ord : rnum) {
			
			ResBean resInfo = resDAO.getMyRes(ord);
			result.add(resInfo);			
		}		
		
		return result;
	}

	@Override
	public int deleteResList(List<Integer> rnumList) {
		return resDAO.deleteResList(rnumList);
	}
	
}
