package kr.co.peterpet.res;

import java.util.List;

public interface ResService {
	//client
	ResBean getSelectInfo(ResBean res);
	void updatePack(ResBean res);
	int updateRes(ResBean res);
	ResBean getExist(ResBean res);
	List<ResBean> getResList(ResBean res);
	int reservePackage(ResBean resBean);
	int getReserveCount(String uid, String searchText);
	ResBean getMyRes(int rnum);
	List<ResBean> getChooseRes(List<Integer> rnum);
	
	//admin
	int insertResProd(ResBean res);
	void insertResPack(ResBean res);
	void updateAdRes(ResBean res);
	int deleteRes(int rnum);
	ResBean getRes(ResBean res);
	List<ResBean> getAdResList(ResBean res);
	
	//pay
	 int deleteResList(List<Integer> rnumList);
	
	//user
	int delete(String uId);
}
